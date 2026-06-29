# == Schema Information
#
# Table name: stays
#
#  id             :integer          not null, primary key
#  participant_id :integer
#  place_id       :integer
#  start_at       :datetime
#  end_at         :datetime
#  amount         :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deleted_at     :datetime
#
require 'test_helper'

class StayTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
