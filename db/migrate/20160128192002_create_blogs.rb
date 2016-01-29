class CreateBlogs < ActiveRecord::Migration[5.0]
  def change
    create_table :blogs do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
