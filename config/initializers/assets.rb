def remove_asset_dirs(parent)
  if RUBY_PLATFORM =~ /win/
    FileUtils.rm_r(Dir.glob("#{parent}/**"))
  else
    FileUtils.rm(Dir.glob("#{parent}/**"))
  end
end

def mirror_asset_dirs(parent, dest)
  if RUBY_PLATFORM =~ /win/
    FileUtils.mkdir(dest)
    FileUtils.cp_r(Dir.glob("#{parent}/**"), dest)
  else
    FileUtils.ln_s(parent, dest)
  end
end

# Public directories of modules ------------------------------------------------

remove_asset_dirs("#{RAILS_ROOT}/public/modules")
['core', 'standard', 'extended'].each do |type|
  Dir.glob("#{RAILS_ROOT}/modules/#{type}/**").each do |path|
    if File.exist?("#{path}/public")
      mod = path.split(File::SEPARATOR).last
      mirror_asset_dirs("#{path}/public", "#{RAILS_ROOT}/public/modules/#{mod}")
    end
  end
end

# Public directories of themes -------------------------------------------------

remove_asset_dirs("#{RAILS_ROOT}/public/themes")
Dir.glob("#{RAILS_ROOT}/themes/**").each do |path|
  if File.exist?("#{path}/public")
    theme = path.split(File::SEPARATOR).last
    mirror_asset_dirs("#{path}/public", "#{RAILS_ROOT}/public/themes/#{theme}")
  end
end

# CSS --------------------------------------------------------------------------

# Read SASS files with priority order
theme_files = []
basenames = []  # For overwriting check
Dir.glob("#{RAILS_ROOT}/themes/#{CONF[:theme]}/**/*.sass").sort.each do |f|
  basename = File.basename(f)
  theme_files << f
  basenames << basename
end
module_files = []
Dir.glob("#{RAILS_ROOT}/modules/{core,standard,extended}/**/*.sass").sort.each do |f|
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
target = "#{RAILS_ROOT}/public/stylesheets/application.css"
original_css = File.exist?(target) ? File.read(target) : ''
if css != original_css
  File.open(target, 'w') do |f|
    f.write(css)
  end
end

# JavaScript -------------------------------------------------------------------
