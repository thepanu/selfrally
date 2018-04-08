
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

    desc 'update register date for users'
    task update_register_date: :environment do
      legacy_database.query('SELECT * FROM player').each do |player|
        User.find(player['id']).update_attributes(
          created_at: player['created']
        )
      end
    end

    desc 'import ranks'
    task import_ranks: :environment do
      legacy_database.query('SELECT * FROM rank').each do |rank|
        Rank.create!(
          id: rank['id'],
          limit: rank['start'],
          img: "/public/ranks/#{rank['img']}.gif",
          name: rank['display']
        )
      end
    end

    desc 'fix img urls'
    task fix_rank_imgs: :environment do 
      legacy_database.query('SELECT * FROM rank').each do |rank|
        Rank.find_by(name: rank['display']).update_attributes(
          img: "ranks/#{rank['img']}.gif"
        )
      end
    end

    desc 'create promotions for users'
    task promotions: :environment do
      firstrank = Rank.find_by(name: "alokas")
      User.all.each do |user|
        if user.user_ranks.empty?
          start_date = user.games.empty? ?  user.created_at : user.games.order(date: :asc).first.date
          user.user_ranks.create(rank_id: firstrank.id, promotion_date: start_date)
        end
        GamePlayer.includes(:game).where(user_id: user.id).order("games.date asc").each do |play|
          begin
          if user.promote_on_date?(play.game.date)
            user.user_ranks.create(rank_id: user.next_rank.id, promotion_date: play.game.date)
          end
          rescue
            byebug
          end
        end
      end
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

    desc 'import dates and times'
    task game_date_times: :environment do
      legacy_database.query('SELECT * FROM game').each do |game|
        Game.find(game['id']).update_attributes(
          date: game['created'],
          created_at: game['created']
        )
      end
    end

    desc 'import game players'
    task game_players: :environment do
      legacy_database.query('SELECT * FROM game_player').each do |gp|
        labels = ["snakeeys", "boxcars", "beers", "rating"]
        stats = {}
        legacy_database.query("SELECT * from game_player_statistics WHERE game = #{gp['game']} AND player = #{gp['player']}").each do |stat|
          stats[stat['parameter']] = stat['value']
        end
        score = legacy_database.query("SELECT * from score WHERE game = #{gp['game']} AND player = #{gp['player']} LIMIT 1").first
        GamePlayer.create!(
          game_id: gp['game'],
          user_id: gp['player'],
          winner: (gp['result'] == 1 ? true : false),
          force_id: Force.where(name: gp['side']).first.id,
          snake_eyes: stats["snakeeyes"],
          boxcars: stats["boxcars"],
          beers: stats["beers"],
          rating: stats["rating"],
          previous_rating: score['pre_score'] ||= 1500,
          rating_delta: score['score'] ||= 0,
          new_rating: score['post_score'] ||= 1500)
      end
      reset_pk_sequence
    end
    desc 'update expected score for imported game_players'
    task update_expected: :environment do
      GamePlayer.where(expected_score: nil).each do |gp|
        gp.update_attributes(
          expected_score: GameRating.new(gp.game.players_for_rating).result.find {|player| player[:id] == gp.id }[:expected_score]
        )
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

    desc 'import counters'
    task counters: :environment do
      legacy_database.query('SELECT * FROM counters').each do |counter|
        Counter.create!(
          id: counter['id'],
          name: counter['name'],
          counter_type: counter['type']
        )
      end
      reset_pk_sequence
    end
  
    desc 'import scenario_counters'
    task scenario_counters: :environment do
      legacy_database.query('SELECT * FROM scenario_counters').each do |sc|
        ScenarioCounter.create!(
          scenario_id: sc['scenario'],
          force_id: Force.find_by(name: sc['side']).id,
          counter_id: sc['counters']
        )
      end
    end  

    desc 'import rules'
    task rules: :environment do
      legacy_database.query('SELECT * FROM feature').each do |feature|
        Rule.create!(
          id: feature['id'],
          name: feature['rule']
        )
      end
      reset_pk_sequence
    end
  
    desc 'import scenario_rules'
    task scenario_rules: :environment do
      legacy_database.query('SELECT * FROM scenario_feature').each do |i|
        ScenarioRule.create!(
          scenario_id: i['scenario'],
          rule_id: i['feature']
        )
      end
    end

    desc 'import maps'
    task maps: :environment do
      legacy_database.query('SELECT * FROM map').each do |i|
        Map.create!(
          id: i['id'],
          name: i['mapname']
        )
      end
      reset_pk_sequence
    end
  
    desc 'import scenario_maps'
    task scenario_maps: :environment do
      legacy_database.query('SELECT * FROM scenario_map').each do |i|
        ScenarioMap.create!(
          scenario_id: i['scenario'],
          map_id: i['map']
        )
      end
    end   

    desc 'import overlays'
    task overlays: :environment do
      legacy_database.query('SELECT * FROM overlays').each do |i|
        Overlay.create!(
          id: i['id'],
          name: i['code']
        )
      end
      reset_pk_sequence
    end
  
    desc 'import scenario_overlays'
    task scenario_overlays: :environment do
      legacy_database.query('SELECT * FROM scenario_overlays').each do |i|
        ScenarioOverlay.create!(
          scenario_id: i['scenario'],
          overlay_id: i['overlay']
        )
      end
    end   

    desc 'import locations'
    task locations: :environment do
      legacy_database.query('SELECT * FROM location').each do |i|
        Location.create!(
          id: i['id'],
          name: i['place']
        )
      end
      reset_pk_sequence
    end

    desc 'import comments'
    task comments: :environment do
      legacy_database.query("SELECT * FROM message WHERE scheme = 'scenario'").each do |msg|
        scenario = legacy_database.query("SELECT * from scenario_message WHERE message = #{msg['id']}")
        scenario = scenario.first['scenario']
        subject = legacy_database.query("SELECT * from message_content WHERE message = #{msg['id']} AND element = 'subject' LIMIT 1").first['content']
        body = legacy_database.query("SELECT * from message_content WHERE message = #{msg['id']} AND element = 'body' LIMIT 1").first['content']
        Comment.find_or_create_by!(
          id: msg['id'],
          user_id: msg['owner'],
          parent_id: msg['parent'],
          commentable_id: scenario,
          commentable_type: "Scenario",
          body: body,
          subject: subject,
          created_at: msg['created'],
          updated_at: msg['updated'].nil? ? msg['created'] : msg['updated']
        ) 
      end
      reset_pk_sequence
    end

    desc 'import forum messages'
    task forum_messages: :environment do
      legacy_database.query("SELECT * FROM message WHERE scheme IS NULL AND parent IS NULL").each do |msg|
        begin
        title = legacy_database.query(
          "SELECT * from message_content WHERE message = #{msg['id']} AND element = 'subject'"
        ).first['content']
        topic = Thredded::Topic.create!(
          id: msg['id'],
          user_id: msg['owner'],
          title: title,
          messageboard_id: 1,
          created_at: msg['created'],
          updated_at: msg['updated'] ||= msg['created']
        )
        body = legacy_database.query(
          "SELECT * from message_content WHERE message = #{msg['id']} AND element = 'body'"
        ).first['content']
        topic.posts.create!(
          id: msg['id'],
          user_id: msg['owner'],
          content: body.blank? ? "Tyhjä tekstikenttä. Laitettu tämä teksti migraatiossa." : body,
          messageboard_id: 1,
          moderation_state: 1,
          created_at: msg['created'],
          updated_at: msg['updated'] ||= msg['created']
        )
        legacy_database.query(
          "SELECT * FROM message WHERE scheme IS NULL AND parent = #{msg['id']}"
        ).each do |reply|
          content = legacy_database.query(
            "SELECT * from message_content WHERE message = #{reply['id']} AND element = 'subject'"
          ).first['content']
          content << "\n"
          content << legacy_database.query(
            "SELECT * from message_content WHERE message = #{reply['id']} AND element = 'body'"
          ).first['content']
          topic.posts.create(
            id: reply['id'],
            user_id: reply['owner'],
            content: content.blank? ? "Tyhjä tekstikenttä. Laitettu tämä teksti migraatiossa." : content,
            messageboard_id: 1,
            moderation_state: 1,
            created_at: reply['created'],
            updated_at: reply['updated'] ||= reply['created']          
          )
        end
        rescue
          byebug
        end
      end
      reset_pk_sequence
    end
  end
end

def reset_pk_sequence
  ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }
end

def legacy_database
  @client ||= Mysql2::Client.new(Rails.configuration.database_configuration['selfrally_legacy'])
end
