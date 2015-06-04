module AchPayment::Serializers
  ACH_PAYMENT_ATTRIBUTES = %i(
    routing
  )

  def serialize_ach_payment ach_payment
    ACH_PAYMENT_ATTRIBUTES.inject({}){ |a,m| a.update m => ach_payment.send(m) }
  end


end
