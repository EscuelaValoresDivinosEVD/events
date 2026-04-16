class AddBirthDateToGuests < ActiveRecord::Migration[5.0]
  def change
    add_column :guests, :birth_date, :date
  end
end
