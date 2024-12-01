class MemberApplicationDetail < ApplicationRecord
  belongs_to :member, optional: true
  belongs_to :group

  enum division: { division_0: 0, division_1: 1, division_2: 2, division_3: 3 }
end
