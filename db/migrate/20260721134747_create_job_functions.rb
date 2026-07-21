class CreateJobFunctions < ActiveRecord::Migration[8.1]
  def change
    create_table :job_functions do |t|
      t.string :name
      t.string :slug
      t.integer :position

      t.timestamps
    end
    add_index :job_functions, :name, unique: true
    add_index :job_functions, :slug, unique: true
  end
end
