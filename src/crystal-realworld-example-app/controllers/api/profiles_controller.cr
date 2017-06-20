module Api
  class ProfilesController < Api::BaseController
    def show
      if user = User.where({ "username" => params.url["username"] }).first
        render_as :json { { profile: user.as_json.merge({ "following:" => false }) }.to_json }
      else
        not_found
      end
    end
  end
end
