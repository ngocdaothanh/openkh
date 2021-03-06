namespace :developer do
  desc 'Download additional things and create additional directories to prepare development environment after checking out'
  task :prepare do
    require 'cmd'; include Cmd # to use method: create_dir_if_not_exists

    ['modules/extended', 'public/modules', 'public/themes', 'tmp'].each do |dir|
      create_dir_if_not_exists(dir)
    end

    puts 'Download TinyMCE...'
    Rake::Task['developer:tiny_mce:download'].invoke

    puts 'Add source code plugin for TinyMCE...'
    Rake::Task['developer:tiny_mce:add'].invoke
  end
end
