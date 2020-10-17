# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  # Devise: Path for sending users to after they log in or register
  def after_sign_in_path_for(_resource)
    stored_location_for(:user) || hunts_path
  end
end
