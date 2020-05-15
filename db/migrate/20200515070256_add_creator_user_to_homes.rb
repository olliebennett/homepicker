class AddCreatorUserToHomes < ActiveRecord::Migration[6.0]
  def change
    add_reference :homes, :creator_user, class_name: 'User'
    add_foreign_key :homes, :users, column: :creator_user_id
  end
end
