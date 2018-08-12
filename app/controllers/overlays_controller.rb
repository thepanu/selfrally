# Overlays controller
class OverlaysController < ApplicationController
  before_action :set_overlay, only: %i[show edit destroy update]
  access all: %i[show index], user: { except: [:destroy] }, admin: :all

  def index
    @overlays = Overlay.page(params[:page]).per(50)
  end

  def show; end

  def new
    @overlay = Overlay.new
  end

  def edit; end

  def create
    @overlay = Overlay.new(overlay_params)

    if @overlay.save
      redirect_to overlay_path(@overlay), notice: 'Overlay was successfully created.'
    else
      render :new
    end
  end

  def update
    if @overlay.update(overlay_params)
      redirect_to overlay_path(@overlay), notice: 'Overlay was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @overlay.destroy
    redirect_to overlays_path, notice: 'Overlay was successfully destroyed.'
  end

  private

  def overlay_params
    params.require(:overlay).permit(:name)
  end

  def set_overlay
    @overlay = Overlay.find(params[:id])
  end
end
