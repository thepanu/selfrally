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
    @scenario = Scenario.new(update_params)
    if @scenario.save
      redirect_to @scenario, notice: 'Scenario was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /scenarios/1
  def update
    if @scenario.update(update_params)
      redirect_to @scenario, notice: 'Scenario was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /scenarios/1
  def destroy
    if @scenario.games.empty?
      @scenario.destroy
      redirect_to scenarios_url, notice: 'Scenario was successfully destroyed.'
    else
      render :show
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_scenario
    @scenario = Scenario.friendly.find(params[:slug] ||= params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def scenario_params
    params.require(:scenario).permit(scenario_attrs, scenario_forces_attrs, rule_ids: [], map_ids: [], counter_ids: [])
  end

  def scenario_attrs
    %i[name scenario_date gameturns location_id]
  end

  def scenario_forces_attrs
    { scenario_forces_attributes: %i[id force_id initiative] }
  end

  # :reek:DuplicateMethodCall :reek:FeatureEnvy
  def update_params
    scenario = params[:scenario]
    initiative_index = scenario[:initiative_index]
    scenario[:scenario_forces_attributes].each do |index|
      scenario[:scenario_forces_attributes][index][:initiative] = index == initiative_index
    end
    scenario_params
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
