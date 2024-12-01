class AddColumnsMembersAndMemberApplicationDetail < ActiveRecord::Migration[7.2]
  def change
    add_column :members, :division, :bigint, null: false
    add_column :member_application_details, :division, :bigint, null: false
  end
end
