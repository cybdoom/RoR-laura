class PasswordRecoveryToken < ActiveRecord::Base
  belongs_to :user
  before_save ->(rec){ rec.token ||= Authentication::Token.new.generate}

end
