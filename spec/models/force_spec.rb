require 'rails_helper'

RSpec.describe Force, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:force)).to be_valid
  end

  it "list counters for a force in a scenario" do
    counter = FactoryBot.create(:counter)
    force = FactoryBot.create(:force)
    scen = FactoryBot.create(:scenario)
    scen.scenario_counters.create(
      force_id: force.id,
      counter_id: counter.id
    )
    expect(force.scenarios_counters(scen.id).first.id).to eql(counter.id)
  end
end
