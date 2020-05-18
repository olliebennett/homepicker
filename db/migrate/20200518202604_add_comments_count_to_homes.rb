class AddCommentsCountToHomes < ActiveRecord::Migration[6.0]
  def change
    add_column :homes, :comments_count, :integer
  end
end
