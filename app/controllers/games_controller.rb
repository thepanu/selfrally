# Games controller
class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit update destroy prepare_players]
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
    game_params = determine_winner(params)
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
    game_params = determine_winner(params)
    if @game.update(game_params)
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

  # :reek:UtilityFunction  and :reek:DuplicateMethodCall
  def determine_winner(params)
    winner_index = params[:game][:winner_index]
    params[:game][:game_players_attributes].each do |index|
      params[:game][:game_players_attributes][index][:winner] = index == winner_index
    end
    params.permit!
    params[:game].except(:winner_index)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def game_params
    params.require(:game).permit(:date, :scenario_id, :gamingtime, :turnsplayed, :status, game_players_attrs)
  end

  def game_players_attrs
    { game_players_attributes: %i[id game_id user_id force_id winner] }
  end
end
