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
class Event < ApplicationRecord
    
    acts_as_paranoid

    has_many :modalities, dependent: :destroy
    has_and_belongs_to_many :places,  :join_table => :places_events
    has_many :change_logs, as: :logable, dependent: :destroy
    attr_accessor :author_id
    
    delegate :display_deposit_amount, to: :decorator

    before_destroy { places.clear }

    scope :after_date, -> (date) { where("events.end_at >= ?", date) }
    scope :by_international, -> (is_international) { where(international: is_international) }
    
    # Using decorators
    def decorator
        @decorator ||= EventDecorator.new(self)
    end
    
    def participants
        Participant.joins(spaces: :modality).where("modalities.event_id = ?", id).select("DISTINCT(participants.id), participants.guest_id")
    end
    
    def to_s
        name
    end
    
    def spaces_amount
        Space.joins([:participants, :modality]).where("modalities.event_id = ?").sum("spaces.amount")
    end
    
    def stays_amount
        Space.joins(participants: :stays).joins(:modality).where("modalities.event_id = ?").sum("stays.amount * date_part('day', age(stays.end_at, stays.start_at))")
    end
    
    def payments_spaces
        Space.joins(participants: :payments).joins(:modality).where("modalities.event_id = ?").where("payments.reason = ?", "Evento").sum("payments.amount")
    end
    
    def payments_stays
        Space.joins(participants: :payments).joins(:modality).where("modalities.event_id = ?").where("payments.reason = ?", "Estadia").sum("payments.amount")
    end
    
    def due_spaces
        payments_spaces - spaces_amount
    end
    
    def due_stays
        payments_stays - stays_amount
    end
end
