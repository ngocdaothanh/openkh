# Create application.css from all .sass files

# Read SASS files with priority order
theme_files = []
basenames = []  # For overwriting check
Dir.glob("#{Rails.root}/themes/#{CONF[:theme]}/**/*.sass").sort.each do |f|
  basename = File.basename(f)
  theme_files << f
  basenames << basename
end
module_files = []
Dir.glob("#{Rails.root}/modules/{core,standard,extended}/**/*.sass").sort.each do |f|
  basename = File.basename(f)
  unless basenames.include?(basename)
    module_files << f
    basenames << basename
  end
end

# In CSS, later rules overwrite former ones
files = module_files + theme_files

# Convert SASS to CSS
sass = files.inject('') { |tmp, f| tmp += File.read(f) }
engine = Sass::Engine.new(sass, :style => :compressed)
css = engine.render

# Overwrite old file if neccessary
target = "#{Rails.root}/public/stylesheets/application.css"
original_css = File.exist?(target) ? File.read(target) : ''
if css != original_css
  File.open(target, 'w') do |f|
    f.write(css)
  end
end
