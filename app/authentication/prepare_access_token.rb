class PrepareAccessToken
  AuthenticationFailed = Class.new(StandardError)

  def call(email, password, now = DateTime.now)
    user = User.find_by(email: email)
    raise AuthenticationFailed.new unless (user.present? and user.authenticate(password))
    provide_token(user, now)
  end

  private
  def provide_token(user, now)
    token = AccessToken.find_current(user, now)
    if token.present?
      token
    else
      build_token(user, now)
    end
  end

  def build_token(user, now)
    AccessToken.new.tap do |token|
      token.key = SecureRandom.hex(48)
      token.user = user
      token.expires_at = build_expiration_date_from_now(now)

      token.save!
    end
  end

  def build_expiration_date_from_now(now)
    now.advance(days: 7)
  end
end