class CreateHunt < ActiveRecord::Migration[6.0]
  def change
    create_table :hunts do |t|
      t.string :title, null: false

      t.references :creator_user, class_name: 'User', null: false
      t.foreign_key :users, column: :creator_user_id
    end
  end
end
