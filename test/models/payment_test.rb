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
require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
