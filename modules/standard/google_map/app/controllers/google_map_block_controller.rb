class GoogleMapBlockController < ApplicationController
  layout nil

  # Show the map full screen.
  def show
    @block = GoogleMapBlock.find(params[:id])
  end
end
