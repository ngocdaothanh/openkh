namespace :user do
  desc 'Set theme'
  task :theme => :environment do
    theme = ENV['THEME']
    raise 'THEME is required' if theme.nil?

    # Finds the first block with the given name. If the block does not
    # exist, initialize a new one and returns it.
    #
    # If the block name is in the form BlockName(attr1 = value1, attr2 = value2)
    # it is also handled correctly.
    def find_block(block_name)
      attrs = {}
      if block_name =~ /(.+)\((.*)\)/
        block_name = $1
        attrs_values = $2
        attrs_values.split(',').each do |attr_value|
          next unless attr_value =~ /(.+)=(.+)/
          attr  = $1.strip
          value = $2.strip
          attrs[attr] = value
        end
      end

      class_name = "#{block_name}Block"
      blocks = Block.find(:all, :conditions => {:type => class_name})
      blocks.each do |block|
        broken = false
        attrs.each do |attr, value|
          if block.send(attr).to_s != value
            broken = true
            break
          end
        end

        return block unless broken
      end

      # Not found, try initializing a new one
      klass = class_name.constantize
      block = klass.new
      attrs.each { |attr, value| block.send("#{attr}=", value) }
      block
    end

    regions_blocks = YAML.load(File.read("#{RAILS_ROOT}/themes/#{theme}/regions_blocks.yml"))

    # Set all existing blocks as unused
    blocks = Block.all
    blocks.each do |b|
      b.region = -1
      b.save
    end

    # Arrange blocks
    regions_blocks['regions'].each_with_index do |region_name, iregion|
      regions_blocks[region_name].each_with_index do |block_name, iblock|
        block = find_block(block_name)
        block.region = iregion
        block.position = iblock + 1
        block.save
      end
    end

    site_conf = SiteConf.instance
    site_conf.theme = theme
    site_conf.save
  end
end
