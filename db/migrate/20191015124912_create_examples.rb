class CreateExamples < ActiveRecord::Migration[6.0]
  def change
    create_table :examples do |t|
      t.string :example
      t.references :user
      t.references :phrase

      t.timestamps
    end
  end
end