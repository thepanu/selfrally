# Maps controller
class MapsController < ApplicationController
  before_action :set_map, only: %i[show edit destroy update]
  access all: %i[show index], user: { except: [:destroy] }, admin: :all

  def index
    @maps = Map.page(params[:page]).per(50)
  end

  def show; end

  def new
    @map = Map.new
  end

  def edit; end

  def create
    @map = Map.new(map_params)

    if @map.save
      redirect_to map_path(@map), notice: 'Map was successfully created.'
    else
      render :new
    end
  end

  def update
    if @map.update(map_params)
      redirect_to map_path(@map), notice: 'Map was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @map.destroy
    redirect_to maps_path, notice: 'Map was successfully destroyed.'
  end

  private

  def map_params
    params.require(:map).permit(:name)
  end

  def set_map
    @map = Map.find(params[:id])
  end
end
