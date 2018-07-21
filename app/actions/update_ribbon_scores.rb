# Action Object to update users ribbon score, saved in UserRibbon
class UpdateRibbonScores
  def initialize(params)
    @user = params[:user]
    @ribbons = params[:ribbons]
  end

  def self.call(params)
    new(params).call
  end

  def call
    @ribbons.each do |ribbon|
      update_points(ribbon)
    end
  end

  private

  def update_points(ribbon)
    points = ribbon.games.joins(:game_players).where('game_players.user_id = ?', @user.id).count
    @user.user_ribbons.find_or_create_by(ribbon_id: ribbon.id).update_attributes(
      points: points,
      badgeclass: get_badge_class(points)
    )
  end

  # :reek:UtilityFunction
  def get_badge_class(points)
    BADGE_CLASS_CRITERIA.index(
      BADGE_CLASS_CRITERIA.select { |criteria| points >= criteria[:lower] && points <= criteria[:upper] }[0]
    )
  end
end
