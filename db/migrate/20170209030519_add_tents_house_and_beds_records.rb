class AddTentsHouseAndBedsRecords < ActiveRecord::Migration[4.2]
  # Isolated classes avoid current model code (acts_as_paranoid added years after this migration)
  class Location < ActiveRecord::Base
    has_many :houses, foreign_key: :location_id, class_name: 'AddTentsHouseAndBedsRecords::House'
  end
  class House < ActiveRecord::Base
    has_many :rooms, foreign_key: :house_id, class_name: 'AddTentsHouseAndBedsRecords::Room'
  end
  class Room < ActiveRecord::Base
    has_many :beds, foreign_key: :room_id, class_name: 'AddTentsHouseAndBedsRecords::Bed'
  end
  class Bed < ActiveRecord::Base; end

  def up
    location = Location.where(name: 'Ashram').first
    if location
      house = location.houses.create(name: 'Carpas', open_stay: true)
      for room in 1..20
        room = house.rooms.create(name: room.to_s)
        for bed in 1..3
          room.beds.create(number: bed)
        end
      end
    end
  end

  def down
    House.where(name: 'Carpas').destroy_all
  end
end
