class AddColorIdToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :color_id, :integer
  end
end
