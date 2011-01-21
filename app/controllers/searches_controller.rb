class SearchesController < ApplicationController
  layout :choose_layout
  def index
    @results = Article.search params[:q], :with_all => {:author_ids => params[:author_ids], :photographer_ids => params[:photographer_ids], :category_ids => params[:category_ids]}
  end

  def add_advanced_search_form
    @authors = Author.all
    @photographers = Photographer.all
    @categories = Category.all
  end

  private
  def choose_layout
    if ['index'].include? action_name
      'list_of_articles'
    else
      'articles'
    end
  end
end
