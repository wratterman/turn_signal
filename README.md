# Turn Signal

## Installing / Getting started

To setup on project/database on your local drive...

```shell
git clone git@github.com:wratterman/turn_signal.git
cd turn_signal
bundle
rake db:create db:migrate db:seed
```

## Database

The database being used in this application is set up so with the following 3 Tables: with Attributes...

- **Makes**: id, name, deleted_at, created_at, updated_at.
- **Models**: id, name, make_id, deleted_at, created_at, updated_at.
- **Vehicles**: id, make_id, model_id, deleted_at, created_at, updated_at

The associations are...

- **Makes**: Has many models & vehicles
- **Models**: Belongs to make, has many vehicles
- **Vehicles**: Belongs to make & model

A copy of my schema can be found at http://ondras.zarovi.cz/sql/demo/ using the load option with "Turn Signal"

## Endpoints

Below are a list of possible API Endpoints that you may visit.

First, run `rails s`.

- `/api/v1/makes` collection of all makes.
    - **GET** : Returns all makes
    - **POST**: Creates a new make; required parameter `name` provided as a string. Upon completion, you will be redirected to the endpoint for that new make.
      - params can either be passed through the url, ie `.../api/v1/makes?name=x` or through the body using the format `{'name': "Example"}`.   

- `/api/v1/makes/:id` identify a specific make.
    - **GET** : Returns the individual make found by it's :id
    - **PUT** : Updates an existing make; required parameter `name` provided as a string. Upon completion, you will be redirected to the endpoint for that updated make.
      - params can either be passed through the url, ie `.../api/v1/makes/:id?name=x` or through the body using the format `{'name': "Example"}`.
    - **DELETE** : Updates the `deleted_at` attribute for the make found by :id, and all of it's dependant models and vehicles also get the same update. The deleted_at attribute updates from `nil` to a Timestamp from when the action was requested.

- `/api/v1/makes/:make_id/models` collection of all models associated with specific make found by :make_id.
    - **GET** : Returns all models belonging to make
    - **POST**: Creates a new model belonging to make with :make_id; required parameter `name` provided as a string. Upon completion, you will be redirected to the endpoint for that new model.
      - params can either be passed through the url, ie `.../api/v1/makes/:make_id/models?name=x` or through the body using the format `{'name': "Example"}`.

- `/api/v1/makes/:make_id/vehicles` collection of all vehicles associated with specific make found by :make_id.
    - **GET** : Returns all vehicles belonging to make

- `/api/v1/makes/:make_id/vehicles/:id` Individual vehicle with :id and make_id :make_id.
    - **GET** : Returns individual vehicle belonging to make
    
- `/api/v1/makes/:make_id/models/:id` Individual model with :id and make_id :make_id.
    - **GET** : Returns the individual model found by it's :id
    - **PUT** : Updates an existing model; required parameter `name` provided as a string. Upon completion, you will be redirected to the endpoint for that updated model.
      - params can either be passed through the url, ie `.../api/v1/makes/:make_id/models/:id?name=x` or through the body using the format `{'name': "Example"}`.
    - **DELETE** : Updates the `deleted_at` attribute for the model found by :id, and all of it's dependant vehicles also get the same update. The deleted_at attribute updates from `nil` to a Timestamp from when the action was requested.

- `/api/v1/makes/:make_id/models/:model_id/vehicles` collection of all vehicles associated with specific make and model found by :make_id & :model_id.
    - **GET** : Returns all vehicles associated with :make_id and :model_id
    - **POST**: Creates a new make; parameters `model_name` and `make_name` provided from URL. Upon completion, you will be redirected to the endpoint for that new vehicle.

- `/api/v1/makes/:make_id/models/:id/vehicles/:id` Individual vehicles with :id and attributes :make_id & :model_id.
    - **GET** : Returns the individual vehicle found by it's :id
    - **PUT** : Updates an existing vehicle; Require param `model` as integer for updated model_id. Upon completion, you will be redirected to the endpoint for that updated vehicle.
      - params can either be passed through the url, ie `.../api/v1/makes/:make_id/models/:model_id/vehicles/:id?model=x` or through the body using the format `{'model': 2}`.
    - **DELETE** : Updates the `deleted_at` attribute for the vehicles found by :id. The deleted_at attribute updates from `nil` to a Timestamp from when the action was requested. 

- `/api/v1/models` collection of all models.
    - **GET** : Returns all models

- `/api/v1/models/:id` identify a specific model.
    - **GET** : Returns the individual model found by it's :id

- `/api/v1/models/:model_id/vehicles` collection of all vehicles associated with specific model found by :model_id.
    - **GET** : Returns all vehicles belonging to model

- `/api/v1/models/:model_id/vehicles/:id` Individual vehicle with :id and model_id :model_id.
    - **GET** : Returns individual vehicle belonging to model

- `/api/v1/vehicles` collection of all vehicles.
    - **GET** : Returns all vehicles

- `/api/v1/vehicles/:id` identify a specific vehicle.
    - **GET** : Returns the individual vehicle found by it's :id

## JSON 

The 3 types of JSON formats for Makes, Models, and Vehicles can be found below. 

```
Make: {
  id: ,
  name: ,
  models: [
     {
       model_id: ,
       model_name: ,
       num_active_vehicles: 
     }...
   ],
   vehicles: [
     {
       vehicle_id: ,
       model_name: 
     }, ...
   ],
   total_active_vehicles: ,
   deleted_at: ,
   created_at: ,
   updated_at: 
 }

Model: {
  id: ,
  name: ,
  make: {
    model_id: ,
    model_name: 
  },
  vehicles: [
    {
      vehicle_id: ,
      make: ,
      model:  
    }, ...
   ],
   num_active_vehicles: ,
   deleted_at: ,
   created_at: ,
   updated_at: 
 }

Vehicle: {
  id: ,
  make: {
    make_id: ,
    make_name: 
  },
  model: {
    model_id: ,
    model_name: 
  },
  deleted_at: ,
  created_at: ,
  updated_at: 
 }
```

Thanks and please let me know if you need anything else!
      
