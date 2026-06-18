class AddPolymorphicToPayments < ActiveRecord::Migration[4.2]
  def up
    add_reference :payments, :payable, polymorphic: true, index: true
    # Raw SQL avoids acts_as_paranoid default scope (added years after this migration)
    execute <<-SQL
      UPDATE payments SET payable_id = participant_id, payable_type = 'Participant'
    SQL
    remove_column :payments, :participant_id
  end
  
  def down
    add_reference :payments, :participant, index: true
    execute <<-SQL
      UPDATE payments SET participant_id = payable_id WHERE payable_type = 'Participant'
    SQL
    remove_column :payments, :payable_id, :integer
    remove_column :payments, :payable_type, :string
  end
end
