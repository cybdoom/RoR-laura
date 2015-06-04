class AchPayment::Interaction < InteractionBase
  include AchPayment::Serializers

  attr_accessor :ach_payment

  def as_json opts = {}
    serialize_ach_payment(@ach_payment)
  end

end
