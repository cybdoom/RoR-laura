class Bill::Create < Bill::Interaction
  def exec
    @bill = @current_user.bills.create @args
    unless @bill.valid?
      raise InteractionErrors::ActiveModelError.new @bill.errors
    end
  end
end
