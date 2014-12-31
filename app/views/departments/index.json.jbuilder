json.array!(@departments) do |department|
  json.extract! department, :id, :name
  json.website department.website.name
end