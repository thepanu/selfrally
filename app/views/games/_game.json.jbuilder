json.extract! game, :id, :date, :scenario_id, :gamingtime, :turnsplayed, :status, :created_at, :updated_at
json.url game_url(game, format: :json)
