# == Schema Information
#
# Table name: houses
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  sketch      :string
#  location_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  open_stay   :boolean          default(FALSE)
#  deleted_at  :datetime
#
require 'test_helper'

class HouseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
