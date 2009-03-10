namespace :user do
  desc 'Update README.html'
  task :readme => :environment do  # Use :environment only to use HAML
    template = %q{
!!!
%html
  %head
    %title OpenKH README
  %body
    %h1 OpenKH README
    = main_readme
    %hr
    %h1 README of modules
    - modules.each do |mod|
      %h2= mod[:name]
      = mod[:readme]
}

    main_readme = RedCloth.new(File.read('README.textile')).to_html
    modules = []
    ['modules', 'themes'].each do |dir|
      Dir.glob("#{dir}/**/README.textile").each do |file|
        mod = {}
        array = file.split(File::SEPARATOR)
        mod[:name]   = array[array.index('README.textile') - 1]
        mod[:readme] = RedCloth.new(File.read(file)).to_html
        modules << mod
      end
    end

    html = Haml::Engine.new(template).render(Object.new, :main_readme => main_readme, :modules => modules)
    File.open('README.html', 'w') { |f| f.write(html) }
  end
end
