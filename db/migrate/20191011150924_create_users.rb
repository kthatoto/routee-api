class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :account_id, null: false
      t.string :password,   null: false
      t.string :token
      t.timestamps
    end
  end
end
