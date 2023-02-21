class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    include Passwordless::ControllerHelpers

    helper_method :current_user

    private

      def current_user
        @current_user ||= authenticate_by_session(User)
      end

      def require_user!
        return if current_user
        redirect_to users.sign_in_path, alert: "Please sign in to view this content"
      end

    # def configure_permitted_parameters
    #   devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password])
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:firstname, :lastname, :password, :current_password])
    # end
end
