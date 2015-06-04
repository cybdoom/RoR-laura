class AchPayment < ActiveRecord::Base

  validates_presence_of :routing
  validates :routing, length: { maximum: STRING_LENGTH }
  belongs_to :user

end
