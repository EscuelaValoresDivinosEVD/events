# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  house_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#
class Room < ApplicationRecord

  acts_as_paranoid
  
  belongs_to :house
  has_many :beds, :dependent => :destroy
end
