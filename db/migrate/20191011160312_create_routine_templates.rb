class CreateRoutineTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :routine_templates do |t|
      t.integer :user_id,       null: false
      t.string :name,           null: false
      t.integer :interval_type, null: false
      t.boolean :archived,      null: false, default: false
      t.date :start_date
      t.date :end_date
      t.text :description
      t.integer :target_count
      t.timestamps
    end
  end
end
