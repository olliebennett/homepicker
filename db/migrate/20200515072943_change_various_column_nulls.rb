class ChangeVariousColumnNulls < ActiveRecord::Migration[6.0]
  def change
    change_column_null :comments, :text, false
    change_column_null :comments, :home_id, false

    change_column_null :homes, :creator_user_id, false
    change_column_null :homes, :price, false
    change_column_null :homes, :title, false
    change_column_null :homes, :address_street, false

    change_column_null :images, :url, false
    change_column_null :images, :home_id, false
  end
end
