class User < ActiveRecord::Model
  adapter mysql

  primary id : Int

  field email              : String
  field encrypted_password : String
  field password_salt      : String
  field username           : String
  field bio                : String
  field image              : String
  field created_at         : Time
  field updated_at         : Time

  def articles
    Article.where({ "user_id" => id })
  end

  def favorites
    Favorite.where({ "user_id" => id })
  end

  def as_json
    {
      "email" => email,
      "token" => token,
      "username" => username,
      "bio" => bio,
      "image" => image
    }
  end

  def token
    payload = { "user_id" => id }

    JWT.encode(payload, ENV["SECRET_KEY_BASE"], "HS256")
  end

  def password=(value : String)
    self.password_salt = SecureRandom.base64 unless password_salt.is_a?(String)
    self.encrypted_password = Crypto::Bcrypt.new(value, password_salt.to_s).to_s
  end
end
