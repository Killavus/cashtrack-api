class AddSecretToSession < ActiveRecord::Migration
  def change
    change_table :sessions do |t|
      t.string :secret
    end
  end
end
