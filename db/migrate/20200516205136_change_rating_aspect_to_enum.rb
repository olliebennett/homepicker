class ChangeRatingAspectToEnum < ActiveRecord::Migration[6.0]
  def change
    change_column :ratings, :aspect, :integer, using: 'aspect::integer'
  end
end
