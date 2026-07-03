# == Schema Information
#
# Table name: modalities
#
#  id          :integer          not null, primary key
#  name        :string
#  event_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  start_at    :datetime
#  end_at      :datetime
#  is_composed :boolean          default(FALSE), not null
#  deleted_at  :datetime
#
require 'test_helper'

class ModalityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
