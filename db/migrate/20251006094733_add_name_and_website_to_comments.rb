class AddNameAndWebsiteToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :name, :string
   add_column :comments, :email, :string
    add_column :comments, :website, :string
  end
end
