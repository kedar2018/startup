class AddIconToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :icon_style, :string
    add_column :products, :icon_name, :string
  end
end
