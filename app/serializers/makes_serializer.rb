class MakesSerializer < ActiveModel::Serializer
  attributes :id, :name, :models, :vehicles, :total_active_vehicles,
             :deleted_at, :created_at, :updated_at

  def models
    @object.models.map do |model|
      {
        model_id: model.id,
        name: model.name,
        num_active_vehicles: model
        .vehicles
        .where(model: model, deleted_at: nil)
        .count
      }
    end
  end

  def vehicles
    @object.vehicles.map do |vehicle|
      {
      vehicle_id: vehicle.id,
      model_name: vehicle.model.name
      }
    end
  end

  # Providing all model & vehicle attributes on the makes endpoint seemed unneccesary
  # Providing the ID and Name which should be plenty to access the endpoint for that model or vehicle

  def total_active_vehicles
    @object.vehicles
           .where(make: @object, deleted_at: nil)
           .count
  end

  # Just thought this was interesting
end
