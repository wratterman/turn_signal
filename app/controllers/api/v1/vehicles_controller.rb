class Api::V1::VehiclesController < ApplicationController

  def index
    @vehicles = Vehicle.where(make_id: params[:make_id], model_id: params[:model_id])
    render json: @vehicles, each_serializer: VehiclesSerializer
  end
end
