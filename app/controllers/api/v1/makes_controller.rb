class Api::V1::MakesController < ApplicationController

  before_action :set_make, only: [:show, :update]

  def index
    render json: Make.all, each_serializer: MakesSerializer
  end

  def show
    render json: @make, serializer: MakesSerializer
  end

  def create
    @make = Make.new(make_params)
    @make.save
    render json: @make, :status=> :created, serializer: MakesSerializer
  end

  def update
    @make.update_attributes(make_params)
    render json: @make, serializer: MakesSerializer
  end

  private

  def set_make
    @make = Make.find(params[:id])
  end

  def make_params
    params.permit(:name)
  end
end
