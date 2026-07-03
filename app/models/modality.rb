# == Schema Information
#
# Table name: modalities
#
#  id          :integer          not null, primary key
#  name        :string
#  event_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  start_at    :datetime
#  end_at      :datetime
#  is_composed :boolean          default(FALSE), not null
#  deleted_at  :datetime
#
class Modality < ApplicationRecord
	
	acts_as_paranoid

	belongs_to :event
	has_many :spaces, dependent: :destroy
	
	has_many :compositions, dependent: :destroy
	has_many :submodalities, through: :compositions
	
	accepts_nested_attributes_for :spaces, :allow_destroy => true
	
	validates_presence_of :name, :start_at, :end_at
	
	scope :composed, ->(composed) { where('is_composed = :composed', {composed: composed}) }
	scope :compositions_by_name, -> { compositions.joins(:submodalities).order("modalities.name ASC") }
	
	def add_discount(composition)
		spaces.each do |space|
			total_space = space.amount
			total_space += (composition.submodality.spaces.where(place: space.place).first.amount - composition.discount)
			space.update(:amount, total_space)
		end
	end
	
	def remove_discount(composition)
		spaces.each do |space|
			total_space = space.amount
			total_space -= (composition.submodality.spaces.where(place: space.place).first.amount - composition.discount)
			space.update(:amount, total_space)
		end
	end
	
	def to_s
		name
	end
	
	def spaces_to_s
		spaces.joins(:place).pluck(Arel.sql("places.name || ' (' ||  spaces.amount || ' USD)'")).join(", ")
	end
end
