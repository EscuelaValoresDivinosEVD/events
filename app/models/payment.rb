# == Schema Information
#
# Table name: payments
#
#  id           :integer          not null, primary key
#  paid_at      :datetime
#  amount       :decimal(, )
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  method       :string
#  reason       :string           default("Evento")
#  payable_type :string
#  payable_id   :integer
#  deleted_at   :datetime
#
class Payment < ApplicationRecord

  acts_as_paranoid
  
  belongs_to :payable, polymorphic: true
  attr_accessor :author_id
  
  after_create :add_create_log
  before_destroy :add_destroy_log
  
  after_update :add_update_log
  
  delegate :display_amount, to: :decorator
  
  PAYMENT_METHODS = ["Efectivo", "Paypal", "Banco", "Página Web", "Sede", "Otro"]
  
  def decorator
    @decorator ||= StayDecorator.new(self)
  end
  
  def add_create_log
    payable.change_logs.create(change: "creó el pago #{to_s}", author_id: author_id, is_reviewed: true)
  end
  
  def add_update_log
    payable.change_logs.create(change: "actualizó el pago  #{to_s}", author_id: author_id)
  end
  
  def add_destroy_log
    payable.change_logs.create(change: "eliminó el pago #{to_s}", author_id: author_id, is_reviewed: true)
  end
  
  def to_s
    "#{display_amount} el #{I18n.l paid_at}"
  end
end
