Vehicle.destroy_all
Model.destroy_all
Make.destroy_all

MAKES = ["Honda", "Toyota", "Ford"]
HONDA_MODELS = ["Accord", "Civic", "CR-V"]
TOYOTA_MODELS = ["Corolla", "Camry", "Prius"]
FORD_MODELS = ["Focus", "F-150", "Model-T"]

def seed_database
  MAKES.length.times do
    make = MAKES.sample
    created_make = Make.create(name: make)
    puts "Make #{created_make.name} Created"
    seed_models(created_make)
    MAKES.delete(make)
  end
  seed_vehicles
end

def seed_models(make)
  case make.name
  when "Honda"
    HONDA_MODELS.each do |model|
      create_models(model, make)
    end
  when "Toyota"
    TOYOTA_MODELS.each do |model|
      create_models(model, make)
    end
  when "Ford"
    FORD_MODELS.each do |model|
      create_models(model, make)
    end
  end
end

def create_models(model, make)
  created_model = Model.create(name: model, make: make)
  puts "Model #{created_model.name} Created"
end

def seed_vehicles
  rand(120..150).times do
    make = Make.all.sample
    model = make.models.sample
    vehicle = Vehicle.create(make_id: make.id, model_id: model.id)
    puts "Vehicle #{make.name} #{model.name} Created"
  end
end

seed_database
