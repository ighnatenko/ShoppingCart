module ShoppingCart::Concerns::Locale
  extend ActiveSupport::Concern

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(*)
    { locale: I18n.locale }
  end
end
