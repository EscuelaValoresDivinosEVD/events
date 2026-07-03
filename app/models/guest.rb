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
class Guest < ApplicationRecord

	acts_as_paranoid
	
	has_many :bookings
	has_many :beds, through: :bookings
	
	scope :by_name, ->(name) { where( 'name ILIKE :name', {name: "%#{name}%"} ) }
	scope :by_surname, ->(surname) { where( 'surname ILIKE :surname', {surname: "%#{surname}%"} ) }
	scope :by_email, ->(email) { where( 'email ILIKE :email', {email: "%#{email}%"} ) }
	scope :by_outside, ->(outside) { where(outside: outside) }
	scope :by_country, ->(country) { where(country: country) }
	validates_uniqueness_of :email
	
	def full_name
		"#{name} #{surname}"
	end
	
	def to_s
		"#{name} #{surname} (#{email})"
	end
	
	def country_name
		if country
			country_name = ISO3166::Country[country]
			if country_name
				country_name.translations[I18n.locale.to_s] || country_name.name
			end
		end
	end	
end
