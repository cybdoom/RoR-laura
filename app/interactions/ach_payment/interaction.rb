class AchPayment::Interaction < InteractionBase
  include AchPayment::Serializers
  include User::Serializers

  attr_accessor :ach_payment

  def as_json opts = {}
    user_info = serialize_user_general_info @current_user
    serialize_ach_payment(@ach_payment).update user_info
  end

end
