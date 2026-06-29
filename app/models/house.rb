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
class House < ApplicationRecord

  acts_as_paranoid
  
  belongs_to :location
  has_many :rooms, :dependent => :destroy
  mount_uploader :sketch, SketchUploader
  
  def open_stay?
    open_stay
  end
end
