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
require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
