# == Schema Information
#
# Table name: participant_spaces
#
#  id             :integer          not null, primary key
#  participant_id :integer
#  space_id       :integer
#  note           :string
#  deleted_at     :datetime
#
class ParticipantSpace < ApplicationRecord
  
  acts_as_paranoid
  
  belongs_to :participant
  belongs_to :space
  
  attr_accessor :author_id
  
  after_create :add_create_log
  before_destroy :add_destroy_log
  after_update :add_update_log
  
  def add_create_log
    participant.change_logs.create(change: "creó la modalidad #{to_s}", author_id: author_id)
  end
  
  def add_update_log
    participant.change_logs.create(change: "actualizó la modalidad  #{to_s}", author_id: author_id)
  end
  
  def add_destroy_log
    participant.change_logs.create(change: "eliminó la modalidad #{to_s}", author_id: author_id)
  end
    
  def to_s
    "#{space.to_s_wihtout_amount}"
  end
end
