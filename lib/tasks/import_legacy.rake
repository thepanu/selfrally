
require 'mysql2'
require 'securerandom'

namespace(:db) do
  namespace(:import) do
    desc 'import legacy users'
    task users: :environment do
      users = legacy_database.query('SELECT * FROM player')
      users.each do |user|
        User.create!(id: user['id'],
                     first_name: user['firstname'],
                     last_name: user['lastname'],
                     email:  user['email'].nil? ? "notsupplied-#{SecureRandom.hex(4)}@self-rally.org" : user['email'],
                     password: SecureRandom.hex(13))
      end
      reset_pk_sequence
    end
    desc 'capitalize names'
    task user_names: :environment do
      users = User.all
      users.each do |user|
        user.first_name = user.first_name.capitalize
        user.last_name = user.last_name.capitalize
        user.save!
      end
    end
    desc 'import publishers'
    task publishers: :environment do
      publishers = legacy_database.query('SELECT * FROM publisher')
      publishers.each do |publisher|
        Publisher.create!(id: publisher['id'],
                          name: publisher['name'])
      end
      reset_pk_sequence
    end
    desc 'import publications'
    task publications: :environment do
      publications = legacy_database.query('SELECT * FROM publication')
      publications.each do |publication|
        Publication.create!(id: publication['id'],
                            publisher_id: publication['publisher'].to_i,
                            name: publication['name'],
                            publishing_year: publication['publishing_year'].to_i)
      end
      reset_pk_sequence
    end
    desc 'import scenarios'
    task scenarios: :environment do
      scenarios = legacy_database.query('SELECT * FROM scenario')
      scenarios.each do |scenario|
        Scenario.create!(id: scenario['id'],
                         name: scenario['name'],
                         scenario_date: scenario['dateofscenario'],
                         gameturns: scenario['gameturns'],
                         location_id: scenario['location'])
      end
      reset_pk_sequence
    end
    desc 'import scenario-publication relations'
    task scenario_publications: :environment do
      sps = legacy_database.query('SELECT * FROM scenario_publication')
      sps.each do |sp|
        ScenarioPublication.create!(scenario_id: sp['scenario'],
                                    publication_id: sp['publication'],
                                    code: sp['code'])
      end
    end
    desc 'create forces from game_players'
    task forces: :environment do
      legacy_database.query('SELECT * FROM game_player').each do |gp|
        Force.find_or_create_by!(name: gp['side'])
      end
    end
    desc 'import games'
    task games: :environment do
      legacy_database.query('SELECT * FROM game').each do |game|
        Game.create!(id: game['id'],
                     date: game['created'],
                     scenario_id: game['scenario'],
                     gamingtime: game['gamingtime'].nil? ? nil : Time.at(game['gamingtime']).seconds_since_midnight,
                     turnsplayed: game['turnsplayed'],
                     status: 1)
      end
      reset_pk_sequence
    end
    desc 'import game players'
    task game_players: :environment do
      legacy_database.query('SELECT * FROM game_player').each do |gp|
        labels = ["snakeeys", "boxcars", "beers", "rating"]
        stats = {}
        legacy_database.query("SELECT * from game_player_statistics WHERE game = #{gp['game']} AND player = #{gp['player']}").each do |stat|
          stats[stat['parameter']] = stat['value']
        end
        GamePlayer.create!(
          game_id: gp['game'],
          user_id: gp['player'],
          winner: (gp['result'] == 1 ? true : false),
          force_id: Force.where(name: gp['side']).first.id,
          snake_eyes: stats["snakeeyes"],
          boxcars: stats["boxcars"],
          beers: stats["beers"],
          rating: stats["rating"])
      end
    end
    desc 'import scenario forces'
    task scenario_forces: :environment do
      legacy_database.query('SELECT * FROM scenario_side').each do |side|
        ScenarioForce.find_or_create_by!(scenario_id: side['scenario'],
                                         force_id: Force.find_or_create_by(name: side['side']).id,
                                         initiative: side['initiative'])
        # puts "sc: #{side['scenario']} side: #{side['side']}" if Force.where(name: side['side']).first.nil?
      end
    end
  end
end

def reset_pk_sequence
  ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }
end

def legacy_database
  @client ||= Mysql2::Client.new(Rails.configuration.database_configuration['selfrally_legacy'])
end
