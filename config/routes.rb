Rails.application.routes.draw do
  resources :sample_articles
  # resources :sample_articles, :article # この方法でもいいが、sample_articleは後で消すから分けた。
  resources :article, path: '/api/v1/articles'
  mount_devise_token_auth_for "User", at: "auth"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # 模範回答
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth"
      resources :articles
    end
  end
end
