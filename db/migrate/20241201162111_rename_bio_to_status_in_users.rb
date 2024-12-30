class RenameBioToStatusInUsers < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :bio, :status
  end
end