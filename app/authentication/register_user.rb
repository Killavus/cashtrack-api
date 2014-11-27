class RegisterUser
  AlreadyRegistered = Class.new(StandardError)
  ValidationFailed  = Class.new(StandardError)

  def call(email, password)
    raise AlreadyRegistered.new if user_exists?(email)
    User.create!(email: email, password: password)
  rescue ActiveRecord::RecordInvalid
    raise ValidationFailed.new
  end

  private
  def user_exists?(email)
    User.find_by(email: email).present?
  end
end