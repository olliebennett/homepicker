class AddDisabledToHomes < ActiveRecord::Migration[6.0]
  def change
    add_column :homes, :disabled, :boolean, default: false
  end
end
