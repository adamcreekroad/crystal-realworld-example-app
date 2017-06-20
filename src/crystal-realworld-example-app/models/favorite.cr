class Favorite < ActiveRecord::Model
  adapter mysql

  primary id : Int

  field user_id    : Int
  field article_id : Int
  field created_at : Time
  field updated_at : Time

  def user
    User.get(user_id.to_i)
  end

  def article
    Article.get(article_id.to_i)
  end
end
