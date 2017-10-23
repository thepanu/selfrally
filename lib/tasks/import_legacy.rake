require 'mysql2'
require 'securerandom'

DISABLED_TASKS = [
  'db:drop',
  'db:migrate:reset',
  'db:schema:load',
  'db:seed',
  'db:import_legacy:users',
  'db:import_legacy:user_names',
  'db:import_legacy:publishers'
]


DISABLED_TASKS.each do |task|
  Rake::Task[task].enhance ['db:guard_for_production']
end



namespace(:db) do
  desc "Disable a task in production environment"
  task :guard_for_production do
    if Rails.env.production?
      if ENV['I_KNOW_THIS_MAY_SCREW_THE_DB'] != "1"
        puts 'This task is disabled in production.'
        puts 'If you really want to run it, call it again with `I_KNOW_THIS_MAY_SCREW_THE_DB=1`'
        exit
      else
        # require 'heroku'
        # puts 'Making a backup of the database, just in case...'
        # puts `heroku pgbackups:capture`
      end
    end
  end
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

  end
end











def reset_pk_sequence
  ActiveRecord::Base.connection.tables.each { |t|             ActiveRecord::Base.connection.reset_pk_sequence!(t) }
end


def legacy_database
  @client ||= Mysql2::Client.new(Rails.configuration.database_configuration['selfrally_legacy'])
end
