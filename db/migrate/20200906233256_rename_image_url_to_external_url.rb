class RenameImageUrlToExternalUrl < ActiveRecord::Migration[6.0]
  def change
    rename_column :images, :url, :external_url
  end
end
