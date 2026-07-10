class AddSyncedToGuests < ActiveRecord::Migration[7.2]
  def change
    add_column :guests, :synced, :boolean, default: false, null: false
  end
end
