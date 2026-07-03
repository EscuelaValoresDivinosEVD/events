# == Schema Information
#
# Table name: participants
#
#  id            :integer          not null, primary key
#  guest_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deposit_state :string           default("pending")
#  deleted_at    :datetime
#
require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
