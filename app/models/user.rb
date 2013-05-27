class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :password, :profile_name, :trust_level, :user_type, :pic

#--------- relationships  ----------#
  belongs_to :admins
  has_many :posts, dependent: :destroy
  has_many :complaints
  has_many :comments, dependent: :destroy
  has_attached_file :pic,:default_url => 'defaultpic.PNG', dependent: :destroy
  has_many :user_friendships, dependent: :destroy
  has_many :friends, through: :user_friendships,
           conditions: { user_friendships: { state: 'accepted' } }, dependent: :destroy

  has_many :pending_user_friendships, class_name: 'UserFriendship',
           foreign_key: :user_id,
           conditions: { state: 'pending' }, dependent: :destroy
  has_many :pending_friends, through: :pending_user_friendships, source: :friend, dependent: :destroy
  has_reputation :votes, source: {reputation: :votes, of: :posts}, aggregated_by: :sum, dependent: :destroy
  has_secure_password

  #------- callbacks ----------#
  before_save { |user| user.email = email.downcase }
  before_create :create_remember_token


  #-------- validations --------#
  validates :first_name, presence: true, length: {maximum: 30}, :on => :create
  validates :last_name, presence: true, length: {maximum: 40}, :on => :create
  validates :profile_name, presence: true, uniqueness: true, length: {maximum: 25}, :on => :create
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with:VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false}, :on => :create
  validates :password, presence: true, length: {minimum: 6}, :on => :create


  def full_name
    first_name + " " + last_name
  end


  def self.search(search_query)
    if search_query
      where (['first_name ILIKE ? OR last_name ILIKE ? OR profile_name ILIKE ?', "%#{search_query}%",
                                 "%#{search_query}%", "%#{search_query}%"])
    else
      scoped
    end
  end

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
