require 'rails_helper'

RSpec.describe Scenario, type: :model do

  it "has a valid factory with forces" do
    expect(FactoryBot.create(:scenario_with_forces)).to be_valid
  end

  it "is valid with a date, scenario and status" do
    scen = FactoryBot.build(:scenario)
    expect(scen).to be_valid
  end


  context "belligerents" do
    before do
      @scenario = FactoryBot.create(:scenario)
      @red = FactoryBot.create(:scenario_force_with_initiative)
      @blue = FactoryBot.create(:scenario_force)
      @scenario.scenario_forces << @red
      @scenario.scenario_forces << @blue
    end

    it "outputs names of belligerents in combination" do
      belligerents = "#{@red.force.name.capitalize} - #{@blue.force.name.capitalize}"
      expect(@scenario.belligerents).to eql(belligerents)
    end
  
    it "gives the name of force with initiative" do
      expect(@scenario.initiative).to eql(@red.force.name)
    end
  end

  context "sorting" do

    before do
      @a = FactoryBot.create(:scenario, name: "a")
      @b = FactoryBot.create(:scenario, name: "b")
    end

    it "has sorting option for sorting asc/desc by name" do
      expect(Scenario.options_for_sorted_by).to include(["name (a-z)", "name_asc"], ["name (z-a)", "name_desc"])
    end

    it "sorts correctly by name" do
      expect(Scenario.sorted_by("name_asc")).to match_array([@a, @b])
      expect(Scenario.sorted_by("name_desc")).to match_array([@b, @a])
      expect { Scenario.sorted_by("something") }.to raise_error(ArgumentError)
    end

    it "finds by name" do
      expect(Scenario.search_query("a")).to match_array([@a])
      expect(Scenario.search_query("b")).to match_array([@b])
    end
  end
end
