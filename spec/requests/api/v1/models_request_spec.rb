require 'rails_helper'

describe "Models API" do
  it "GET a list of models with JSON 200 response" do
    # When I send a GET request to `/api/v1/models`
    # I receive a successfull response containing all models
    # And each model has an id, name, and object 'make' containing the make_id and make_name,
    # associated vehicles, number of total active vehicles, deleted_at, created_at, and updated_at

    make = create(:make) # Has no models or vehicles associated
    model_1 = create(:model, make: make)
    model_2 = create(:model, make: make)
    vehicle_1 = create(:vehicle, make: make, model: model_1)
    vehicle_2 = create(:vehicle, make: make, model: model_1)
    vehicle_3 = create(:vehicle, make: make, model: model_2)

    get "/api/v1/models"

    expect(response).to be_success

    models = JSON.parse(response.body, symbolize_names: true)
    expect(models.length).to eq(2)

    expect(models.first[:id]).to eq(model_1.id)
    expect(models.last[:id]).to eq(model_2.id)

    expect(models.first[:name]).to eq(model_1.name)
    expect(models.last[:name]).to eq(model_2.name)

    expect(models.first[:make][:make_id]).to eq(model_1.make.id)
    expect(models.last[:make][:make_id]).to eq(model_2.make.id)
    expect(models.first[:make][:make_name]).to eq(model_1.make.name)
    expect(models.last[:make][:make_name]).to eq(model_2.make.name)

    expect(models.first[:num_active_vehicles]).to eq(model_1.vehicles.count)
    expect(models.last[:num_active_vehicles]).to eq(model_2.vehicles.count)
  end
end
