# == Schema Information
#
# Table name: bookings
#
#  id             :integer          not null, primary key
#  start_date     :date             not null
#  end_date       :date
#  bed_id         :integer          not null
#  guest_id       :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  amount         :decimal(, )
#  deposit_amount :decimal(, )
#  deposit_state  :string           default("pending")
#  deleted_at     :datetime
#
class Booking < ApplicationRecord

  acts_as_paranoid
  
  belongs_to :bed
  belongs_to :guest
  
  has_many :payments, as: :payable
  has_and_belongs_to_many :participants, join_table: :participants_bookings
  has_many :change_logs, as: :logable
  attr_accessor :author_id
  
  after_create :add_create_log
  before_destroy :add_destroy_log
  after_update :add_update_log
  
  validates :bed, :guest, :start_date, :end_date, presence: true
  validate :available
  validate :valid_dates

  scope :by_location, ->(location_id) { joins( bed: [ room: [ house: [ :location ] ] ] ).where('locations.id = :location_id', {location_id: location_id}) }
  scope :by_house, ->(house_id) { joins( bed: [ room: [ :house ] ] ).where('houses.id = :house_id', {house_id: house_id}) }
  scope :by_room, ->(room_id) { joins( bed: [ :room ] ).where('rooms.id = :room_id', {room_id: room_id}) }
  scope :by_bed, ->(bed_id) { where('bed_id = :bed_id', {bed_id: bed_id}) }
  scope :by_guest, ->(guest_id) { where('guest_id = :guest_id', {guest_id: guest_id}) }
  scope :by_start_date, ->(start_date) { where('start_date >= :start_date', {start_date: start_date}) }
  scope :by_end_date, ->(end_date) { where('end_date = :end_date', {end_date: end_date}) }
  scope :between_dates, ->(start_date, end_date) { where('(start_date >= :start_date AND start_date <= :end_date) OR (end_date >= :start_date AND end_date <= :end_date) OR (start_date < :start_date AND end_date > :end_date)', {start_date: start_date, end_date: end_date}) }
  
  delegate :display_amount, :display_total_amount, :display_detailed_total_amount, :display_payments_amount, :display_due, to: :decorator

  # Using decorators
  def decorator
    @decorator ||= BookingDecorator.new(self)
  end
  
  [:given, :refunded, :pending].each do |name|
    define_method "deposit_#{name}" do
			self.deposit_state = "#{name}"
		end
		
		define_method "deposit_#{name}?" do
			self.deposit_state == "#{name}"
		end
  end
  
  def days
    (end_date - start_date).to_i
  end
  
  def total_amount
    days * amount unless amount.nil?
  end
  
  def payments_amount
    payments.sum("amount")
  end
  
  def due
    total_amount - payments_amount unless amount.nil?
  end
  
  def next_deposit_state_action
    if deposit_pending?
      return 'Depósito Abonado'
    elsif deposit_given?
      return 'Depóosito Reembolsado'
    elsif deposit_refunded?
      return 'Reiniciar a Pendiente'
    end
  end
  
  def next_deposit_state
    if deposit_pending?
      deposit_given
    elsif deposit_given?
      deposit_refunded
    elsif deposit_refunded?
      deposit_pending
    end
  end
  
  def account
    if self.account > 0
      self.account
    else  
      errors.add(:account, "La cantidad debe ser mayor a cero")
		end
  end
  
  def available
    if self.bed
      current_booking = self.bed.occupied?(self.start_date, self.end_date, self.id.blank? ? 0 : self.id)
      if current_booking
				errors.add(:occupied, "Esta cama esta ocupada desde: #{current_booking.start_date} hasta  #{current_booking.end_date}")
			end
		end
  end

  def valid_dates
    if self.start_date && self.end_date
      if self.end_date < self.start_date
        errors.add(:invalid_dates, "La fecha final debe ser mayor a la fecha inicial")
      end
    end
  end
  
  def add_create_log
    change_logs.create(change: "creó la reserva #{self}", author_id: author_id, is_reviewed: true)
    participants.first.change_logs.create(change: "creó la reserva #{self}", author_id: author_id, is_reviewed: true) if participants.any?
      
  end
  
  def add_update_log
    change_logs.create(change: "actualizó la reserva  #{self}", author_id: author_id, is_reviewed: true)
    participants.first.change_logs.create(change: "actualizó la reserva #{self}", author_id: author_id, is_reviewed: true) if participants.any?
  end
  
  def add_destroy_log
    ChangeLog.create(change: "eliminó la reserva #{self}", author_id: author_id, is_reviewed: true, logable_type: "Booking")
    participants.first.change_logs.create(change: "eliminó la reserva #{self}", author_id: author_id, is_reviewed: true) if participants.any?
  end
  
  def show_path
    Rails.application.routes.url_helpers.edit_booking_path(self)
  end
  
  def to_s
    "#{I18n.l start_date} - #{I18n.l end_date} #{guest}"
  end
end
