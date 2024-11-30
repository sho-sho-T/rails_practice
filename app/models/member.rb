class Member < ApplicationRecord
  has_many :affiliations
  has_many :groups, through: :affiliations
  has_many :member_licenses
  has_one :member_application_detail
end
