class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.

    protect_from_forgery with: :exception

    protected

    include Passwordless::ControllerHelpers

    helper_method :current_user

    private

      def current_user
        if Rails.env.test?
          User.find_by(email: 'team_cluck_admin@gmail.com')
        else
          @current_user ||= authenticate_by_session(User)
        end
      end

      def require_user!
        return if current_user
        redirect_to users.sign_in_path, alert: "Please sign in to view this content"
      end
end
