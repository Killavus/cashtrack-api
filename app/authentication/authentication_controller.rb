class AuthenticationController < ApplicationController
  def create
    token = prepare_access_token.(token_creation_params[:email], token_creation_params[:password])
    render json: { token_key: token.key, expires_at: token.expires_at.iso8601 }
  rescue PrepareAccessToken::AuthenticationFailed
    head :forbidden
  end

  def index
    render json: {
             id: authenticated_user.id,
             email: authenticated_user.email
           }
  end

  private
  def prepare_access_token
    PrepareAccessToken.new
  end

  def token_creation_params
    params.require(:user).permit(:email, :password)
  end
end
