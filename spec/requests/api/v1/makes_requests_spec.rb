require 'rails_helper'

describe "Makes API" do
  it "GET a list of makes with JSON 200 response" do
    # When I send a GET request to `/api/v1/makes`
    # I receive a successfull response containing all makes
    # And each make has an id, name, associated models, associated vehicles
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

  it "GET a specfic make with a 200 response" do
    # When I send a GET request to `/api/v1/makes/:id`
    # I receive a successfull response containing the specific make who's id was provided
    # And the make has an id, name, associated models, associated vehicles
    # number of total active vehicles, deleted_at, created_at, and updated_at
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

    expect(new_raw_make[:models].first[:model_id]).to eq(model.id)
    expect(new_raw_make[:models].first[:name]).to eq(model.name)
    expect(new_raw_make[:models].first[:num_active_vehicles]).to eq(1)
    expect(new_raw_make[:vehicles].first[:vehicle_id]).to eq(vehicle.id)
    expect(new_raw_make[:vehicles].first[:model_name]).to eq(vehicle.model.name)
    expect(new_raw_make[:total_active_vehicles]).to eq(1)
  end

  it "POST a new make with a 201 response" do
    # When I send a POST request to `/api/v1/makes?name=something`
    # I receive a successfull response containing the specific make which was created
    # And the make has an id, name that I provided, associated models, associated vehicles
    # number of total active vehicles, deleted_at, created_at, and updated_at

    expect(Make.count).to eq(0)

    post "/api/v1/makes?name=SmartCar"

    expect(response).to be_success
    expect(response.status).to eq(201)

    expect(Make.count).to eq(1) #Line 91 and this show something was successfully entered into the database

    new_make = JSON.parse(response.body, symbolize_names: true)

    expect(new_make[:name]).to eq("SmartCar")
    expect(new_make[:name]).to eq(Make.last.name)
    expect(new_make[:id]).to eq(Make.last.id)
    expect(new_make[:models]).to eq([]) # Lines 105:107 being empty shows it redirects to the
    expect(new_make[:vehicles]).to eq([]) # show page for the newly created Make
    expect(new_make[:total_active_vehicles]).to eq(0) # and uses the serializer

    post "/api/v1/makes?name=Audi"

    expect(Make.count).to eq(2) # Confirms what Line 98 shows
  end

  it "PUT an existing make" do
    # When I send a PUT request to `/api/v1/makes/:id?name=something`
    # I receive a successfull response containing the specific make which I updated
    # And the make has an id, name that I changed, associated models, associated vehicles
    # number of total active vehicles, deleted_at, created_at, and new updated_at

    make1 = create(:make) # Has no models or vehicles associated
    old_updated_at = make1.updated_at

    expect(make1.name).to_not eq("SmartCar")

    expect(Make.count).to eq(1)
    put "/api/v1/makes/#{make1.id}?name=SmartCar"

    expect(response).to be_success

    expect(Make.count).to eq(1) # Shows that nothing was added to the database

    make = JSON.parse(response.body, symbolize_names: true)

    expect(make[:name]).to eq("SmartCar")
    expect(make[:id]).to eq(make1.id)
    expect(make[:updated_at]).to_not eq(old_updated_at)

    put "/api/v1/makes/#{make1.id}?name=Audi"

    make = JSON.parse(response.body, symbolize_names: true)

    expect(make[:name]).to eq("Audi")
    expect(make[:id]).to eq(make1.id)
  end

  it "DELETE a specfic make by inserting a Timestamp when the request was made" do
    # When I send a DELETE request to `/api/v1/makes/:ID`
    # I receive a successfull response containing the specific make which was created
    # And the make has an id, name that I provided, associated models, associated vehicles
    # number of total active vehicles, deleted_at NOW INCLUDING TIMESTAMP, created_at, and updated_at

    make = create(:make)
    expect(Make.count).to eq(1)
    expect(make.deleted_at).to be_nil # Nil by default, until deleted.

    delete "/api/v1/makes/#{make.id}"

    expect(response).to be_success

    raw_make = JSON.parse(response.body, symbolize_names: true)

    expect(raw_make[:id]).to eq(make.id) #Shows that it is the same make
    expect(raw_make[:deleted_at]).to_not be_nil # Timestamp inserted
  end

  # Here is the test if I were going to just delete the make from the database
  # To run, comment out lines 25-26 in MakesController, uncomment lines 31-32 & 46-53
  # and skip the test above & unskip the text below

  xit "DELETE a specfic make with a 204 response" do
    #When I send a DELETE request to `/api/v1/makes/:id`
    #I receive a successfull 204 response containing the specific make which was created
    #And the make is deleted form the database

    make = create(:make)
    model = create(:model, make: make)
    create(:vehicle, make: make, model: model)
    expect(Make.count).to eq(1)
    expect(Model.count).to eq(1)
    expect(Vehicle.count).to eq(1)

    delete "/api/v1/makes/#{make.id}"

    expect(response).to be_success
    expect(response.status).to eq(204)
    expect(Make.count).to eq(0)
    expect(Model.count).to eq(0)   # Destroys depandancies as well
    expect(Vehicle.count).to eq(0)
  end
end
