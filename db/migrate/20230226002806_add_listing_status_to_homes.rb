class AddListingStatusToHomes < ActiveRecord::Migration[7.0]
  def change
    add_column :homes, :listing_status, :integer
  end
end
