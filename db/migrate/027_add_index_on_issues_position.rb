class AddIndexOnIssuesPosition < ActiveRecord::Migration[4.2]
  def self.up
    add_index :issues, :position 
  end

  def self.down
    remove_index :issues, :position 
  end
end
