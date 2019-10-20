class CreateRoutines < ActiveRecord::Migration[5.2]
  def change
    create_table :routines do |t|
      t.integer :user_id,             null: false
      t.integer :routine_template_id, null: false
      t.integer :routine_term_id,     null: false
      t.boolean :achieved,            null: false, default: false
      t.integer :count
      t.timestamps
    end
  end
end
