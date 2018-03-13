class Api::V1::VehiclesController < ApplicationController

  before_action :set_vehicle, only: [:show]

  def index
    @vehicles = Vehicle.where(make_id: params[:make_id], model_id: params[:model_id])
    render json: @vehicles, each_serializer: VehiclesSerializer
  end

  def show
    render json: @vehicle, serializer: VehiclesSerializer
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end
end
