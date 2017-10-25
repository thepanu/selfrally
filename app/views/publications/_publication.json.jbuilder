json.extract! publication, :id, :name, :publishing_year, :publisher_id, :created_at, :updated_at
json.url publication_url(publication, format: :json)
