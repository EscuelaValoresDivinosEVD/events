# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#
class Location < ApplicationRecord

	acts_as_paranoid

	validates :name, uniqueness: true, presence: true
	has_many :houses, :dependent => :destroy
	has_many :historicals
end
