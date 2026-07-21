class CreateCandidateDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :candidate_documents do |t|
      t.references :candidate_profile, null: false, foreign_key: true
      t.integer :document_type
      t.string :original_filename
      t.string :content_type
      t.integer :file_size
      t.integer :parsing_status
      t.datetime :parsed_at
      t.text :parse_error
      t.text :raw_text

      t.timestamps
    end
  end
end
