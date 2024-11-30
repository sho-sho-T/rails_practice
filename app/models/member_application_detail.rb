class MemberApplicationDetail < ApplicationRecord
  belongs_to :member, optional: true
  belongs_to :group
end
