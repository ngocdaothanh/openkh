namespace :developer do
  desc 'Download additional things and create additional directories to prepare development environment after checking out'
  task :prepare do
    ['public/modules', 'public/themes', 'tmp'].each do |dir|
      require 'cmd'; include Cmd # to use method: create_dir_if_not_exists
      create_dir_if_not_exists(dir)
    end

    puts 'Update Javascripts for JRails...'
    Rake::Task['jrails:update:javascripts'].invoke

    puts 'Download TinyMCE...'
    Rake::Task['developer:tiny_mce:download'].invoke

    puts 'Add source code plugin for TinyMCE...'
    Rake::Task['developer:tiny_mce:add'].invoke
  end
end
