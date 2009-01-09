class GoogleMapBlock < Block
  has_many :markers, :class_name => 'GoogleMapMarker', :dependent => :delete_all

  acts_as_configurable do |c|
    c.string :title,  :default => I18n.t('google_map_block.defaul.title')
    c.string :width,  :default => '100%'
    c.string :height, :default => '300px'
  end

  # Returns the center of the map, calculated from all markers.
  def center
    @center ||= begin
      if markers.blank?
        {:latitude => 0, :longitude => 0}
      else
        lat = 0
        lon = 0
        count = 0
        markers.each do |m|
          lat += m.latitude
          lon += m.longitude
          count += 1
        end
        lat = 1.0*lat/count
        lon = 1.0*lon/count
        {:latitude => lat, :longitude => lon}
      end
    end
  end

  def sw_ne
    @sw_ne ||= begin
      if markers.blank?
        {:sw => {:s => 0, :w => 0}, :ne => {:n => 0, :e => 0}}
      else
        s = nil
        n = nil
        w = nil
        e = nil
        markers.each do |m|
          s = m.longitude if s.nil? || s > m.longitude
          n = m.longitude if n.nil? || n < m.longitude
          w = m.latitude if w.nil? || w > m.latitude
          e = m.latitude if e.nil? || e < m.latitude
        end
        {:sw => {:s => s, :w => w}, :ne => {:n => n, :e => e}}
      end
    end
  end
end
