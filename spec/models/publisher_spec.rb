require 'rails_helper'
RSpec.describe Publisher, type: :model do
  before do
    @publisher = Publisher.create(
      name: "Julkaisija"
    )
    @publisher2 = Publisher.create(
      name: "Toinen Julkaisija"
    ) 
    @publisher3 = Publisher.create(
      name: "Vaihtoehto"
    )
  end
  describe "search publisher name for a term" do
    context "when match is found"
    it "returns publishers that match the search term" do
      expect(Publisher.search_query("Julk")).to include(@publisher, @publisher2)
      expect(Publisher.search_query("Julk")).not_to include(@publisher3)
      expect(Publisher.search_query("vaiht")).to include(@publisher3)
    end
  end
  context "when match is not found" do
    it "returns empty collections when no results are found" do
      expect(Publisher.search_query("temppu")).to be_empty
    end
  end
end
