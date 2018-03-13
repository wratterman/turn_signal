class Api::V1::ModelsController < ApplicationController

  before_action :set_model, only: [:show, :update]

  def index
    render json: Model.all, each_serializer: ModelsSerializer
  end

  def show
    render json: @model, serializer: ModelsSerializer
  end

  def create
    @model = Model.new(model_params)
    @model.save
    render json: @model, :status=> :created, serializer: ModelsSerializer
  end

  def update
    @model.update_attributes(model_params)
    render json: @model, serializer: ModelsSerializer
  end

  private

  def set_model
    @model = Model.find(params[:id])
  end

  def model_params
    params.permit(:name, :make_id)
  end
end
