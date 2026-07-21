class CreateCandidateRegions < ActiveRecord::Migration[8.1]
  def change
    create_table :candidate_regions do |t|
      t.references :candidate_profile, null: false, foreign_key: true
      t.references :region, null: false, foreign_key: true

      t.timestamps
    end
  end
end
