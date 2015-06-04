class CreditCard::Index < InteractionBase
  include CreditCard::Serializers

  def exec
    @credit_cards = CreditCard.all.map { |cc|
      serialize_credit_card_as_list_item cc
    }
  end

  def as_json opts = {}
    @credit_cards
  end

end
