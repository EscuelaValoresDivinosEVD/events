require 'net/http'
require 'json'

namespace :guests do
  desc 'Sync guest info from the federated app API. Pass an email arg to sync a single guest.'
  task :sync_from_federation, [:email] => :environment do |_t, args|
    base_url = if ENV['FEDERATED_APP_BASE_URL'].present?
                 ENV['FEDERATED_APP_BASE_URL']
               elsif Rails.env.production?
                 raise 'FEDERATED_APP_BASE_URL env var must be set in production'
               else
                 'http://localhost:3000'
               end

    api_key = ENV['INTERNAL_API_KEY']
    raise 'INTERNAL_API_KEY env var is not set' if api_key.blank?

    guests = args[:email].present? ? Guest.where(email: args[:email]) : Guest.all

    synced = 0
    skipped = 0
    errors = 0

    guests.find_each do |guest|
      uri = URI("#{base_url}/api/users")
      uri.query = URI.encode_www_form(email: guest.email)
      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = "Bearer #{api_key}"

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
      end

      case response.code.to_i
      when 200
        data = JSON.parse(response.body)
        attrs = {
          name:           data['name'],
          surname:        data['surname'],
          mobile_number:  data['cellphone'],
          phone_number:   data['telephone'],
          country:        data['country_of_residence'],
          city:           data['city_of_residence'],
          profession:     data['profession'],
          identification: data['document_id'],
          birth_date:     data['birthdate'],
          status:         data['status'],
          address:        data['address']
        }.compact
        guest.update(attrs)
        puts "  synced: #{guest.email}"
        synced += 1
      when 404
        puts "  WARN not found in federated app: #{guest.email}"
        skipped += 1
      else
        puts "  ERROR #{response.code} for #{guest.email}: #{response.body}"
        errors += 1
      end
    end

    puts "\nDone. Synced: #{synced} | Skipped: #{skipped} | Errors: #{errors}"
  end
end
