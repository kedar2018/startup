class AddContentToServices < ActiveRecord::Migration[7.1]
  def change
    add_column :services, :content, :text
  end
end
