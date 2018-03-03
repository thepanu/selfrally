class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  access all: [:index, :show, :new, :edit, :create, :update, :destroy], user: :all

  # GET /games
  def index
    @games = Game.all
  end

  # GET /games/1
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  #  ScenarioForce.where(scenario_id: @game.scenario.id).each do |force|
  #     @game.game_players << GamePlayer.new( force_id: force.force_id) #, user_id: current_user.id)  
  #  end
  end                                                                                             
  # GET /games/1/edit
  def edit
#    if @game.game_players.empty?
#      2.times { @game.game_players.build }
#    end

#    byebug
#    players = []
#    if @game.game_players.empty?
#      ScenarioForce.where(scenario_id: @game.scenario.id).each do |force|
#
#        @game.game_players.new( game_id: @game.id,
#                           force_id: force.force_id) #, user_id: current_user.id)
#      end
#      byebug
  end

  # POST /games
  def create
    @game = Game.create!(game_params)
    if @game.game_players.empty?
      ScenarioForce.where(scenario_id: @game.scenario.id).each do |force|
        @game.game_players << GamePlayer.new( force_id: force.force_id) #, user_id: current_user.id)
      end
    end
    if @game.save
      redirect_to edit_game_path(@game), notice: 'Game was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /games/1
  def update
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

  # def prepare_players
  #   forces = ScenarioForce.where(scenario_id: params[:scenario_id])
  #   forces.each do |force|
  #     @game.game_players << GamePlayer.new( force_id: force.id)
  #   end
  #   respond_to do |format|
  #     format.js
  #   end
  # end
  # def prepare_players
  #   @players = []
  #   @scenario_forces = ScenarioForce.where('scenario_id = ?', params[:scenario_id])
  #   @scenario_forces.each do |scenario_force|
  #     @players << GamePlayer.new(force_id: scenario_force.force_id)
  #   end
  #   #byebug
  #   respond_to :js
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def game_params
      params.require(:game).permit(:date, :scenario_id, :gamingtime, :turnsplayed, :status, game_players_attributes: [:id, :game_id, :user_id, :force_id, :result])
    end
end
