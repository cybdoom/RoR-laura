module Bill::Serializers
  include User::Serializers

  BILL_ATTRIBUTES = %i(
    bill_type
    status
    payment_status
    payed_amount
    payed_date
  )

  def serialize_bill ach_payment
    bill = BILL_ATTRIBUTES.inject({}){ |a,m| a.update m => @bill.send(m) }
    bill.merge bill_user_info
  end

  def bill_user_info

    case @bill.bill_type
      when 'parking_ticket'
        serialize_user_driver_license_info @bill.user
      else
        serialize_user @bill.user
    end
  end

  def serialize_bill_as_list_item ach_payment
    {
      # last_digits: bill.account_nr.split('').last(3).join,
      # default_photo: bill.ap_type
    }
  end
end
