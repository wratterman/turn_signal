class Api::V1::ModelsController < ApplicationController

  before_action :set_model, only: [:show]

  def index
    render json: Model.all, each_serializer: ModelsSerializer
  end

  def show
    render json: @model, serializer: ModelsSerializer
  end

  private

  def set_model
    @model = Model.find(params[:id])
  end
end
