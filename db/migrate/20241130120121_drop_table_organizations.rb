class DropTableOrganizations < ActiveRecord::Migration[7.2]
  def change
    drop_table :organizations
  end
end
