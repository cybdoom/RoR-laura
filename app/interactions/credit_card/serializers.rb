module CreditCard::Serializers

  CREDIT_CARD_ATTRIBUTES = %i{
    cc_number
    month
    year
    cvv
    zipcode
    card_holder_name
  }

  def serialize_credit_card credit_card
    CREDIT_CARD_ATTRIBUTES.inject({}){ |a,m| a.update m => credit_card.send(m) }
  end

end
