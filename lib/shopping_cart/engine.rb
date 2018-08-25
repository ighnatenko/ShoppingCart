require 'rubygems'
require 'aasm'
require 'bootstrap-sass'
require 'coffee-rails'
require 'country_select'
require 'font-awesome-rails'
require 'haml'
require 'jquery-rails'
require 'draper'
require 'wicked'
require 'rectify'
require 'rails-i18n'
require 'sass-rails'
require 'simple_form'

module ShoppingCart
  # Engine
  class Engine < ::Rails::Engine
    isolate_namespace ShoppingCart

    config.autoload_paths << File.expand_path('lib/shopping_cart/engine', __dir__)

  end
end
