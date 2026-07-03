# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#
class Place < ApplicationRecord
    
    acts_as_paranoid

    has_many :spaces, dependent: :destroy
    has_and_belongs_to_many :events,  :join_table => :places_events
    
    def to_s
        name
    end
end
