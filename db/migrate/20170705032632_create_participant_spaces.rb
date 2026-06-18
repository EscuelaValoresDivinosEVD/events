class CreateParticipantSpaces < ActiveRecord::Migration[4.2]
  def up
    create_table :participant_spaces do |t|
      t.belongs_to :participant, index: true, foreign_key: true
      t.belongs_to :space, index: true, foreign_key: true
    end
    
    # Raw SQL avoids acts_as_paranoid default scope (added years after this migration)
    execute <<-SQL
      INSERT INTO participant_spaces (participant_id, space_id)
      SELECT id, space_id FROM participants WHERE space_id IS NOT NULL
    SQL
  end
  
  def down
    drop_table :participant_spaces
  end
end