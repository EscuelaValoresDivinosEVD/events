# Seeds for local development / Docker bootstrap.
# Idempotent: safe to run multiple times.

puts "== Profiles =="
profile_names = %w[admin eventer hoster hoster_ashram hoster_morada
                   coord_country coord_outside coord_eventer finance doctor viewer]
profile_names.each { |n| Profile.find_or_create_by!(name: n) }

puts "== Admin user =="
admin = User.find_or_initialize_by(email: "admin@evd.local")
admin.name     = "Admin"
admin.surname  = "EVD"
admin.password = "password123" if admin.new_record?
admin.save!
admin.profiles << Profile.find_by!(name: "admin") unless admin.profiles.exists?(name: "admin")

puts "== Locations =="
ashram = Location.find_or_create_by!(name: "Ashram")
morada = Location.find_or_create_by!(name: "Morada")

puts "== Houses =="
ashram_house = House.find_or_create_by!(name: "Casa Principal", location: ashram)
morada_house  = House.find_or_create_by!(name: "Casa 1",         location: morada)

puts "== Rooms & Beds =="
[["Sala A", 3], ["Sala B", 4], ["Sala C", 2]].each do |room_name, bed_count|
  room = Room.find_or_create_by!(name: room_name, house: ashram_house)
  bed_count.times { |i| Bed.find_or_create_by!(number: i + 1, room: room) }
end

[["Muladhara", 2], ["Anahata", 3]].each do |room_name, bed_count|
  room = Room.find_or_create_by!(name: room_name, house: morada_house)
  bed_count.times { |i| Bed.find_or_create_by!(number: i + 1, room: room) }
end

puts "== Places =="
sede    = Place.find_or_create_by!(name: "Sede Principal")
ashram_place = Place.find_or_create_by!(name: "Ashram")

puts "== Events =="
past_event = Event.find_or_initialize_by(name: "Retiro Enero 2026")
past_event.assign_attributes(start_at: Date.new(2026, 1, 10), end_at: Date.new(2026, 1, 17), active: false, deposit_amount: 100)
past_event.places << sede unless past_event.places.exists?(id: sede.id)
past_event.save!

upcoming_event = Event.find_or_initialize_by(name: "Retiro Julio 2026")
upcoming_event.assign_attributes(start_at: Date.new(2026, 7, 5), end_at: Date.new(2026, 7, 12), active: true, deposit_amount: 150)
upcoming_event.save!
upcoming_event.places << sede         unless upcoming_event.places.exists?(id: sede.id)
upcoming_event.places << ashram_place unless upcoming_event.places.exists?(id: ashram_place.id)

puts "== Modalities =="
mod_basico = Modality.find_or_create_by!(name: "Básico", event: upcoming_event) do |m|
  m.start_at = DateTime.new(2026, 7, 5, 8, 0, 0)
  m.end_at   = DateTime.new(2026, 7, 12, 18, 0, 0)
end

mod_intensivo = Modality.find_or_create_by!(name: "Intensivo", event: upcoming_event) do |m|
  m.start_at = DateTime.new(2026, 7, 5, 8, 0, 0)
  m.end_at   = DateTime.new(2026, 7, 12, 18, 0, 0)
end

mod_enero = Modality.find_or_create_by!(name: "General", event: past_event) do |m|
  m.start_at = DateTime.new(2026, 1, 10, 8, 0, 0)
  m.end_at   = DateTime.new(2026, 1, 17, 18, 0, 0)
end

puts "== Spaces =="
space_basico_sede    = Space.find_or_create_by!(modality: mod_basico,    place: sede)         { |s| s.amount = 350 }
space_basico_ashram  = Space.find_or_create_by!(modality: mod_basico,    place: ashram_place) { |s| s.amount = 420 }
space_intensivo_sede = Space.find_or_create_by!(modality: mod_intensivo, place: sede)         { |s| s.amount = 500 }
space_enero          = Space.find_or_create_by!(modality: mod_enero,     place: sede)         { |s| s.amount = 300 }

puts "== Guests =="
maria = Guest.find_or_initialize_by(email: "maria.garcia@example.com")
maria.assign_attributes(name: "María", surname: "García", country: "CO", city: "Bogotá",
                        phone_number: "3001234567", is_initiate: true)
maria.save!

juan = Guest.find_or_initialize_by(email: "juan.perez@example.com")
juan.assign_attributes(name: "Juan", surname: "Pérez", country: "CO", city: "Medellín",
                       phone_number: "3109876543", is_initiate: false)
juan.save!

sofia = Guest.find_or_initialize_by(email: "sofia.ruiz@example.com")
sofia.assign_attributes(name: "Sofía", surname: "Ruiz", country: "MX", city: "Ciudad de México",
                        phone_number: "5512345678", outside: true, is_initiate: true)
sofia.save!

puts "== Participants =="
unless Participant.joins(:spaces).where(guest: maria, spaces: { id: space_basico_sede }).exists?
  p1 = Participant.create!(guest: maria, deposit_state: "given")
  ParticipantSpace.create!(participant: p1, space: space_basico_sede)
  Payment.create!(payable: p1, amount: 200, method: "Banco", reason: "Evento",
                  paid_at: DateTime.new(2026, 6, 1), description: "Abono inscripción")
end

unless Participant.joins(:spaces).where(guest: juan, spaces: { id: space_intensivo_sede }).exists?
  p2 = Participant.create!(guest: juan, deposit_state: "pending")
  ParticipantSpace.create!(participant: p2, space: space_intensivo_sede)
end

unless Participant.joins(:spaces).where(guest: sofia, spaces: { id: space_basico_ashram }).exists?
  p3 = Participant.create!(guest: sofia, deposit_state: "given")
  ParticipantSpace.create!(participant: p3, space: space_basico_ashram)
  Payment.create!(payable: p3, amount: 420, method: "Paypal", reason: "Evento",
                  paid_at: DateTime.new(2026, 6, 5), description: "Pago completo")
end

puts "== Bookings =="
bed = Bed.joins(room: :house).where(houses: { id: ashram_house.id }).first
unless Booking.exists?(guest: maria, bed: bed)
  Booking.create!(guest: maria, bed: bed,
                  start_date: Date.new(2026, 7, 5), end_date: Date.new(2026, 7, 12),
                  amount: 30, deposit_state: "pending")
end

puts ""
puts "================================"
puts "  Login: admin@evd.local"
puts "  Password: password123"
puts "================================"
