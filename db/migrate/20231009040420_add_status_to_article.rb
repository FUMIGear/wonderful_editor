class AddStatusToArticle < ActiveRecord::Migration[6.1]
  def change
    # add_column :articles, :status, :integer #元々
    add_column :articles, :status, :integer, default: 0, null: false # オプションつけた。
    # add_column :articles, :status, :string, default: "draft" #模範回答
  end
end
