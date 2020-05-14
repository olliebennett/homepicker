class AddHuntToHomes < ActiveRecord::Migration[6.0]
  def change
    add_reference :homes, :hunt, foreign_key: true
  end
end
