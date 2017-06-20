Conduit.application.route do
  # Article routes
  get    "/api/articles",       to: "api/articles#index"
  # get    "/api/articles/feed",  to: "api/articles#feed"
  # get    "/api/articles/:slug", to: "api/articles#show"
  # post   "/api/articles",       to: "api/articles#create"
  # put    "/api/articles/:slug", to: "api/articles#update"
  # delete "/api/articles/:slug", to: "api/articles#destroy"

  # Comment routes
  # post   "/api/articles/:slug/comments",     to: "api/comments#create"
  # get    "/api/articles/:slug/comments",     to: "api/comments#show"
  # delete "/api/articles/:slug/comments/:id", to: "api/comments#destroy"

  # Favorite routes
  # post   "/api/articles/:slug/favorite", to: "api/favorites#create"
  # delete "/api/articles/:slug/favorite", to: "api/favorites#destroy"

  # Follow routes
  # post   "/api/profiles/:username/follow", to: "api/profiles#follow"
  # delete "/api/profiles/:username/follow", to: "api/profiles#destroy"

  # Profile routes
  get    "/api/profiles/:username",        to: "api/profiles#show"

  # Session routes
  post "/api/users/login", to: "api/sessions#create"

  # Tag routes
  get "/api/tags", to: "api/tags#index"

  # User routes
  post "/api/users",       to: "api/users#create"
  get  "/api/user",        to: "api/users#show"
  put  "/api/user",        to: "api/users#update"
end
