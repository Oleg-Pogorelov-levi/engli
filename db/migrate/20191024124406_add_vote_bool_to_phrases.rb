class AddVoteBoolToPhrases < ActiveRecord::Migration[6.0]
  def change
    add_column :phrases, :vote_bool, :integer
  end
end
