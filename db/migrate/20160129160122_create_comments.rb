class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :blog, index: true, foreign_key: true
      t.references :creator, index: true, foreign_key: true
      t.text :text

      t.timestamps
    end
  end
end
