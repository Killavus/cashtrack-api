class SessionsController < ApplicationController
  def create
    establish_session = EstablishSession.new
    session = establish_session.()
    render json: { session_id: session.id, secret: session.secret }
  end
end