class PopulateHomeCommentsCount < ActiveRecord::Migration[6.0]
  def up
    Home.find_each do |home|
      Home.reset_counters(home.id, :comments)
    end
  end
end
