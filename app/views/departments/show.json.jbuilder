json.department do
  json.id @department.id
  json.text "#{@department.website.name}: #{@department.name}"
end
