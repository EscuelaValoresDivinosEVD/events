# == Schema Information
#
# Table name: spaces
#
#  id          :integer          not null, primary key
#  modality_id :integer
#  place_id    :integer
#  amount      :decimal(, )      default(0.0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_active   :boolean          default(TRUE), not null
#  deleted_at  :datetime
#
class Space < ApplicationRecord
  acts_as_paranoid

  belongs_to :place
  belongs_to :modality
  
  has_many :participant_spaces, dependent: :destroy
  has_many :participants, through: :participant_spaces
  
  scope :by_event, -> (event) { joins(:modality).where('modalities.event_id = ?', event.id) }
  scope :order_by_name, -> { joins(:modality).order('modalities.name ASC') }
  scope :composed, ->(composed) { eager_load(:modality).where('modalities.is_composed = :composed', {composed: composed}) }
  
  delegate :display_modality_space, :display_amount, to: :decorator
  
  # Using decorators
  def decorator
    @decorator ||= SpaceDecorator.new(self)
  end
  
  def to_s
    "#{modality} en #{place.name} (#{amount} USD)"
  end
  
  def to_s_wihtout_amount
    "#{modality} en #{place.name}"
  end
end
