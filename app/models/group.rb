class Group < ApplicationRecord
  has_many :affiliations
  has_many :members, through: :affiliations
  has_many :member_application_details
end
