class AchPayment < ActiveRecord::Base

  validates :routing_nr, :first_name, :last_name, :middle_name, :account_nr,
    length: { maximum: STRING_LENGTH }, presence: true
  belongs_to :user

end
