class Blog < ActiveRecord::Migration[7.1]
  def change
	 create_table :blogs do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.references :admin_user, foreign_key: true # assuming blog has an author (AdminUser/User)

      t.timestamps
    end
 create_table :comments do |t|
      t.text :body, null: false
      t.references :blog, null: false, foreign_key: true
      t.references :admin_user, foreign_key: true # commenter

      t.timestamps
    end
  end
end
