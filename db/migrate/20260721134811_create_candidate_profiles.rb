class CreateCandidateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :candidate_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.string :city
      t.string :country
      t.references :job_function, null: true, foreign_key: true
      t.integer :max_travel_time
      t.integer :search_status
      t.text :reason_for_looking
      t.decimal :desired_gross_salary
      t.decimal :desired_percentage
      t.decimal :average_daily_revenue
      t.integer :big_registration_status
      t.string :big_number
      t.integer :years_of_experience
      t.date :available_from
      t.string :notice_period
      t.string :transport_types, array: true, default: []
      t.string :desired_employment_types, array: true, default: []
      t.string :available_working_days, array: true, default: []
      t.text :motivation_for_employer
      t.text :internal_notes
      t.text :professional_summary
      t.boolean :consent_given
      t.datetime :consent_given_at

      t.timestamps
    end
  end
end
