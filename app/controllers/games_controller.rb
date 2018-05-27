# Games controller
class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit update destroy prepare_players]
  after_action :assign_badges, only: %i[update]
  access all: %i[show index], user: { except: [:destroy] }, admin: :all

  # GET /games
  def index
    @games = Game.order(id: :desc).page params[:page]
  end

  # GET /games/1
  def show; end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit; end

  # POST /games
  def create
    #    game_params = determine_winner(params)
    #    game_params = params[:game]
    @game = Game.create!(game_params)
    prepare_players
    if @game.save
      redirect_to edit_game_path(@game), notice: 'Game was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /games/1
  def update
    game_params = update_params(params)
    if @game.update(game_params)
      @game.update_ratings
      redirect_to @game, notice: 'Game was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /games/1
  def destroy
    @game.destroy
    redirect_to games_url, notice: 'Game was successfully destroyed.'
  end

  def prepare_players
    return unless @game.no_players?
    @game.scenario.forces.each do |force|
      @game.game_players << GamePlayer.new(force_id: force.id)
    end
  end

  private

  # :reek:DuplicateMethodCall :reek:TooManyStatements :reek:UtilityFunction
  def update_params(params)
    winner_index = params[:game][:winner_index]
    params[:game][:game_players_attributes].each do |index|
      if index == winner_index
        params[:game][:game_players_attributes][index][:winner] = true
        params[:game][:status] = 'finished'
      end
    end
    params.permit!
    params[:game].except(:winner_index)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  # :reek:FeatureEnvy
  def assign_badges
    @game.game_players.each do |player|
      player.user.check_for_promotion(@game.date)
    end
  end

  # Only allow a trusted parameter "white list" through.
  def game_params
    params.require(:game).permit(:date, :scenario_id, :gamingtime, :turnsplayed, :status, game_players_attrs)
  end

  def game_players_attrs
    { game_players_attributes: %i[id game_id user_id force_id winner] }
  end
end
