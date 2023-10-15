Rails.application.routes.draw do
  root to: "home#index"

  # reload 対策
  get "sign_up", to: "home#index"
  get "sign_in", to: "home#index"
  get "articles/new", to: "home#index"
  get "articles/:id", to: "home#index"

  # get '/articles/drafts', to: 'api/v1/articles/drafts#index'
  # get '/articles/drafts/:id', to: 'api/v1/articles/drafts#show'


  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations",
      }
      namespace :current do
        get "articles", to: "articles#index"
      end
      resources :articles do
      #Task11-3で追記（draftのみ開くメソッド）
      # namespace :articles do
      # scope module: :articles
      # concern :articles do
        collection do
         resources :drafts, only: [:index,:show]
        #  resources :drafts, only: [:index,:show], controller: 'drafts'
       end
      end
        # get 'articles/draft', to: 'drafts#index'
        # get 'articles/draft/:id', to: 'drafts#show'
    end
  end
end
