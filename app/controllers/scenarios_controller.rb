# Scenario controller
class ScenariosController < ApplicationController
  before_action :set_scenario, only: %i[show edit update destroy comments]
  access all: %i[show index], user: { except: [:destroy] }, admin: :all

  # GET /scenarios
  def index
    (@filterrific = init_filterrific) || return
    @scenarios = @filterrific.find.page params[:page]
  rescue ActiveRecord::RecordNotFound => error
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{error.message}"
    redirect_to(reset_filterrific_url(format: :html)) && return
  end

  # GET /scenarios/1
  def show; end

  # GET /scenarios/new
  def new
    @scenario = Scenario.new
    2.times do
      @scenario.scenario_forces.build
    end
  end

  # GET /scenarios/1/edit
  def edit; end

  # POST /scenarios
  def create
    params = scenario_params
    params = update_params(params)
    @scenario = Scenario.new(params)

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

  #  def comments; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_scenario
    @scenario = Scenario.friendly.find(params[:slug] ||= params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def scenario_params
    params.require(:scenario).permit(:name, :scenario_date, :gameturns, :location_id, :initiative_index, scenario_forces: %i[force_id initiative]) # rubocop:disable Metrics/LineLength
  end

  def scenario_forces_attrs
    { scenario_forces: %i[force_id initiative] }
  end

  # :reek:DuplicateMethodCall :reek:TooManyStatements :reek:UtilityFunction
  def update_params(prams)
    initiative_index = prams[:initiative_index]
    prams[:scenario_forces].each do |index|
      prams[:scenario_forces][index][:initiative] = true if index == initiative_index
    end
    prams.permit!
    prams.except(:initiative_index)
  end

  def init_filterrific
    initialize_filterrific(
      Scenario.includes(:location),
      params[:filterrific],
      select_options: {
        sorted_by: Scenario.options_for_sorted_by
      },
      available_filters: %i[sorted_by search_query]
    )
  end
end
