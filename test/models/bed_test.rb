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
require 'test_helper'

class BedTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
