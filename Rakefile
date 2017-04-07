require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "yaml"
require "active_record"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

env = ENV['ENV'] || 'development'
db_config = YAML.load(ERB.new(File.read('config/database.yml')).result)

task :environment do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  ActiveRecord::Base.schema_format = :sql
  ActiveRecord::Base.establish_connection(db_config[env])
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
end

load "active_record/railties/databases.rake"
