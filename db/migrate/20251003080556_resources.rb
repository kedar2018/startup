class Resources < ActiveRecord::Migration[7.1]
def change
    create_table :resources do |t|
      t.string  :title, null: false
      t.text    :description
      t.boolean :publish, null: false, default: false
      t.timestamps
    end
    add_index :resources, :title
    add_index :resources, :publish
  end
end
