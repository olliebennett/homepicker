class RenameHuntMembersToHuntMemberships < ActiveRecord::Migration[6.0]
  def change
    rename_table :hunt_members, :hunt_memberships
  end
end
