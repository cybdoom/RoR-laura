class User < ActiveRecord::Base

# Validations ==================================================================
  has_secure_password
  validates_confirmation_of :password
  validates :password, presence:{ on: :create }, length: {minimum: 8, on: :create} 
  validates :user_id, :email, :user_id, :phone, presence: true
  
  validates :email, 
    format: { with: RE_EMAIL, message: I18n.t('user.errors.invalid_email')}

 validates :first_name, :middle_name, :last_name, :license_plate_number, 
   :license_plate_state, :driver_license, :driver_license_state, :state, :address, 
   length: { minimum: STRING_LENGTH, allow_blank: true }


 attr_accessor :current_authentication_token
  
# Callbacks ===================================================================
  
  after_initialize ->(rec) { rec.devices ||= {} }

# Class methods ===============================================================
  class << self
    
    def current_user= user
      Thread.current[:current_user] = user
    end

    def current_user
      Thread.current[:current_user]
    end
    

    def find_by_auth_token device_id, token
      user = where( "devices ->> ? = ?", device_id, token).first
      User.current_user = user if user
    end
  end # Class methods

# Instance methods ===========================================================

  

end
