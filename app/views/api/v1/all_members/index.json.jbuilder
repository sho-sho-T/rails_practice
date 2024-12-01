json.members @all_members do |member|
  json.id member.id
  json.first_name member.first_name
  json.last_name member.last_name
  json.created_at member.created_at
  json.updated_at member.updated_at
end
