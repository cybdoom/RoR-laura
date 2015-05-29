class User < ActiveRecord::Base

# Validations ==================================================================
  has_secure_password
  validates_confirmation_of :password
  validates :email, :phone,  uniqueness: true
  validates :password, presence:{ on: :create }, length: {minimum: 8, on: :create} 
  validates :user_id, :email, :user_id, :phone, presence: true
  
  validates :email, 
    format: { with: RE_EMAIL, message: I18n.t('user.errors.invalid_email')}

 validates :first_name, :middle_name, :last_name, :license_plate_number, 
   :license_plate_state, :driver_license, :driver_license_state, :state, :address, 
   length: { maximum: STRING_LENGTH, allow_blank: true }


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
      
      return unless user

      user.current_authentication_token = {device_id => token}
      User.current_user = user 

    end
  end # Class methods

# Instance methods ===========================================================
  #
  def error_messages
    errors.messages
  end

  def add_auth_token token
    update devices: devices.merge(token)
    @current_authentication_token = token
  end
  

end
