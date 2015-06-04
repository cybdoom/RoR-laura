class AchPayment::Index < InteractionBase
  include AchPayment::Serializers

  def exec
    @ach_payments = AchPayment.all.map { |ap|
      serialize_ach_payment_as_list_item ap
    }
  end

  def as_json opts = {}
    @ach_payments
  end

end
