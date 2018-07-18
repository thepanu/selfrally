require 'rails_helper'
RSpec.describe Publisher, type: :model do
  before do

    @publisher = FactoryBot.create(:publisher, name: "Julkaisija")
    @publisher2 = FactoryBot.create(:publisher, name: "Toinen Julkaisija")
    @publisher3 = FactoryBot.create(:publisher, name: "Vaihtoehto")
  end
  describe "search publisher name for a term" do
    it "has sorting option for sorting asc/desc by name" do
      expect(Publisher.options_for_sorted_by).to include(["name (a-z)", "name_asc"], ["name (z-a)", "name_desc"])
    end

    it "sorts correctly by name" do
      expect(Publisher.sorted_by("name_asc")).to match_array([@publisher, @publisher2, @publisher3])
      expect(Publisher.sorted_by("name_desc")).to match_array([@publisher3, @publisher2, @publisher])
      expect { Publisher.sorted_by("something") }.to raise_error(ArgumentError)
    end
    
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
