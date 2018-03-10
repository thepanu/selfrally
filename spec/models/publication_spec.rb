require 'rails_helper'
RSpec.describe Publication, type: :model do
  before do
      @publisher = Publisher.create(name: "Julkaisija")
      @publication = @publisher.publications.create(
        name: "Julkaisu"
      )
      @publication2 = @publisher.publications.create(
        name: "Toinen Julkaisu"
      ) 
      @publication3 = @publisher.publications.create(
        name: "Vaihtoehto"
      )
  end
  it "returns publications that match the search term" do
    expect(Publication.search_query("Julk")).to include(@publication, @publication2)
    expect(Publication.search_query("Julk")).not_to include(@publication3)
    expect(Publication.search_query("vaiht")).to include(@publication3)
  end
  it "returns empty collections when no results are found" do
    expect(Publication.search_query("temppu")).to be_empty
  end

end
