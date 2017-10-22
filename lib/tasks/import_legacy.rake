require 'mysql2'
require 'securerandom'

namespace(:db) do
  namespace(:import_legacy) do
    desc "import legacy users"
    task users: :environment do
      users = legacy_database.query("SELECT * FROM player")
      users.each do |user|
      User.create!(        id: user['id'],
                  first_name: user['firstname'],
                   last_name: user['lastname'],
                      email:  user['email'].nil? ? "notsupplied-#{SecureRandom.hex(4)}@self-rally.org" : user['email'],
                      password: SecureRandom.hex(13)

                  )
                end
    end
    desc "capitalize names"
    task user_names: :environment do
      users = User.all
      users.each do |user|
        user.first_name = user.first_name.capitalize
        user.last_name = user.last_name.capitalize
        user.save!
      end
    end
  end
end














def legacy_database
  @client ||= Mysql2::Client.new(Rails.configuration.database_configuration['selfrally_legacy'])
end
