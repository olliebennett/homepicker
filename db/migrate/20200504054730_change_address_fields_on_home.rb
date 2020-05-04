class ChangeAddressFieldsOnHome < ActiveRecord::Migration[6.0]
  def change
    rename_column :homes, :address, :address_street
    add_column :homes, :address_locality, :string
    add_column :homes, :address_region, :string
  end
end
