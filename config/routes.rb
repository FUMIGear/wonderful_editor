Rails.application.routes.draw do
  resources :sample_articles
  # resources :sample_articles, :article # この方法でもいいが、sample_articleは後で消すから分けた。
  # resources :article, path: '/api/v1/articles'
  # mount_devise_token_auth_for "User", at: "/api/v1/auth" #path:とat:は同じ意味かも
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # Task7-1：模範回答
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth" #Task5-3で自動追加
      resources :articles # Task7-1で追加
    end
  end
end
