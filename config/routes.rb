Rails.application.routes.draw do
  root to: "home#index"

  namespace :api do
    namespace :v1 do
      # mount_devise_token_auth_for "User", at: "auth" #Task9-1まで
      # Task9-1で変更（https://zenn.dev/925rycki/articles/00098405e50107をまんまコピペ）
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations'
      }
      resources :articles
    end
  end
end
