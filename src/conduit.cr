require "kemal"
require "json"
require "yaml"
require "jwt"
require "crypto/bcrypt"
require "active_record"
require "mysql_adapter"
require "./crystal-realworld-example-app/**"

# App config
APP_CONFIG = YAML.parse(File.read("config/application.yml"))["development"]
ENV["SECRET_KEY_BASE"] = APP_CONFIG["secret_key_base"].as_s

# DB config
DB_CONFIG = YAML.parse(File.read("config/database.yml"))["development"]
ENV["MYSQL_HOST"]     = DB_CONFIG["host"].as_s
ENV["MYSQL_USER"]     = DB_CONFIG["username"].as_s
ENV["MYSQL_PASSWORD"] = DB_CONFIG["password"].as_s
ENV["MYSQL_DATABASE"] = DB_CONFIG["database"].as_s
ENV["MYSQL_PORT"]     = DB_CONFIG["port"].as_s || "3306"

module Conduit
  def self.application
    @@application ||= Crails::Application.new
  end
end

require "../config/routes.cr"

Conduit.application.initialize!
