class SessionsController < ApplicationController
  def create
    session = establish_session.()
    render json: { session_id: session.id, secret: session.secret }
  end

  def link_with_user
    link_session_with_user.(link_user_params[:session_id], 
                            link_user_params[:session_secret], 
                            link_user_params[:user_id])
    head :ok
  rescue LinkSessionWithUser::AlreadyLinked
    head :unprocessable_entity
  rescue LinkSessionWithUser::InvalidSecret
    head :forbidden
  rescue LinkSessionWithUser::SessionNotFound
    render json: { error: [:session_not_found] }, status: :not_found
  rescue LinkSessionWithUser::UserNotFound
    render json: { error: [:user_not_found] }, status: :not_found
  end

  private
  def link_user_params
    params.permit(:user_id, :session_id, :session_secret)
  end

  def establish_session
    EstablishSession.new
  end

  def link_session_with_user
    LinkSessionWithUser.new
  end
end
