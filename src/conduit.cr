require "kemal"
require "json"
require "yaml"
require "jwt"
require "crypto/bcrypt"
require "active_record"
require "mysql_adapter"
require "./crystal-realworld-example-app/*"

app_config = YAML.parse(File.read("config/application.yml"))["development"]
ENV["SECRET_KEY_BASE"] = app_config["secret_key_base"].as_s

# DB Config
db_config = YAML.parse(File.read("config/database.yml"))["development"]
ENV["MYSQL_HOST"]     = db_config["host"].as_s
ENV["MYSQL_USER"]     = db_config["username"].as_s
ENV["MYSQL_PASSWORD"] = db_config["password"].as_s
ENV["MYSQL_DATABASE"] = db_config["database"].as_s
ENV["MYSQL_PORT"]     = db_config["port"].as_s || "3306"

module Conduit
  class Application
    post "/api/users/login" do |env|
      env.response.content_type = "application/json"

      # Ugly but for now works
      user_params = JSON.parse(env.params.json["user"].to_json)

      user = find_user_from_email(user_params["email"].as_s)

      if user && authorized?(user, user_params["password"].as_s)
        { user: user.as_json }.to_json
      else
        {
          errors: {
            credentials: "are invalid"
          }
        }.to_json
      end
    end

    options "/api/users" do |env|
      env.response.headers["Access-Control-Allow-Origin"] = "*"
      env.response.headers["Access-Control-Allow-Methods"] = "POST, GET, PUT, DELETE, OPTIONS"
      env.response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization, X-Requested-With"

      ""
    end

    post "/api/users" do |env|
      env.response.headers["Access-Control-Allow-Origin"] = "*"
      env.response.headers["Access-Control-Allow-Methods"] = "POST, GET, PUT, DELETE, OPTIONS"
      env.response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization, X-Requested-With"
      env.response.content_type = "application/json"

      # Ugly but for now works
      user_params = JSON.parse(env.params.json["user"].to_json)

      user = User.new
      user.email = user_params["email"].as_s
      user.username = user_params["username"].as_s
      user.password = user_params["password"].as_s
      user.created_at = Time.now
      user.updated_at = Time.now

      user.create

      { user: user.as_json }.to_json
    end

    get "/api/user" do |env|
      env.response.content_type = "application/json"

      user = find_user_from_token(env.request.headers["Authorization"].split("Token ").last)

      { user: user.as_json }.to_json if user.is_a?(User)
    end

    def self.authorized?(user : User, password : String)
      encrypted_password_param = Crypto::Bcrypt.new(password, user.password_salt.to_s).to_s

      user.encrypted_password == encrypted_password_param
    end

    def self.find_user_from_email(email : String)
      User.where({ "email" => email }).first
    end

    def self.find_user_from_token(token : String)
      payload, header = JWT.decode(token, ENV["SECRET_KEY_BASE"], "HS256")

      user_id = payload["user_id"]

      User.get(user_id) if user_id.is_a?(Int)
    end
  end
end

Kemal.run
