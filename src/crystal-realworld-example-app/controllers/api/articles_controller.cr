require "./base_controller"

module Api
  class ArticlesController < Api::BaseController
    def index
      if articles = Article.all
        render_as :json { { articles: articles.map(&.as_json) }.to_json }
      else
        render_as :json { { articles: [] of Nil }.to_json }
      end
    end
  end
end
