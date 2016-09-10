class AddCoordsPostcodeToHome < ActiveRecord::Migration[5.0]
  def change
    add_column :homes, :latitude, :float
    add_column :homes, :longitude, :float
    add_column :homes, :postcode, :string
  end
end
