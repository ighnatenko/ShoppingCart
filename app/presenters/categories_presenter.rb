# frozen_string_literal: true

module ShoppingCart
  # CategoriesPresenter
  class CategoriesPresenter < Rectify::Presenter
    include ApplicationHelper
    attribute :params
    attribute :books, Book
    attribute :category, Category

    def page_number
      params[:page].present? ? params[:page].to_i + 1 : 1
    end

    def filter
      params[:filter].present? ? params[:filter] : Book::DEFAULT_FILTER
    end

    def active_more_btn
      return books.size != Book.count unless params[:id]
      books.size != qunatity_book_in_category(category.id)
    end
  end
end
