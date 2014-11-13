class ApplicationController < ActionController::Base
  protected
  def render_validation_errors(exception)
    render status: :unprocessable_entity, json: { errors: exception.record.errors.messages }
  end
end
