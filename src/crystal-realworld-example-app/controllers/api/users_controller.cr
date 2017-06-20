module Api
  class UsersController < Api::BaseController
    def show
      if user = find_user_from_token
        render_as :json { { user: user.as_json }.to_json }
      else
        not_found
      end
    end

    def create
      user = User.new

      user.email      = user_params["email"].as_s
      user.username   = user_params["username"].as_s
      user.password   = user_params["password"].as_s
      user.created_at = Time.now
      user.updated_at = Time.now

      user.create

      render_as :json { { user: user.as_json }.to_json }
    end

    def update
      if user = find_user_from_token
        user.email    = user_params["email"].as_s if user_params["email"]?
        user.username = user_params["username"].as_s if user_params["username"]?
        user.password = user_params["password"].as_s if user_params["password"]?
        user.image    = user_params["image"].as_s if user_params["image"]?
        user.bio      = user_params["bio"].as_s if user_params["bio"]?

        user.update

        render_as :json { { user: user.as_json }.to_json }
      else
        not_found
      end
    end

    protected def find_user_from_token
      payload, header = JWT.decode(authorization_token, ENV["SECRET_KEY_BASE"], "HS256")

      user_id = payload["user_id"]

      User.get(user_id) if user_id.is_a?(Int)
    end

    protected def authorization_token
      request.headers["Authorization"].split("Token ").last
    end

    protected def user_params
      # Ugly but for now works
      @user_params ||= JSON.parse(params.json["user"].to_json)
    end
  end
end
