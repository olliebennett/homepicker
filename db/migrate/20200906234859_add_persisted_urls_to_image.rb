class AddPersistedUrlsToImage < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :full_url, :string
    add_column :images, :thumb_url, :string
  end
end
