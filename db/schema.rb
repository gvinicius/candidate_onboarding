# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_21_141255) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "candidate_documents", force: :cascade do |t|
    t.bigint "candidate_profile_id", null: false
    t.string "content_type"
    t.datetime "created_at", null: false
    t.integer "document_type"
    t.integer "file_size"
    t.string "original_filename"
    t.text "parse_error"
    t.datetime "parsed_at"
    t.integer "parsing_status"
    t.text "raw_text"
    t.datetime "updated_at", null: false
    t.index ["candidate_profile_id"], name: "index_candidate_documents_on_candidate_profile_id"
  end

  create_table "candidate_languages", force: :cascade do |t|
    t.bigint "candidate_profile_id", null: false
    t.datetime "created_at", null: false
    t.bigint "language_id", null: false
    t.string "level"
    t.datetime "updated_at", null: false
    t.index ["candidate_profile_id"], name: "index_candidate_languages_on_candidate_profile_id"
    t.index ["language_id"], name: "index_candidate_languages_on_language_id"
  end

  create_table "candidate_profiles", force: :cascade do |t|
    t.date "available_from"
    t.string "available_working_days", default: [], array: true
    t.decimal "average_daily_revenue"
    t.string "big_number"
    t.integer "big_registration_status"
    t.string "city"
    t.boolean "consent_given"
    t.datetime "consent_given_at"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "desired_employment_types", default: [], array: true
    t.decimal "desired_gross_salary"
    t.decimal "desired_percentage"
    t.string "email"
    t.string "first_name"
    t.text "internal_notes"
    t.bigint "job_function_id"
    t.string "last_name"
    t.integer "max_travel_time"
    t.text "motivation_for_employer"
    t.string "notice_period"
    t.string "phone_number"
    t.text "professional_summary"
    t.text "reason_for_looking"
    t.integer "search_status"
    t.string "transport_types", default: [], array: true
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "years_of_experience"
    t.index ["job_function_id"], name: "index_candidate_profiles_on_job_function_id"
    t.index ["user_id"], name: "index_candidate_profiles_on_user_id"
  end

  create_table "candidate_regions", force: :cascade do |t|
    t.bigint "candidate_profile_id", null: false
    t.datetime "created_at", null: false
    t.bigint "region_id", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_profile_id"], name: "index_candidate_regions_on_candidate_profile_id"
    t.index ["region_id"], name: "index_candidate_regions_on_region_id"
  end

  create_table "candidate_skills", force: :cascade do |t|
    t.bigint "candidate_profile_id", null: false
    t.datetime "created_at", null: false
    t.bigint "skill_id", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_profile_id"], name: "index_candidate_skills_on_candidate_profile_id"
    t.index ["skill_id"], name: "index_candidate_skills_on_skill_id"
  end

  create_table "educations", force: :cascade do |t|
    t.bigint "candidate_profile_id", null: false
    t.string "city_country"
    t.datetime "created_at", null: false
    t.date "end_date"
    t.string "institution"
    t.integer "level"
    t.integer "position"
    t.date "start_date"
    t.string "study_course"
    t.datetime "updated_at", null: false
    t.index ["candidate_profile_id"], name: "index_educations_on_candidate_profile_id"
  end

  create_table "job_functions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "position"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_job_functions_on_name", unique: true
    t.index ["slug"], name: "index_job_functions_on_slug", unique: true
  end

  create_table "languages", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_languages_on_code", unique: true
    t.index ["name"], name: "index_languages_on_name", unique: true
  end

  create_table "regions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_regions_on_name", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "skills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_function_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["job_function_id"], name: "index_skills_on_job_function_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "work_experiences", force: :cascade do |t|
    t.bigint "candidate_profile_id", null: false
    t.string "company_name"
    t.datetime "created_at", null: false
    t.boolean "current_job"
    t.date "end_date"
    t.string "job_title"
    t.integer "position"
    t.text "responsibilities"
    t.date "start_date"
    t.datetime "updated_at", null: false
    t.index ["candidate_profile_id"], name: "index_work_experiences_on_candidate_profile_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "candidate_documents", "candidate_profiles"
  add_foreign_key "candidate_languages", "candidate_profiles"
  add_foreign_key "candidate_languages", "languages"
  add_foreign_key "candidate_profiles", "job_functions"
  add_foreign_key "candidate_profiles", "users"
  add_foreign_key "candidate_regions", "candidate_profiles"
  add_foreign_key "candidate_regions", "regions"
  add_foreign_key "candidate_skills", "candidate_profiles"
  add_foreign_key "candidate_skills", "skills"
  add_foreign_key "educations", "candidate_profiles"
  add_foreign_key "sessions", "users"
  add_foreign_key "skills", "job_functions"
  add_foreign_key "work_experiences", "candidate_profiles"
end
