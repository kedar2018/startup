class CreateAbouts < ActiveRecord::Migration[7.1]
  def change
    create_table :abouts do |t|
      t.string :title
      t.text :description
      t.text :content

      t.timestamps
    end
  end
end
