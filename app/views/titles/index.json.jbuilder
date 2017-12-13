json.array!(@titles) do |title|
  json.extract! title, :id, :date, :content, :created_by_user
  json.url title_url(title, format: :json)
end
