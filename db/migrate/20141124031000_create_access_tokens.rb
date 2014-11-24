class CreateAccessTokens < ActiveRecord::Migration
  def up
    create_table :access_tokens do |t|
      t.string :key, null: :false
      t.datetime :expires_at, null: :false
      t.references :user
    end

    add_index :access_tokens, :key
  end

  def down
    drop_table :access_tokens
  end
end