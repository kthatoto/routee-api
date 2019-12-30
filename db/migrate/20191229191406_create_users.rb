class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.text :token
      t.datetime :token_valid_to
      t.string :name
      t.timestamps
    end
  end
end
