class Complaint < ActiveRecord::Base
  attr_accessible :branch, :comment, :latitude, :longitude, :screen, :seat, :admin_id, :status
  validates :admin_id, presence: true
  validates :screen, presence: true
  validates :seat, presence: true

  belongs_to :user
  belongs_to :admin


  STATUS_TYPES = ["confirmed", "pending"]


  def trust_level
    if admin.nil?
      return 'high'
    end
    tolerance_long = 0.20
    tolerance_lat = 0.20

    if self.longitude >= admin.longitude - tolerance_long && self.longitude <= admin.longitude + tolerance_long &&
        self.latitude >= admin.latitude - tolerance_lat && self.latitude <= admin.latitude + tolerance_lat
      'high'
    else
      'low'
    end
  end
end








