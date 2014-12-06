class ApplicationController < ActionController::Base
  rescue_from AuthenticateViaToken::TokenInvalid, with: :handle_invalid_token
  rescue_from AuthenticateViaToken::TokenNotFound, with: :handle_not_existing_token

  protected
  def render_validation_errors(exception)
    render status: :unprocessable_entity, json: { errors: exception.record.errors.messages }
  end

  def authenticated_user
    authenticate_via_token.(request.headers['X-Authentication-Token'])
  end

  def authenticate_via_token
    AuthenticateViaToken.new
  end

  def handle_invalid_token(exception)
    render status: :forbidden, json: { error: { message: exception.message } }
  end

  def handle_not_existing_token(exception)
    render status: :forbidden, json: { error: { message: 'authentication token not found - obtain one using POST /authentication/create' } }
  end

  def handle_invalid_session_secret
    render status: :forbidden, json: { error: { message: 'session secret is invalid' } }
  end
end
