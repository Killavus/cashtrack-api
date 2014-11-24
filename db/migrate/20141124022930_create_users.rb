class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest
    end
  end

  def down
    drop_table :users
  end
end