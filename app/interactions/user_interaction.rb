class UserInteraction < Interaction
  
  attr_accessor :user

  def initialize(params, headers)
    @headers = headers
  end

  
  def as_json opts = {}
    return {} unless mobile_headers_valid? 
    JsonSerializers::User.new(@user)
  end
  
  
  def status_code
    (@user.valid? && mobile_headers_valid?) ? 200 : 422
  end
end
