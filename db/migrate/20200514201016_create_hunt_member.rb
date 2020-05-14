class CreateHuntMember < ActiveRecord::Migration[6.0]
  def change
    create_table :hunt_members do |t|
      t.references :hunt, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
    end
  end
end
