class AchPaymentsController < ApplicationController

  # @description Creates new ACH Payment
  # @param ach_payment[routing] required String Routing
  def create
    respond_with_interaction AchPayment::Create, ach_payment_params
  rescue InteractionErrors::ActiveModelError => e
    respond_with_error e.message
  end


  private

  def ach_payment_params
    params.require(:ach_payment).permit :routing
  end
end
