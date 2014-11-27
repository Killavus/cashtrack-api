class LinkSessionWithUser
  SessionNotFound = Class.new(StandardError)
  UserNotFound    = Class.new(StandardError)
  InvalidSecret   = Class.new(StandardError)
  AlreadyLinked   = Class.new(StandardError)

  def call(session_id, session_secret, user_id)
    session = Session.find(session_id)
    raise InvalidSecret.new unless secret_matches?(session, session_secret)
    raise AlreadyLinked.new if session.linked?

    link_with_user(session, user_id)
  rescue ActiveRecord::RecordNotFound
    raise SessionNotFound.new
  end

  private
  def secret_matches?(session, secret)
    session.secret == secret
  end

  def link_with_user(session, user_id)
    user = User.find(user_id)
    session.user = user
    session.save
  rescue ActiveRecord::RecordNotFound
    raise UserNotFound.new
  end
end