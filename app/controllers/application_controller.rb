class ApplicationController < ActionController::Base
  rescue_from AuthenticateViaToken::TokenInvalid, with: :handle_invalid_token
  rescue_from AuthenticateViaToken::TokenNotFound, with: :handle_not_existing_token
  rescue_from RetrieveCurrentSession::SessionNotFound, with: :handle_not_found_session

  protected
  def authenticated_user
    authenticate_via_token.(request.headers['X-Authentication-Token'])
  end

  def current_session
    authenticated_user.current_session
  rescue User::SessionNotFound, AuthenticateViaToken::TokenInvalid, AuthenticateViaToken::TokenNotFound
    retrieve_current_session.(request.headers['X-Session-Id'], request.headers['X-Session-Secret'])
  end

  def authorization_adapter
    @authorization_adapter ||= AuthorizationAdapter.new
    @authorization_adapter.use(UserAuthorizationStrategy.new(authenticated_user))
  rescue AuthenticateViaToken::TokenInvalid, AuthenticateViaToken::TokenNotFound
    @authorization_adapter.use(SessionAuthorizationStrategy.new(current_session))
  end

  def authenticate_via_token
    AuthenticateViaToken.new
  end

  def retrieve_current_session
    RetrieveCurrentSession.new
  end

  def render_validation_errors(exception)
    render status: :unprocessable_entity, json: { errors: exception.record.errors.messages }
  end

  def handle_invalid_token(exception)
    render status: :forbidden, json: { error: { message: exception.message } }
  end

  def handle_not_existing_token(_)
    render status: :forbidden, json: { error: { message: 'authentication token not found - obtain one using POST /authentication/create' } }
  end

  def handle_not_found_session(_)
    render status: :forbidden, json: { error: { message: "can't find session - make sure you've created it or authenticate correctly and pass an authentication token or X-Session-Id/X-Session-Secret headers pair." } }
  end

  def handle_invalid_session_secret
    render status: :forbidden, json: { error: { message: 'session secret is invalid' } }
  end
end
