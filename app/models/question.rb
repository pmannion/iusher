class Question < ActiveRecord::Base
  attr_accessible :body, :category, :email, :name

  CATEGORY_TYPES = ['General inquiry','Cinema Registration', 'Information about iUsher', 'Report Abuse', 'Contact the Developer']

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, presence: true
  validates :category, presence: true
  validates :body, presence: true

end
