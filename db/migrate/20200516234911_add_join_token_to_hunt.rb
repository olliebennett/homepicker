class AddJoinTokenToHunt < ActiveRecord::Migration[6.0]
  def change
    add_column :hunts, :join_token, :string, null: false, default: -> { 'md5(random()::text)' }
  end
end
