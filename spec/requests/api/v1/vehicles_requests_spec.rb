require 'rails_helper'

describe "Vehicles API" do
  it "GET a list of vehicles with JSON 200 response" do
    # When I send a GET request to `/api/v1/makes/:make_id/models/:model_id/vehicles`
    # I receive a successfull response containing all vehicles associated with
    # that make and model
    # And each vehicle has an id, make displaying the id & name,
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

  it "GET a specfic vehicle with JSON 200 response when id is provided" do
    # When I send a GET request to `/api/v1/makes/:make_id/models/:model_id/vehicles`
    # I receive a successfull response containing all vehicles associated with
    # that make and model
    # And each vehicle has an id, make displaying the id & name,
    # model displaying the id & name, deleted_at, created_at, and updated_at
    make1 = create(:make)
    model1 = create(:model, make: make1)
    v1    = create(:vehicle, make: make1, model: model1)
    v2    = create(:vehicle, make: make1, model: model1)

    get "/api/v1/makes/#{make1.id}/models/#{model1.id}/vehicles/#{v1.id}"

    expect(response).to be_success

    raw_vehicle = JSON.parse(response.body, symbolize_names: true)

    expect(raw_vehicle[:id]).to eq(v1.id)
    expect(raw_vehicle[:id]).to_not eq(v2.id) #Shows it only received per Url ID
    # Below shows that the serializer worked
    expect(raw_vehicle[:make][:make_id]).to eq(make1.id)
    expect(raw_vehicle[:make][:make_name]).to eq(make1.name)
    expect(raw_vehicle[:model][:model_id]).to eq(model1.id)
    expect(raw_vehicle[:model][:model_name]).to eq(model1.name)
    expect(raw_vehicle[:deleted_at]).to be_nil
    expect(raw_vehicle[:created_at]).to_not be_nil
    expect(raw_vehicle[:updated_at]).to_not be_nil

    get "/api/v1/makes/#{make1.id}/models/#{model1.id}/vehicles/#{v2.id}"

    expect(response).to be_success

    raw_vehicle = JSON.parse(response.body, symbolize_names: true)

    expect(raw_vehicle[:id]).to eq(v2.id)
    expect(raw_vehicle[:id]).to_not eq(v1.id) #Shows it only received per Url ID
  end

  it "POST a new vehicle to database" do
    # When I send a POST request to `/api/v1/makes/:make_id/models/:model_id/vehicles`
    # I receive a successfull response creating a new vehicle associated with
    # that make and model
    # And that vehicle has an id, make displaying the id & name,
    # model displaying the id & name, deleted_at, created_at, and updated_at
    make1 = create(:make)
    model1 = create(:model, make: make1)

    expect(Vehicle.count).to eq(0)

    post "/api/v1/makes/#{make1.id}/models/#{model1.id}/vehicles"

    expect(response).to be_success
    expect(Vehicle.count).to eq(1)
    raw_vehicle = JSON.parse(response.body, symbolize_names: true)

    expect(raw_vehicle[:make][:make_id]).to eq(make1.id)
    expect(raw_vehicle[:make][:make_name]).to eq(make1.name)
    expect(raw_vehicle[:model][:model_id]).to eq(model1.id)
    expect(raw_vehicle[:model][:model_name]).to eq(model1.name)
    expect(raw_vehicle[:deleted_at]).to be_nil
    expect(raw_vehicle[:created_at]).to_not be_nil
    expect(raw_vehicle[:updated_at]).to_not be_nil
  end

  it "PUT an existing vehicle to database" do
    # When I send a PUT request to `/api/v1/makes/:make_id/models/:model_id/vehicles/:id?model_id=x`
    # I receive a successfull response updating a new vehicle associated with
    # that make and model
    # And that vehicle has an id, make displaying the id & name,
    # model displaying the id & name, deleted_at, created_at, and updated_at
    make1 = create(:make)
    model1 = create(:model, make: make1)
    model2 = create(:model, make: make1)
    vehicle = create(:vehicle, make: make1, model: model1)

    expect(Vehicle.count).to eq(1)

    put "/api/v1/makes/#{make1.id}/models/#{model1.id}/vehicles/#{vehicle.id}?new_model=#{model2.id}"

    expect(response).to be_success
    expect(Vehicle.count).to eq(1)
    raw_vehicle = JSON.parse(response.body, symbolize_names: true)

    expect(raw_vehicle[:make][:make_id]).to eq(make1.id)
    expect(raw_vehicle[:make][:make_name]).to eq(make1.name)
    expect(raw_vehicle[:model][:model_id]).to eq(model2.id)
    expect(raw_vehicle[:model][:model_id]).to_not eq(model1.id)
    expect(raw_vehicle[:model][:model_name]).to eq(model2.name)
    expect(raw_vehicle[:model][:model_name]).to_not eq(model1.name)
    expect(raw_vehicle[:deleted_at]).to be_nil
    expect(raw_vehicle[:created_at]).to_not be_nil
    expect(raw_vehicle[:updated_at]).to_not eq(vehicle.updated_at) #This shows it was updated
  end

  it "DELETE a specfic vehicle by inserting a Timestamp when the request was made" do
    # When I send a DELETE request to `/api/v1/makes/:make_id/models/:model_id/vehicles/:id`
    # I receive a successfull response containing showing this specific vehicle
    # And the make has an id, name that I provided, associated models, associated vehicles
    # number of total active vehicles, deleted_at NOW INCLUDING TIMESTAMP, created_at, and updated_at

    make = create(:make)
    model = create(:model, make: make)
    vehicle = create(:vehicle, make: make, model: model)

    expect(Make.count).to eq(1)
    expect(Model.count).to eq(1)
    expect(Vehicle.count).to eq(1)
    expect(make.deleted_at).to be_nil # Nil by default, until deleted.
    expect(model.deleted_at).to be_nil
    expect(vehicle.deleted_at).to be_nil # Nil by default, until deleted.

    delete "/api/v1/makes/#{make.id}/models/#{model.id}/vehicles/#{vehicle.id}"

    expect(response).to be_success

    raw_vehicle = JSON.parse(response.body, symbolize_names: true)

    expect(raw_vehicle[:id]).to eq(vehicle.id) #Shows that it is the same make
    expect(raw_vehicle[:deleted_at]).to_not be_nil # Timestamp inserted
    expect(Make.first.deleted_at).to be_nil #shows that make was not affected by vehicle deletion
    expect(Model.first.deleted_at).to be_nil #shows that make was not affected by vehicle deletion
  end

  xit "DELETE a specfic model from database" do
    # When I send a DELETE request to `/api/v1/makes/:make_id/models/:model_id/vehicles/:id`
    # I receive a successfull response deleting this specific vehicle and dependancies from database
    # And the page has no content

    make = create(:make)
    model = create(:model, make: make)
    vehicle = create(:vehicle, make: make, model: model)
    expect(Make.count).to eq(1)
    expect(Model.count).to eq(1)
    expect(Vehicle.count).to eq(1)

    delete "/api/v1/makes/#{make.id}/models/#{model.id}/vehicles/#{vehicle.id}"

    expect(response).to be_success

    expect(Make.count).to eq(1)
    expect(Model.count).to eq(1)
    expect(Vehicle.count).to eq(0) # A successful deleted model deletes vehicles as well but not makes
  end
end
