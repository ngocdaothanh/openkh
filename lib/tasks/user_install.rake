namespace :user do
  desc 'Install OpenKH'
  task :install do
    puts 'Create basic data tables...'
    Rake::Task['db:migrate'].invoke

    puts 'Create data tables for modules...'
    Rake::Task['developer:db:migrate:modules'].invoke

    puts 'OpenKH installed, run rake user:demo if you want a demo site'
  end
end
