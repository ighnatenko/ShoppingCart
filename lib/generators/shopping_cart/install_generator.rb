module ShoppingCart
  class InstallGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('templates', __dir__)

    def install
      # run 'bundle install'
      route "mount ShoppingCart::Engine => '/shopping_cart', as: 'shopping_cart'"
      copy_file 'shopping_cart.rb', "config/initializers/shopping_cart.rb"
      rake 'shopping_cart:install:migrations'
      # rake 'db:migrate'
    end
  end
end