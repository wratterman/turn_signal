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

    expect(models.first[:num_active_vehicles]).to eq(model_1.vehicles.count && 2)
    expect(models.last[:num_active_vehicles]).to eq(model_2.vehicles.count && 1)
  end

  it "GET a specfic models by providing id in Url" do
    # When I send a GET request to `/api/v1/models/:id`
    # I receive a successfull response containing that specific model
    # And that model has an id, name, and object 'make' containing the make_id and make_name,
    # associated vehicles, number of total active vehicles, deleted_at, created_at, and updated_at

    make = create(:make) # Has no models or vehicles associated
    model_1 = create(:model, make: make)
    model_2 = create(:model, make: make)
    vehicle_1 = create(:vehicle, make: make, model: model_1)
    vehicle_2 = create(:vehicle, make: make, model: model_1)
    vehicle_3 = create(:vehicle, make: make, model: model_2)

    get "/api/v1/models/#{model_1.id}"
    expect(response).to be_success

    raw_model = JSON.parse(response.body, symbolize_names: true)

    expect(raw_model[:id]).to eq(model_1.id)
    expect(raw_model[:name]).to eq(model_1.name)
    expect(raw_model[:make][:make_id]).to eq(model_1.make.id && make.id)
    expect(raw_model[:make][:make_name]).to eq(model_1.make.name && make.name)
    expect(raw_model[:num_active_vehicles]).to eq(model_1.vehicles.count && 2)
    expect(raw_model[:deleted_at]).to be_nil
    expect(raw_model[:created_at]).to_not be_nil
    expect(raw_model[:updated_at]).to_not be_nil

    get "/api/v1/models/#{model_2.id}"
    expect(response).to be_success

    new_raw_model = JSON.parse(response.body, symbolize_names: true)

    expect(new_raw_model[:id]).to eq(model_2.id)
    expect(new_raw_model[:name]).to eq(model_2.name)
    expect(new_raw_model[:make][:make_id]).to eq(model_2.make.id && make.id)
    expect(new_raw_model[:make][:make_name]).to eq(model_2.make.name && make.name)
    expect(new_raw_model[:num_active_vehicles]).to eq(model_2.vehicles.count && 1)
    expect(new_raw_model[:deleted_at]).to be_nil
    expect(new_raw_model[:created_at]).to_not be_nil
    expect(new_raw_model[:updated_at]).to_not be_nil
  end
end
