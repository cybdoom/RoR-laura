class Bill::Index < InteractionBase
  include Bill::Serializers

  def exec
    @bills = Bill.all.map { |ap|
      serialize_bill_as_list_item ap
    }
  end

  def as_json opts = {}
    @bills
  end

end
