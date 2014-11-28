class SessionsController < ApplicationController
  def create
    establish_session = EstablishSession.new
    establish_session.()
    head :created
  end
end