# == Schema Information
#
# Table name: air_tickets
#
#  id             :integer          not null, primary key
#  participant_id :integer
#  arrive_at      :datetime
#  arrive_to      :string
#  leave_at       :datetime
#  leave_from     :string
#  estimated_at   :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deleted_at     :datetime
#
require 'test_helper'

class AirTicketTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
