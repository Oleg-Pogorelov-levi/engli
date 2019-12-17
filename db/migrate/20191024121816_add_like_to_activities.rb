class AddLikeToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :like, :integer, default: 0
  end
end
