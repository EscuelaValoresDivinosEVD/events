# == Schema Information
#
# Table name: guests
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  surname          :string           not null
#  email            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  country          :string
#  city             :string
#  phone_number     :string
#  mobile_number    :string
#  identification   :string
#  civil_status     :string
#  profession       :string
#  nationality      :string
#  health_condition :text
#  receive_drug     :text
#  symptoms         :text
#  contact_name     :string
#  contact_kin      :string
#  contact_number   :string
#  hotel            :string
#  local_number     :string
#  comments         :text
#  is_initiate      :boolean
#  age              :integer
#  outside          :boolean          default(FALSE)
#  deleted_at       :datetime
#  swami_name       :string
#  birth_date       :date
#  status           :string
#  address          :string
#
require 'test_helper'

class GuestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
