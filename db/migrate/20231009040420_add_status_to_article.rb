class AddStatusToArticle < ActiveRecord::Migration[6.1]
  def change
    # add_column :articles, :status, :integer #元々
    add_column :articles, :status, :integer, default: 0, null: false # statusメソッドが競合するため変更
    # add_column :articles, :article_status, :integer, default: 0, null: false #article_statusに変更
  end
end
