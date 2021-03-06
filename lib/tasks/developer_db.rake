# Copied from the source code of Rails DB migration tasks.
#
# One thing, dumping is not neccessary:
# Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
namespace :developer do
  namespace :db do
    desc 'This task is used internally by others to ensure that MODULE environment variable is given'
    task :check_module do
      if ENV["MODULE"]
        # Set the full module name back to ENV["MODULE"]
        found = false
        ["core", "standard", "extended"].each do |type|
          if File.exist?("#{Rails.root}/modules/#{type}/#{ENV["MODULE"]}")
            found = true
            ENV["MODULE"] = "#{type}/#{ENV["MODULE"]}"
            break
          end
        end
        raise "Module not found" unless found
      else
        raise "MODULE is required"
      end
    end

    desc 'Migrate the database through scripts in db/migrate and update db/schema.rb by invoking db:schema:dump. Target specific version with VERSION=x. Turn off output with VERBOSE=false.'
    task :migrate => [:environment, "developer:db:check_module"] do
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migrator.migrate("modules/#{ENV["MODULE"]}/db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    end

    namespace :migrate do
      desc 'Calculate migration prefix number from module name'
      task :prefix => "developer:db:check_module" do
        require 'base64'

        module_name = ENV['MODULE']
        module_name = Base64.encode64(module_name).gsub(/[^A-Za-z0-9+\/]/, '')
        DICT = (('A'..'Z').to_a + ('a'..'z').to_a + (0..9).to_a + ['+/']).join('')

        i      = 0
        prefix = 0
        module_name.each_char do |c|
          n       = (DICT =~ /#{Regexp.escape(c)}/)
          prefix += n*(64**i)
          i      += 1
        end

        puts "Prefix number: #{prefix}"
      end

      desc "Migrate all modules"
      task :modules => :environment do
        # Use File::SEPARATOR to ensure crossplatform
        # Rake::Task["developer:db:migrate"].invoke does not work

        ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
        version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil

        # Module "theme" and "comment" must be migrated first because other modules may
        # depend on their tables
        ActiveRecord::Migrator.migrate("modules/core/theme/db/migrate/",   version)
        ActiveRecord::Migrator.migrate("modules/core/comment/db/migrate/", version)

        Dir.glob("#{Rails.root}/modules/**").each do |path|
          type = path.split(File::SEPARATOR).last
          Dir.glob("#{Rails.root}/modules/#{type}/**").each do |path|
            mod = path.split(File::SEPARATOR).last
            ActiveRecord::Migrator.migrate("modules/#{type}/#{mod}/db/migrate/", version)
          end
        end
      end

      desc  'Rollbacks the database one migration and re migrate up. If you want to rollback more than one step, define STEP=x. Target specific version with VERSION=x.'
      task :redo => [:environment, "developer:db:check_module"] do
        if ENV["VERSION"]
          Rake::Task["developer:db:migrate:down"].invoke
          Rake::Task["developer:db:migrate:up"].invoke
        else
          Rake::Task["developer:db:rollback"].invoke
          Rake::Task["developer:db:migrate"].invoke
        end
      end

      desc 'Runs the "up" for a given migration VERSION.'
      task :up => [:environment, "developer:db:check_module"] do
        version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
        raise "VERSION is required" unless version
        ActiveRecord::Migrator.run(:up, "modules/#{ENV["MODULE"]}/db/migrate/", version)
      end

      desc 'Runs the "down" for a given migration VERSION.'
      task :down => [:environment, "developer:db:check_module"] do
        version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
        raise "VERSION is required" unless version
        ActiveRecord::Migrator.run(:down, "modules/#{ENV["MODULE"]}/db/migrate/", version)
      end
    end

    desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n'
    task :rollback => [:environment, "developer:db:check_module"] do
      step = ENV['STEP'] ? ENV['STEP'].to_i : 1
      ActiveRecord::Migrator.rollback("modules/#{ENV["MODULE"]}/db/migrate/", step)
    end
  end
end
