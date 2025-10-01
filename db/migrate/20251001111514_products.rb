class Products < ActiveRecord::Migration[7.1]
  def change
 create_table :products do |t|
      t.string  :title, null: false
      t.string  :description
      t.text    :content
      t.timestamps
    end
    add_index :products, :title
  end
end
