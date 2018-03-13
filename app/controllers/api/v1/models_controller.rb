class Api::V1::ModelsController < ApplicationController

  before_action :set_model, only: [:show, :update, :destroy]

  def index
    if params[:make_id].nil?
      @models = Model.all
    else
      @models = Make.find(params[:make_id]).models
    end
    render json: @models, each_serializer: ModelsSerializer
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

  def destroy
    destroy_dependancies(@model)
    @model.update_attributes(deleted_at: Time.now)
    render json: @model, serializer: ModelsSerializer

    # If deleting from the database un-comments from lines 32:33 & 49
    # and comment out lines 25:27

    # @make.destroy
    # head :no_content
  end

  private

  def set_model
    @model = Model.find(params[:id])
  end

  def model_params
    params.permit(:name, :make_id)
  end

  def destroy_dependancies(model)
    model.vehicles.each do |vehicle|
      vehicle.update_attributes(deleted_at: Time.now)
      #vehicle.destroy
    end
  end
end
