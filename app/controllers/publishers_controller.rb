# Publisher controller
class PublishersController < ApplicationController
  before_action :set_publisher, only: %i[show edit update destroy]
  access all: %i[index show new edit create update destroy], user: :all

  # GET /publishers
  def index
    (@filterrific = init_filterrific) || return
    @publishers = @filterrific.find.page params[:page]
  rescue ActiveRecord::RecordNotFound => error
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{error.message}"
    redirect_to(reset_filterrific_url(format: :html)) && return
  end

  # GET /publishers/1
  def show; end

  # GET /publishers/new
  def new
    @publisher = Publisher.new
  end

  # GET /publishers/1/edit
  def edit; end

  # POST /publishers
  def create
    @publisher = Publisher.new(publisher_params)

    if @publisher.save
      redirect_to @publisher, notice: 'Publisher was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /publishers/1
  def update
    if @publisher.update(publisher_params)
      redirect_to @publisher, notice: 'Publisher was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /publishers/1
  def destroy
    @publisher.destroy
    redirect_to publishers_url, notice: 'Publisher was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_publisher
    @publisher = Publisher.friendly.find(params[:slug])
  end

  # Only allow a trusted parameter "white list" through.
  def publisher_params
    params.require(:publisher).permit(:name)
  end

  def init_filterrific
    initialize_filterrific(
      Publisher,
      params[:filterrific],
      select_options: {
        sorted_by: Publisher.options_for_sorted_by
      },
      available_filters: %i[sorted_by search_query]
    )
  end
end
