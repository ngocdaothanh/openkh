class GoogleMapMarker < ActiveRecord::Base
  validates_presence_of :latitude, :longitude
  validates_numericality_of :latitude, :longitude
end
