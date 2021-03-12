# Adds time-based One Time Passwords (TOTPs) for user authentication
#
# Requires fields on User model:
# * otp_required:boolean
# * last_otp_at:integer
# * otp_secret

module TwoFactorAuthentication
  extend ActiveSupport::Concern

  def enable_two_factor!
    args = {otp_required_for_login: true}
    args[:otp_secret] = ROTP::Base32.random unless otp_secret?
    update!(args)
  end

  def disable_two_factor!
    update!(otp_required_for_login: false, otp_secret: nil)
  end

  def otp_required_for_login?
    true
  end

  def otp
    ROTP::TOTP.new(otp_secret, issuer: Jumpstart.config.application_name)
  end

  def otp_provisioning_uri
    otp.provisioning_uri(email)
  end

  def current_otp
    otp.now
  end

  def verify_and_consume_otp!(code)
    return false if code.blank?
    return consume_otp! if verify_otp(code)
    false
  end

  private

  # Verify with 15 second drift
  def verify_otp(code)
    otp.verify(code, after: last_otp_timestep, drift_behind: 15)
  end

  # No valid OTP may be used more than once for a given timestep
  def consume_otp!
    if last_otp_timestep != current_otp_timestep
      update_attribute(:last_otp_timestep, current_otp_timestep)
    else
      false
    end
  end

  def current_otp_timestep
    Time.now.utc.to_i / otp.interval
  end
end
