class PublicationsController < ApplicationController
  before_action :set_publication, only: [:show, :edit, :update, :destroy]
  access all: [:index, :show, :new, :edit, :create, :update, :destroy], user: :all

  # GET /publications
  def index
    @publications = Publication.all
  end

  # GET /publications/1
  def show
  end

  # GET /publications/new
  def new
    @publication = Publication.new
  end

  # GET /publications/1/edit
  def edit
  end

  # POST /publications
  def create
    @publication = Publication.new(publication_params)

    if @publication.save
      redirect_to @publication, notice: 'Publication was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /publications/1
  def update
    if @publication.update(publication_params)
      redirect_to @publication, notice: 'Publication was successfully updated.'
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
end
