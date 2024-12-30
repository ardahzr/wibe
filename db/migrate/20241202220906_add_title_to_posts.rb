class AddTitleToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :title, :string
  end
end
