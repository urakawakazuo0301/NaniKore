class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name,               null: false
      t.integer :category_id,       null: false
      t.integer :quantity_id,       null: false
      t.text :notes
      t.string :color
      t.references :user,           null: false, foreign_key: true
      t.timestamps
    end
  end
end
