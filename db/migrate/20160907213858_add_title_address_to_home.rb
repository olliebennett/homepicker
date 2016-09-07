class AddTitleAddressToHome < ActiveRecord::Migration[5.0]
  def change
    add_column :homes, :title, :string
    add_column :homes, :address, :string
  end
end
