# Publications controller
class PublicationsController < ApplicationController
  before_action :set_publication, only: %i[show edit destroy]
  access all: %i[show index], user: { except: [:destroy] }, admin: :all

  # GET /publications
  def index
    (@filterrific = init_filterrific) || return
    @publications = @filterrific.find.page params[:page]
  rescue ActiveRecord::RecordNotFound => error
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{error.message}"
    redirect_to(reset_filterrific_url(format: :html)) && return
  end

  # GET /publications/1
  def show; end

  # GET /publications/new
  def new
    @publication = Publication.new
  end

  # GET /publications/1/edit
  def edit; end

  # POST /publications
  def create
    @publication = Publication.new(publication_params)

    if @publication.save
      redirect_to publication_show_path(@publication), notice: 'Publication was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /publications/1
  def update
    @publication = Publication.find_by(slug: params[:id])
    if @publication.update(publication_params)
      redirect_to publication_show_path(@publication), notice: 'Publication was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /publications/1
  def destroy
    @publication.destroy
    redirect_to publications_url, notice: 'Publication was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_publication
    @publication = Publication.friendly.find(params[:slug])
  end

  # Only allow a trusted parameter "white list" through.
  def publication_params
    params.require(:publication).permit(:name, :publishing_year, :publisher_id)
  end

  def init_filterrific
    initialize_filterrific(
      Publication.includes(:publisher),
      params[:filterrific],
      select_options: {
        sorted_by: Publication.options_for_sorted_by
      },
      available_filters: %i[sorted_by search_query]
    )
  end
end
