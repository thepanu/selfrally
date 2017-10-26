class ScenariosController < ApplicationController
  before_action :set_scenario, only: [:show, :edit, :update, :destroy]
  access all: [:index, :show, :new, :edit, :create, :update, :destroy], user: :all

  # GET /scenarios
  def index
    @scenarios = Scenario.all
  end

  # GET /scenarios/1
  def show
  end

  # GET /scenarios/new
  def new
    @scenario = Scenario.new
  end

  # GET /scenarios/1/edit
  def edit
  end

  # POST /scenarios
  def create
    @scenario = Scenario.new(scenario_params)

    if @scenario.save
      redirect_to @scenario, notice: 'Scenario was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /scenarios/1
  def update
    if @scenario.update(scenario_params)
      redirect_to @scenario, notice: 'Scenario was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /scenarios/1
  def destroy
    @scenario.destroy
    redirect_to scenarios_url, notice: 'Scenario was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scenario
      @scenario = Scenario.friendly.find(params[:slug])
    end

    # Only allow a trusted parameter "white list" through.
    def scenario_params
      params.require(:scenario).permit(:name, :scenario_date, :gameturn, :location_id, :slug)
    end
end