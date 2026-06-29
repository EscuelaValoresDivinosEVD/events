# == Schema Information
#
# Table name: compositions
#
#  id             :integer          not null, primary key
#  modality_id    :integer
#  submodality_id :integer
#  discount       :decimal(, )
#  deleted_at     :datetime
#
class Composition < ApplicationRecord
    
    acts_as_paranoid

    belongs_to :modality
    belongs_to :submodality, class_name: 'Modality', foreign_key: :submodality_id, optional: true
    
    delegate :display_discount, to: :decorator

    # Using decorators
    def decorator
        @decorator ||= CompositionDecorator.new(self)
    end

end
