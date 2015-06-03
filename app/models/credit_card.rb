class CreditCard < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :cc_number, :month, :year, :cvv, :zipcode

  def card_holder_name
    user.full_name
  end
end
