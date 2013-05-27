class Admin < ActiveRecord::Base
  attr_accessible :company, :branch, :email, :latitude, :longitude, :password, :pic
  #--------------------- callbacks-------------------#
  before_save { |admin| admin.email = email.downcase }
  before_create :create_remember_token

  # ----------------- relationships  ----------------#
  has_secure_password
  has_many :posts, dependent: :destroy
  has_many :complaints
  has_many :users
  has_attached_file :pic, default_url: 'defaultpic.PNG'
  has_reputation :votes, source: {reputation: :votes, of: :posts}, aggregated_by: :sum

  #---------------- validations ---------------------#
  validates :branch, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :latitude, presence: true
  validates :password, presence: true, length: {minimum: 8}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with:VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false}


  def user_type
    "Cinema group"
  end

  def title
    company + " - " +branch
  end

  def self.search(search_query)
    if search_query
      where (['branch ILIKE ? OR company ILIKE ?', "%#{search_query}%",
              "%#{search_query}%"])
    else
      scoped
    end
  end


  private

  #adds a remember(session) token to self(admin), is added before the admin saves to the database - see callback
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
