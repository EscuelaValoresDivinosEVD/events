# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  name           :string
#  start_at       :date
#  end_at         :date
#  active         :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deposit_amount :decimal(, )      default(0.0)
#  international  :boolean          default(FALSE)
#  deleted_at     :datetime
#
require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
