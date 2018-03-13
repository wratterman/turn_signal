class ModelsSerializer < ActiveModel::Serializer
  attributes :id, :name, :make, :num_active_vehicles,
             :deleted_at, :created_at, :updated_at

  def make
    {
      make_id: @object.make.id,
      make_name: @object.make.name,
    }
  end

  def num_active_vehicles
    @object.vehicles.where(model: @object, deleted_at: nil).count
  end
end
