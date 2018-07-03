class ChangeInitiativeTypeInScenarioForces < ActiveRecord::Migration[5.1]
  def change 
    change_column :scenario_forces, :initiative, 'boolean USING CAST(initiative AS boolean)'
  end
end
