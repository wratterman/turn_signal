class Api::V1::MakesController < ApplicationController

  before_action :set_make, only: [:show, :update, :destroy]

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

  def destroy
    @make.update_attributes(deleted_at: Time.now)
    render json: @make, serializer: MakesSerializer

    # If deleting from the database un-comments from lines 31:32 & 46:53
    # and comment out lines 25:26

    # destroy_dependancies(@make)
    # @make.destroy
    # head :no_content
  end

  private

  def set_make
    @make = Make.find(params[:id])
  end

  def make_params
    params.permit(:name)
  end

  # def destroy_dependancies(make)
  #   make.vehicles.each do |vehicle|
  #     vehicle.destroy
  #   end
  #   make.models.each do |model|
  #     model.destroy
  #   end
  # end
end
