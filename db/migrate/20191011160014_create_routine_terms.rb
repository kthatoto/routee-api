class CreateRoutineTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :routine_terms do |t|
      t.integer :user_id,       null: false
      t.integer :interval_type, null: false
      t.date :start_date,       null: false
      t.date :end_date,         null: false
      t.timestamps
    end
  end
end
