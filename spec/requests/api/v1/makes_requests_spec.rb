require 'rails_helper'

describe "Makes API" do
  it "sends a list of makes with JSON 200 respons" do
    # When I send a GET request to `/api/v1/makes`
    # I receive a successfull response containing all makes
    # And each item has an id, name, associated models, associated vehicles
    # number of total active vehicles, deleted_at, created_at, and updated_at

    make1 = create(:make) # Has no models or vehicles associated
    make2 = create(:make) # Has 1 model and 1 vehicle associated, used to show accurately
    model = create(:model, make: make2)
    vehicle = create(:vehicle, make: model.make, model: model)
    get "/api/v1/makes"

    expect(response).to be_success

    raw_makes = JSON.parse(response.body, symbolize_names: true)
    expect(raw_makes.length).to eq(2)

    expect(raw_makes.first[:id]).to eq(make1.id)
    expect(raw_makes.first[:name]).to eq(make1.name)
    expect(raw_makes.first[:models].class).to eq(Array) # Lines 18:21 testing serializer additions
    expect(raw_makes.first[:models].count).to eq(0)
    expect(raw_makes.first[:vehicles].class).to eq(Array)
    expect(raw_makes.first[:total_active_vehicles]).to eq(0)
    expect(raw_makes.first[:deleted_at]).to be_nil # This should only not be nil on the DELETE action
    expect(raw_makes.first[:created_at]).to_not be_nil
    expect(raw_makes.first[:updated_at]).to_not be_nil

    expect(raw_makes.last[:id]).to eq(make2.id)
    expect(raw_makes.last[:name]).to eq(make2.name)
    expect(raw_makes.last[:models].class).to eq(Array)
    expect(raw_makes.last[:models].count).to eq(1)
    expect(raw_makes.last[:models].first[:model_id]).to eq(model.id)
    expect(raw_makes.last[:models].first[:name]).to eq(model.name)
    expect(raw_makes.last[:vehicles].class).to eq(Array)
    expect(raw_makes.last[:vehicles].first[:vehicle_id]).to eq(vehicle.id)
    expect(raw_makes.last[:vehicles].first[:model_name]).to eq(vehicle.model.name)
    expect(raw_makes.last[:total_active_vehicles]).to eq(1)
    expect(raw_makes.last[:deleted_at]).to be_nil
    expect(raw_makes.last[:created_at]).to_not be_nil
    expect(raw_makes.last[:updated_at]).to_not be_nil
  end

  it "gets a specfic item with a 200 response" do
    make1 = create(:make) # Has no models or vehicles associated
    make2 = create(:make) # Has 1 model and 1 vehicle associated, used to show accurately
    model = create(:model, make: make2)
    vehicle = create(:vehicle, make: model.make, model: model)

    get "/api/v1/makes/#{make1.id}"

    expect(response).to be_success
    expect(response.status).to eq(200)

    raw_make = JSON.parse(response.body, symbolize_names: true)

    expect(raw_make[:id]).to eq(make1.id)
    expect(raw_make[:id]).to_not eq(make2.id)

    expect(raw_make[:name]).to eq(make1.name)
    expect(raw_make[:name]).to_not eq(make2.name)

    expect(raw_make[:models]).to eq([])
    expect(raw_make[:vehicles]).to eq([])
    expect(raw_make[:total_active_vehicles]).to eq(0)

    get "/api/v1/makes/#{make2.id}"

    expect(response).to be_success
    expect(response.status).to eq(200)

    new_raw_make = JSON.parse(response.body, symbolize_names: true)

    expect(new_raw_make[:id]).to eq(make2.id)
    expect(new_raw_make[:id]).to_not eq(make1.id)

    expect(new_raw_make[:name]).to eq(make2.name)
    expect(new_raw_make[:name]).to_not eq(make1.name)

    expect(raw_make[:models].first[:model_id]).to eq(model.id)
    expect(raw_make[:models].first[:name]).to eq(model.name)
    expect(raw_make[:models].first[:num_active_vehicles]).to eq(1)
    expect(raw_make[:vehicles].first[:model_id]).to eq(model.id)
    expect(raw_make[:vehicles].first[:model_name]).to eq(model.name)
    expect(raw_make[:total_active_vehicles]).to eq(1)
  end
end
