# frozen_string_literal: true

# Base controller for the application
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound do |_exception|
    render plain: 404, status: :not_found
  end

  private

  def user_trips
    Trip.where(username: current_user)
  end

  def current_user
    request.headers[:HTTP_X_FORWARDED_USER]
  end
end
