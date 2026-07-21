class CreateLanguages < ActiveRecord::Migration[8.1]
  def change
    create_table :languages do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    add_index :languages, :name, unique: true
    add_index :languages, :code, unique: true
  end
end
