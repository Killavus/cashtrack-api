class UserConstraint
  def self.matches?(request)
    request.headers['X-Authentication-Token'].present?
  end
end