class CreditCardsController < ApplicationController
  def index

  end


  # @description Creates new credit card with given params
  # @param credit_card[cc_number] required String Credit card number
  # @param credit_card[month] required String month
  # @param credit_card[year] required String year
  # @param credit_card[cvv] required String cvv
  # @param credit_card[zipcode] required String zipcode
  def create
    respond_with_interaction CreditCard::Create, cc_params
  rescue InteractionErrors::ActiveModelError => e
    respond_with_error e.message
  end


  # @description Updates new credit card with given params
  # @param credit_card[cc_number] required String Credit card number
  # @param credit_card[month] required String month
  # @param credit_card[year] required String year
  # @param credit_card[cvv] required String cvv
  # @param credit_card[zipcode] required String zipcode
  def update
    respond_with_interaction CreditCard::Update, cc_params.update(id: params[:id])
  rescue InteractionErrors::CreditCardNotFound
    respond_with_error I18n.t('credit_card.errors.not_found'), 404
  rescue InteractionErrors::ActiveModelError => e
    respond_with_error e.message
  end

  def destroy

  end

  private

  def cc_params
    params.require(:credit_card).permit :cc_number, :month, :year, :cvv, :zipcode
  end
end
