# == Schema Information
#
# Table name: spaces
#
#  id          :integer          not null, primary key
#  modality_id :integer
#  place_id    :integer
#  amount      :decimal(, )      default(0.0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_active   :boolean          default(TRUE), not null
#  deleted_at  :datetime
#
require 'test_helper'

class SpaceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
