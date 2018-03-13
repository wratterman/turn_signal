class Api::V1::VehiclesController < ApplicationController

  before_action :set_vehicle, only: [:show, :update, :destroy]

  def index
    if params[:model_id].nil? && params[:make_id].nil?
      @vehicles = Vehicle.all
    elsif params[:model_id].nil?
      @vehicles = Vehicle.where(make_id: params[:make_id])
    else
      @vehicles = Vehicle.where(model_id: params[:model_id])
    end
    render json: @vehicles, each_serializer: VehiclesSerializer
  end

  def show
    render json: @vehicle, serializer: VehiclesSerializer
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.save
    render json: @vehicle, :status=> :created, serializer: VehiclesSerializer
  end

  def update
    @vehicle.update_attributes(updated_vehicle_params)
    render json: @vehicle, serializer: VehiclesSerializer
  end

  def destroy
    @vehicle.update_attributes(deleted_at: Time.now)
    render json: @vehicle, serializer: VehiclesSerializer

    # For actual DB deletion
    # @vehicle.destroy
    # head :no_content
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def vehicle_params
    params.permit(:make_id, :model_id)
  end

  def updated_vehicle_params
    {model_id: params[:new_model]}
  end
end
