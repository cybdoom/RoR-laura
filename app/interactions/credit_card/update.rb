class CreditCard::Update < Interaction
  include CreditCard::Serializers
  attr_accessor :credit_card


  def exec
    check_credit_card!
    @credit_card.update @args.except(:id)
    unless @credit_card.valid?
      raise InteractionErrors::ActiveModelError.new @credit_card.errors
    end
  end

  def as_json opts = {}
    serialize_credit_card @credit_card
  end

  def check_credit_card!
    @credit_card = @current_user.credit_cards.find_by id: @args[:id]
    raise InteractionErrors::CreditCardNotFound unless @credit_card
  end
end
