class CreditCard < ActiveRecord::Base
  belongs_to :user
  validates :cc_number, :month, :year, :cvv, :zipcode, presence: true,
    length: { maximum: STRING_LENGTH}

  def card_holder_name
    user.full_name
  end
end
