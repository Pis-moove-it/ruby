class AddKgRecycledGlassToCollectionPoint < ActiveRecord::Migration[5.2]
  def change
    add_column :collection_points, :kg_recycled_glass, :float, default: '0.0'
  end
end
