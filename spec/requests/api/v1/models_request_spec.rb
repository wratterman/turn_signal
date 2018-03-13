require 'rails_helper'

describe "Models API" do
  it "GET a list of models with JSON 200 response" do
    # When I send a GET request to `/api/v1/makes/:make_id/models`
    # I receive a successfull response containing all models
    # And each model has an id, name, and object 'make' containing the make_id and make_name,
    # associated vehicles, number of total active vehicles, deleted_at, created_at, and updated_at

    make = create(:make) # Has no models or vehicles associated
    model_1 = create(:model, make: make)
    model_2 = create(:model, make: make)
    vehicle_1 = create(:vehicle, make: make, model: model_1)
    vehicle_2 = create(:vehicle, make: make, model: model_1)
    vehicle_3 = create(:vehicle, make: make, model: model_2)

    get "/api/v1/makes/#{make.id}/models"

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

    get "/api/v1/makes/#{make.id}/models/#{model_1.id}"
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

    get "/api/v1/makes/#{make.id}/models/#{model_2.id}"
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

  it "POST a new model with a 201 response" do
    # When I send a POST request to `/api/v1/makes/:make_id/models?name=something`
    # I receive a successfull response containing the specific model which was created
    # associated with the specific make is relates to
    # And that model has an id, name that was provide, and object 'make' containing the make_id and make_name,
    # associated vehicles, number of total active vehicles, deleted_at, created_at, and updated_at
    make = create(:make) # Has no models or vehicles associated
    expect(Model.count).to eq(0)

    post "/api/v1/makes/#{make.id}/models?name=Speedster"

    expect(response).to be_success
    expect(response.status).to eq(201)

    expect(Model.count).to eq(1)
    expect(make.models.count).to eq(1) #confirms successfully built with association

    new_model = JSON.parse(response.body, symbolize_names: true)

    expect(new_model[:name]).to eq("Speedster")
    expect(new_model[:name]).to eq(Model.last.name)
    expect(new_model[:name]).to eq(make.models.first.name)
    expect(new_model[:id]).to eq(Model.last.id)
    expect(new_model[:make][:make_id]).to eq(Model.last.make.id && make.id)
    expect(new_model[:make][:make_name]).to eq(Model.last.make.name && make.name)
    expect(new_model[:vehicles]).to eq([]) # show page for the newly created Make
    expect(new_model[:num_active_vehicles]).to eq(0) # and uses the serializer


    post "/api/v1/makes/#{make.id}/models?name=Audi"

    expect(Model.count).to eq(2) # Confirms additional model entered again
    expect(make.models.count).to eq(2)

    new_raw_model = JSON.parse(response.body, symbolize_names: true)

    expect(new_raw_model[:name]).to eq("Audi")
    expect(new_raw_model[:name]).to eq(Model.last.name)
    expect(new_raw_model[:name]).to eq(make.models.last.name)
    expect(new_raw_model[:id]).to eq(Model.last.id)
    expect(new_raw_model[:make][:make_id]).to eq(Model.last.make.id && make.id)
    expect(new_raw_model[:make][:make_name]).to eq(Model.last.make.name && make.name)
    expect(new_raw_model[:vehicles]).to eq([])
    expect(new_raw_model[:num_active_vehicles]).to eq(0)
  end
end
