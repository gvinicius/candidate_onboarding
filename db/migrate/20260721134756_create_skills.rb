class CreateSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :skills do |t|
      t.string :name
      t.references :job_function, null: false, foreign_key: true

      t.timestamps
    end
  end
end
