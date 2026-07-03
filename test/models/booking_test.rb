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
require 'test_helper'

class BookingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
