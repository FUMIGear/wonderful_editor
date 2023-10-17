# https://zenn.dev/925rycki/articles/00098405e50107をまんまコピペした。
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # allow do
  #   origins "localhost:3000"
  #   # origins "*"

  #   resource "*",
  #     headers: :any,
  #     expose: %w[access-token uid client],
  #     methods: [:get, :post, :put, :patch, :delete, :options, :head]
  # end
end
