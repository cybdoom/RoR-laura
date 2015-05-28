class UpdateUserProfileInteraction < UserInteraction
  
  def initialize(params, headers)
    super
    update_user params
  end

  private

    def update_user params
      @user = User.current_user

      @user.update params

      UserNotifier.profile_updated @user if @user.valid?
    end


end
