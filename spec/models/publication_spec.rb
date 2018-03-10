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
  describe "search publisher name for a term" do
    context "when match is found"
    it "returns publications that match the search term" do
      expect(Publication.search_query("Julk")).to include(@publication, @publication2)
      expect(Publication.search_query("Julk")).not_to include(@publication3)
      expect(Publication.search_query("vaiht")).to include(@publication3)
    end
  end
  context "when match is not found" do
    it "returns empty collections when no results are found" do
      expect(Publication.search_query("temppu")).to be_empty
    end
  end
end
