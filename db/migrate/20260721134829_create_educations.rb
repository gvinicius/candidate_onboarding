class CreateEducations < ActiveRecord::Migration[8.1]
  def change
    create_table :educations do |t|
      t.references :candidate_profile, null: false, foreign_key: true
      t.string :institution
      t.string :study_course
      t.string :city_country
      t.integer :level
      t.date :start_date
      t.date :end_date
      t.integer :position

      t.timestamps
    end
  end
end
