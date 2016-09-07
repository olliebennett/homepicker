class CreateHomes < ActiveRecord::Migration[5.0]
  def change
    create_table :homes do |t|
      t.string :agent_url
      t.string :zoopla_url
      t.string :rightmove_url
      t.integer :price

      t.timestamps
    end
  end
end
