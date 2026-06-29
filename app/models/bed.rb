# == Schema Information
#
# Table name: beds
#
#  id         :integer          not null, primary key
#  number     :integer          not null
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  usable     :boolean          default(TRUE)
#  deleted_at :datetime
#
class Bed < ApplicationRecord

  acts_as_paranoid
  
  belongs_to :room
  has_many :bookings
  has_many :guests, through: :bookings

  scope :available, ->(start_date, end_date) { joins('LEFT JOIN bookings ON bookings.bed_id = beds.id').where("(start_date IS NULL AND end_date IS NULL) OR (start_date < :start_date OR start_date > :end_date) AND (end_date < :start_date AND end_date > :end_date)", {start_date: start_date, end_date: end_date})}
  scope :by_location, ->(location_id) { joins( room: [ house: [ :location ] ] ).where('locations.id = :location_id', {location_id: location_id}) }
  scope :by_house, ->(house_id) { joins( room: [ :house ] ).where('houses.id = :house_id', {house_id: house_id}) }
  scope :by_room, ->(room_id) { joins( :room ).where('rooms.id = :room_id', {room_id: room_id}) }
  scope :usable, -> { where(usable: true) }
  
  def occupied?(start_date, end_date, booking_id = 0)
  	self.bookings.where("((start_date >= :start_date AND start_date < :end_date) OR (end_date > :start_date AND end_date <= :end_date) OR (start_date < :start_date AND end_date > :end_date)) AND (id != :booking_id)", {start_date: start_date, end_date: end_date, booking_id: booking_id}).first
  end
end
