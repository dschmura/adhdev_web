json.cache! [team] do
  json.extract! team, :id, :name, :personal, :owner_id, :created_at, :updated_at
  json.team_members do
    json.array! team.team_members, :id, :user_id
  end
end
