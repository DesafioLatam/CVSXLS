json.array!(@documents) do |document|
  json.extract! document, :id, :name, :file
  json.url document_url(document, format: :json)
end
