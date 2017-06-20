module Api
  class SessionsController < Api::BaseController
    def create
      user = find_user_from_email

      render_as :json do
        if user.is_a?(User) && authorized?(user)
          { user: user.as_json }.to_json
        else
          response.status_code = 422
          {
            errors: {
              credentials: "are invalid"
            }
          }.to_json
        end
      end
    end

    protected def find_user_from_email
      User.where({ "email" => user_params["email"].as_s }).first
    end

    protected def user_params
      # Ugly but for now works
      @user_params ||= JSON.parse(params.json["user"].to_json)
    end

    protected def authorized?(user)
      return false unless user && user.is_a?(User)

      encrypted_password_param =
        Crypto::Bcrypt.new(user_params["password"].as_s, user.password_salt.to_s).to_s

      user.encrypted_password == encrypted_password_param
    end
  end
end
