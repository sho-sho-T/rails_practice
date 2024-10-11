class CreateMemberApplicationDetails < ActiveRecord::Migration[7.2]
  def change
    create_table :member_application_details do |t|
      t.timestamps
    end
  end
end
