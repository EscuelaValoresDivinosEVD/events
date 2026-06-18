class RemoveSpaceFromParticipants < ActiveRecord::Migration[4.2]
  def up
    remove_column :participants, :space_id, :integer
  end
  
  def down
    add_column :participants, :space_id, :integer
    execute <<-SQL
      UPDATE participants p
      SET space_id = (SELECT space_id FROM participant_spaces ps WHERE ps.participant_id = p.id LIMIT 1)
    SQL
  end
end
