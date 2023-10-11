class ChangeStatusDataTypeInArticles < ActiveRecord::Migration[6.1]
  def change
    change_column :articles, :status, :string, default: "draft" #カラムとデフォルト値の変更
  end
end
