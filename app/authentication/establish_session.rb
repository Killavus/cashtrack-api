class EstablishSession
  def call
    Session.create(secret: secret)
  end

  private
  def secret
    SecureRandom.hex
  end
end