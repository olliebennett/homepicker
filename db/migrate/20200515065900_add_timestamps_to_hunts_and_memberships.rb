class AddTimestampsToHuntsAndMemberships < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :hunts, default: -> { 'NOW()' }, null: true
    add_timestamps :hunt_memberships, default: -> { 'NOW()' }, null: true
  end
end
