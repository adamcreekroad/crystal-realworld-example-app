module Api
  class TagsController < Api::BaseController
    def index
      tags = Tag.all

      render_as :json { { tags: tags.map(&.name) }.to_json }
    end
  end
end
