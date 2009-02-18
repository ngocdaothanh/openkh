namespace :developer do
  desc 'Prepare development environment after checking out'
  task :prepare do
    ['public/modules', 'public/themes', 'tmp'].each do |dir|
      unless File.directory?(dir)
        puts "Create #{dir}..."
        FileUtils.mkdir_p(dir)
      end
    end

    puts 'Update Javascripts for JRails...'
    Rake::Task['jrails:update:javascripts'].invoke

    puts 'Download TinyMCE...'
    Rake::Task['developer:tiny_mce:download'].invoke

    puts 'Add source code plugin for TinyMCE...'
    Rake::Task['developer:tiny_mce:add'].invoke
  end
end