class AddOrderArrayToVersions < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.column_exists?(:versions, :orderArray)
      add_column :versions, :orderArray, :text
    end
  end
  
  def self.down
	unless !ActiveRecord::Base.connection.column_exists?(:versions, :orderArray)
		remove_column :versions, :orderArray
	end
  end
end
