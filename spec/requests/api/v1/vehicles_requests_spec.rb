require 'rails_helper'

describe "Vehicles API" do
  it "GET a list of vehicles with JSON 200 response" do
    # When I send a GET request to `/api/v1/makes/:make_id/models/:model_id/vehicles`
    # I receive a successfull response containing all vehicles associated with
    # that make and model
    # And each make has an id, make displaying the id & name,
    # model displaying the id & name, deleted_at, created_at, and updated_at

    make1 = create(:make)
    model1 = create(:model, make: make1)
    v1    = create(:vehicle, make: make1, model: model1)
    v2    = create(:vehicle, make: make1, model: model1)
    make2 = create(:make)
    model2 = create(:model, make: make2)
    v3    = create(:vehicle, make: make2, model: model2)
    v4    = create(:vehicle, make: make2, model: model2)
    v5    = create(:vehicle, make: make2, model: model2)
    model3 = create(:model, make: make2)
    v6    = create(:vehicle, make: make2, model: model3)

    expect(Vehicle.count).to eq(6)

    get "/api/v1/makes/#{make1.id}/models/#{model1.id}/vehicles"

    expect(response).to be_success

    raw_vehicles = JSON.parse(response.body, symbolize_names: true)

    expect(raw_vehicles.length).to eq(2)
    expect(raw_vehicles.first[:make][:make_id] && raw_vehicles.last[:make][:make_id]).to eq(make1.id)
    expect(raw_vehicles.first[:make][:make_name] && raw_vehicles.last[:make][:make_name]).to eq(make1.name)
    expect(raw_vehicles.first[:model][:model_id] && raw_vehicles.last[:model][:model_id]).to eq(model1.id)
    expect(raw_vehicles.first[:model][:model_name] && raw_vehicles.last[:model][:model_name]).to eq(model1.name)
    expect(raw_vehicles.first[:id]).to_not eq(raw_vehicles.last[:id])
    # These show that even though the two vehicles have the same make and model
    # They are different cars

    get "/api/v1/makes/#{make2.id}/models/#{model2.id}/vehicles"

    expect(response).to be_success

    raw_vehicles = JSON.parse(response.body, symbolize_names: true)
    expect(raw_vehicles.length).to eq(3)
    expect(raw_vehicles.first[:make][:make_id] && raw_vehicles.last[:make][:make_id]).to eq(make2.id)
    expect(raw_vehicles.first[:make][:make_name] && raw_vehicles.last[:make][:make_name]).to eq(make2.name)
    expect(raw_vehicles.first[:model][:model_id] && raw_vehicles.last[:model][:model_id]).to eq(model2.id)
    expect(raw_vehicles.first[:model][:model_name] && raw_vehicles.last[:model][:model_name]).to eq(model2.name)
    expect(raw_vehicles.first[:id]).to_not eq(raw_vehicles.last[:id])

    get "/api/v1/makes/#{make2.id}/models/#{model3.id}/vehicles"

    expect(response).to be_success

    raw_vehicles = JSON.parse(response.body, symbolize_names: true)
    expect(raw_vehicles.length).to eq(1)
    expect(raw_vehicles.first[:make][:make_id]).to eq(make2.id)
    expect(raw_vehicles.first[:make][:make_name]).to eq(make2.name)
    expect(raw_vehicles.first[:model][:model_id]).to eq(model3.id)
    expect(raw_vehicles.first[:model][:model_name]).to eq(model3.name)
  end
end
