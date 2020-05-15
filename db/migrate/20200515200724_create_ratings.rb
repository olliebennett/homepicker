class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.integer :score, null: false
      t.references :user, null: false, foreign_key: true
      t.references :home, null: false, foreign_key: true
      t.string :aspect, null: false

      t.timestamps
    end
  end
end
