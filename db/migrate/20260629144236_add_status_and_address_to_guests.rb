class AddStatusAndAddressToGuests < ActiveRecord::Migration[7.2]
  def change
    add_column :guests, :status, :string
    add_column :guests, :address, :string
  end
end
