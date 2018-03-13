class VehiclesSerializer < ActiveModel::Serializer

  attributes :id, :make, :model, :deleted_at, :created_at, :updated_at

  def make
    {
      make_id: @object.make_id,
      make_name: @object.make.name
    }
  end

  def model
    {
      model_id: @object.model_id,
      model_name: @object.model.name
    }
  end
end
