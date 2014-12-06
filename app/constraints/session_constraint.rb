class SessionConstraint
  def self.matches?(request)
    request.headers['X-Session-Id'].present?
  end
end