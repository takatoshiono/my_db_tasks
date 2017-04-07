require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/string/strip'

module MyDbTasks
  class MigrationGenerator
    def initialize(migration_name)
      @migration_name = migration_name
    end

    def create_migration_file
      template = migration_template
      puts ['create', migration_file_path].join("\t")

      File.open(migration_file_path, 'w') do |f|
        f.write(template)
      end
    end

    private

    def migration_template
      <<-TEMPLATE.strip_heredoc
        class #{class_name} < ActiveRecord::Migration
          def up
            execute <<-SQL
            SQL
          end

          def down
            execute <<-SQL
            SQL
          end
        end
      TEMPLATE
    end

    def migration_file_path
      File.join('db', 'migrate', migration_file_name)
    end

    def migration_file_name
      "#{version}_#{file_name}.rb"
    end

    def file_name
      @migration_name.underscore
    end

    def class_name
      file_name.camelcase
    end

    def version
      Time.now.strftime('%Y%m%d%H%M%S')
    end
  end
end
