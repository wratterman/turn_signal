class Api::V1::MakesController < ApplicationController

  before_action :set_make, only: [:show]
  
  def index
    render json: Make.all, each_serializer: MakesSerializer
  end

  def show
    render json: @make, serializer: MakesSerializer
  end

  private

  def set_make
    @make = Make.find(params[:id])
  end
end
