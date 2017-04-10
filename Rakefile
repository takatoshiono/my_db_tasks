require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "yaml"
require "active_record"
require "my_db_tasks/seed_loader"
require "my_db_tasks/master_data_tasks"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

env = ENV['ENV'] || 'development'
db_config = YAML.load(ERB.new(File.read('config/database.yml')).result)

task :environment do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  ActiveRecord::Base.schema_format = :sql
  ActiveRecord::Base.establish_connection(db_config[env])
  ActiveRecord::Tasks::DatabaseTasks.seed_loader = MyDbTasks::SeedLoader.new(db_config[env])
end

namespace :db do
  task :load_config do
    ActiveRecord::Tasks::DatabaseTasks.env = env

    ActiveRecord::Tasks::DatabaseTasks.db_dir = 'db'
    ActiveRecord::Tasks::DatabaseTasks.database_configuration = db_config
    ActiveRecord::Tasks::DatabaseTasks.migrations_paths = ['db/migrate']
    ActiveRecord::Tasks::DatabaseTasks.root = Pathname.new(Dir.pwd)

    if env != 'development'
      ActiveRecord::Base.dump_schema_after_migration = false
    end
  end

  namespace :structure do
    desc "Remove AUTO_INCREMENT table option from the db/structure.sql file"
    task :remove_auto_increment_table_option do
      ActiveRecord::Base.logger.debug "Remove AUTO_INCREMENT table option from the db/structure.sql file"
      structure = File.read('./db/structure.sql').gsub(/\sAUTO_INCREMENT=\d+/, '')
      File.open('./db/structure.sql', 'w') do |f|
        f.write(structure)
      end
    end
  end
end

load "active_record/railties/databases.rake"

Rake::Task['db:structure:dump'].enhance do
  Rake::Task['db:structure:remove_auto_increment_table_option'].invoke
end

namespace :my_db_tasks do
  namespace :master_data do
    task :load_config do
      MyDbTasks::MasterDataTasks.logger = Logger.new(STDOUT)
      MyDbTasks::MasterDataTasks.db_config = db_config[env]
    end

    desc "Create master data sql files in db/master_data/sql directory"
    task :dump => [:load_config] do
      MyDbTasks::MasterDataTasks.dump
    end

    desc "Creates master data"
    task :create => [:load_config] do
      MyDbTasks::MasterDataTasks.create
    end

    desc "Drops master data"
    task :drop => [:load_config] do
      MyDbTasks::MasterDataTasks.drop
    end

    task :reset => ['my_db_tasks:master_data:drop', 'my_db_tasks:master_data:create']
  end
end
