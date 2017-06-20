class Article < ActiveRecord::Model
  adapter mysql

  primary id : Int

  field title           : String
  field slug            : String
  field body            : String
  field description     : String
  field favorites_count : Int
  field user_id         : Int
  field created_at      : Time
  field updated_at      : Time

  def user
    User.get(user_id.to_i)
  end

  def favorites
    Favorite.where({ "article_id" => id })
  end

  def favorited?
    favorites.any?
  end

  def as_json
    {
      slug:        slug,
      title:       title,
      description: description,
      body:        body,
      tagList:     [] of String,
      createdAt:   created_at,
      updatedAt:   updated_at,
      favorited:   favorited?,
      favoritesCount: favorites.size,
      author: {} of String => String
    }
  end

end
