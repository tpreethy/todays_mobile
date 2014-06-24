json.array!(@stores) do |store|
  json.extract! store, :id, :model_name, :brand, :color, :price, :description, :feature1, :feature2
  json.url store_url(store, format: :json)
end
