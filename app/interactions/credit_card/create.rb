class CreditCard::Create < Interaction
  include CreditCard::Serializers
  attr_accessor :credit_card

  def exec
    @credit_card = @current_user.credit_cards.create @args
    unless @credit_card.valid?
      raise InteractionErrors::ActiveModelError.new @credit_card.errors
    end
  end

  def as_json opts = {}
    serialize_credit_card @credit_card
  end
end
