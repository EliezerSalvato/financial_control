class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  has_scope :page, default: 1

  has_scope :filter, type: :default do |_controller, scope, values|
    JSON.parse(values).each do |filter_name, filter_value|
      scope = scope.send(filter_name, filter_value) if filter_value.present?
    end

    scope
  end

  def configure_permitted_parameters
    added_attrs = [:user_name, :email, :first_name, :last_name, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit(:sign_in, keys: added_attrs)
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  def render_json(status, json = {})
    render status: status, json: json
  end
end
