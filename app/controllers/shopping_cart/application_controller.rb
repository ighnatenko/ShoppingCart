module ShoppingCart
  # ApplicationController
  class ApplicationController < ::ApplicationController
    include ShoppingCart::Concerns::CurrentOrder
    # include ShoppingCart::Concerns::Locale
    layout 'application'
    protect_from_forgery with: :exception
    before_action :present_order#, :set_locale

    [CanCan::AccessDenied, ActiveRecord::RecordNotFound,
     ActionController::RoutingError].each do |error|
      rescue_from error do |exception|
        redirect_to main_app.root_path, alert: exception.message
      end
    end
  end
end
