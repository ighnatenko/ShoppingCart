$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "shopping_cart/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "shopping_cart"
  s.version     = ShoppingCart::VERSION
  s.authors     = ["ighnatenko"]
  s.email       = ["ighnatenko@meta.ua"]
  s.homepage    = "https://bookstore-x.herokuapp.com"
  s.summary     = "Summary of ShoppingCart."
  s.description = "Description of ShoppingCart."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 5.2.0"
  s.add_dependency 'haml'
  s.add_dependency 'bootstrap-sass', '~> 3.3.7'
  s.add_dependency 'sass-rails', '~> 5.0', '>= 5.0.7'
  s.add_dependency 'coffee-rails', '~> 4.2'
  s.add_dependency 'pg', '~> 0.18'
  s.add_dependency 'turbolinks', '~> 5'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'country_select'
  s.add_dependency "font-awesome-rails"
  s.add_dependency 'aasm', '~> 4.12', '>= 4.12.3'
  s.add_dependency 'simple_form'
  s.add_dependency 'draper', '~> 3.0', '>= 3.0.1'
  s.add_dependency 'rails-i18n'

  s.add_dependency  'faker', '~> 1.6', '>= 1.6.3'
  s.add_dependency 'pry', '~> 0.11.3'
  s.add_dependency 'rspec-rails', '~> 3.7'
  s.add_dependency 'database_cleaner', '~> 1.6', '>= 1.6.2'
  s.add_dependency 'factory_bot_rails'
  s.add_dependency 'rails-controller-testing', '~> 1.0', '>= 1.0.2'
  s.add_dependency 'shoulda-matchers', '~> 3.1'
  s.add_dependency 'capybara', '~> 3.0', '>= 3.0.2'
end
