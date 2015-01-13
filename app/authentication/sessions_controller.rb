class SessionsController < ApplicationController
  def create
    session = establish_session.()
    render json: { session_id: session.id, secret: session.secret }
  end

  private
  def establish_session
    EstablishSession.new
  end
end