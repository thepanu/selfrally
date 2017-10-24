
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
      reset_pk_sequence
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
    desc "import publishers"
    task publishers: :environment do
      publishers = legacy_database.query("SELECT * FROM publisher")
      publishers.each do |publisher|
        Publisher.create!(  id: publisher['id'],
                            name: publisher['name'])
      end
      reset_pk_sequence
    end
    desc "import publications"
    task publications: :environment do
      publications = legacy_database.query("SELECT * FROM publication")
      publications.each do |publication|
        Publication.create!(  id: publication['id'],
                              publisher_id: publication['publisher'].to_i,
                              name: publication['name'],
                              publishing_year: publication['publishing_year'].to_i)
      end
      reset_pk_sequence
    end

  end
end











def reset_pk_sequence
  ActiveRecord::Base.connection.tables.each { |t|             ActiveRecord::Base.connection.reset_pk_sequence!(t) }
end


def legacy_database
  @client ||= Mysql2::Client.new(Rails.configuration.database_configuration['selfrally_legacy'])
end
