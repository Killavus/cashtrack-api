class CreateLocalizations < ActiveRecord::Migration
  def change
    create_table :localizations do |t|
      t.float :latitude
      t.float :longitude
      t.references :price, index: true

      t.timestamps
    end
  end
end
