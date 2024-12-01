class Member < ApplicationRecord
  has_many :affiliations
  has_many :groups, through: :affiliations
  has_many :member_licenses
  has_one :member_application_detail

  enum division: { division_0: 0, division_1: 1, division_2: 2, division_3: 3 }
end
