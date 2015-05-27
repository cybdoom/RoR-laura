class User < ActiveRecord::Base

# Validations ==================================================================
  has_secure_password
  validates :password, presence:{ on: :create }, length: {minimum: 8} 
  validates :user_id, :email, :user_id, :phone, presence: true
  
  validates :email, 
    format: { with: RE_EMAIL, message: I18n.t('user.errors.invalid_email')}
 
  
# Callbacks ===================================================================
  
  after_initialize ->(rec) { rec.devices ||= [] }

# Class methods ===============================================================
  class << self
    
    def current_user= user
      Thread.current[:current_user] = user
    end

    def current_user
      Thread.current[:current_user]
    end

  end
end
