class UserProfileInteraction < UserInteraction

  def initialize(params, headers)
    super
    @user = User.current_user
  end
 
end
