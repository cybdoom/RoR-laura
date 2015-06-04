module AchPayment::Serializers
  ACH_PAYMENT_ATTRIBUTES = %i(
    routing_nr
    account_nr
    first_name
    middle_name
    last_name
  )

  def serialize_ach_payment ach_payment
    ACH_PAYMENT_ATTRIBUTES.inject({}){ |a,m| a.update m => ach_payment.send(m) }
  end


end
