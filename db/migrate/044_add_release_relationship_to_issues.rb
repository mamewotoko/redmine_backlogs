class AddReleaseRelationshipToIssues < ActiveRecord::Migration[4.2]
  def self.up
      add_column :issues, :release_relationship, :string, :default => 'auto', :null => false
  end
  
  def self.down
    remove_column :issues, :release_relationship
  end
end
