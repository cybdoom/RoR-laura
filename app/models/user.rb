class User < ActiveRecord::Base

  # Validations ==================================================================
  has_secure_password
  validates_confirmation_of :password
  validates :email, :phone,  uniqueness: true
  validates :password, presence:{ on: :create }
  validates :password, length: {minimum: 8}, allow_nil: { on: :update }

  validates :user_id, :email, :user_id, :phone, presence: true

  validates :email,
    format: { with: RE_EMAIL, message: I18n.t('user.errors.invalid_email')}

  validates :first_name, :middle_name, :last_name, :license_plate_number,
    :license_plate_state, :driver_license, :driver_license_state, :state, :address,
    length: { maximum: STRING_LENGTH, allow_blank: true }


  has_many :password_recovery_tokens

  after_initialize ->(rec) { rec.devices ||= {} }

  # Class methods ===============================================================
  class << self
    def find_by_auth_token device_id, token
      user = where( "devices -> ? ->> 'authentication_token' = ?", device_id, token).first
      return unless user
      user
    end
  end # Class methods

  # Instance methods ===========================================================
  #
  def error_messages
    errors.messages
  end

  def add_auth_token token
    update devices: devices.merge(token)
  end

  def remove_token token
    update devices: devices.except(token)
  end

end
