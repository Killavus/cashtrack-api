class RetrieveCurrentSession
  SessionNotFound = Class.new(StandardError)
  LinkedToUser = Class.new(StandardError)

  def call(session_id, session_secret)
    Session.find_by(id: session_id, secret: session_secret).tap do |session|
      raise SessionNotFound.new unless session
      raise LinkedToUser.new if session.linked?
      session
    end
  end
end