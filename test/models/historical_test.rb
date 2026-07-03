# == Schema Information
#
# Table name: historicals
#
#  id          :integer          not null, primary key
#  name        :string
#  value       :decimal(, )
#  start_date  :date
#  location_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  deleted_at  :datetime
#
require 'test_helper'

class HistoricalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
