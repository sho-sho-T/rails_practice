class DropTableMemberApplicationDetail < ActiveRecord::Migration[7.2]
  def change
    drop_table :member_application_details
  end
end
