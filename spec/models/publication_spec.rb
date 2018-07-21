require 'rails_helper'
RSpec.describe Publication, type: :model do
  before do
    @publication = FactoryBot.create(:publication)
    @publication2 = FactoryBot.create(:publication)
    @publication3 = FactoryBot.create(:publication_alternate_name)
  end   

  describe "search publisher name for a term" do

    it "has sorting option for sorting asc/desc by name" do
      expect(Publication.options_for_sorted_by).to include(["name (a-z)", "name_asc"], ["name (z-a)", "name_desc"])
    end

    it "sorts correctly by name" do
      expect(Publication.sorted_by("name_asc")).to match_array([@publication, @publication2, @publication3])
      expect(Publication.sorted_by("name_desc")).to match_array([@publication3, @publication2, @publication])
      expect { Publication.sorted_by("something") }.to raise_error(ArgumentError)
    end
    context "when match is found" do
      it "returns publications that match the search term" do
        expect(Publication.search_query("Julk")).to match_array([@publication, @publication2])
        expect(Publication.search_query("Julk")).not_to match_array([@publication3])
        expect(Publication.search_query("vaiht")).to match_array([@publication3])
      end
    end

    context "when match is not found" do

      it "returns empty collections when no results are found" do
        expect(Publication.search_query("temppu")).to be_empty
      end
    end
  end
end
