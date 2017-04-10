module MyDbTasks
  module MasterDataTasks
    extend self

    attr_accessor :logger, :db_config

    def dump
      logger.info "Dump master data start."
      logger.debug "  database: #{db_config}"
      dump_tables
      separate_tables
      clear_tmp_files
      logger.info "Dump master data end."
    end

    def create
      logger.info "Create master data start."
      logger.debug "  database: #{db_config}"
      master_table_files.each do |file|
        logger.info "  load #{file}"
        `mysql #{mysql_options} < #{file}`
      end
      logger.info 'Create master data end.'
    end

    def drop
      logger.info "Drop master data start."
      logger.debug "  database: #{db_config}"
      master_table_files.each do |file|
        table_name = File.basename(file, '.sql')
        logger.info "  truncate #{table_name}"
        `mysql #{mysql_options} -e 'truncate table #{table_name}'`
      end
      logger.info "Drop master data end."
    end

    private

    def dump_tables
      logger.info "  create #{tmp_dump_file}"
      `mysqldump #{mysqldump_options} #{mysql_options} #{master_table_names.join(' ')} > #{tmp_dump_file}`
    end

    def separate_tables
      FileUtils.mkdir_p('db/master_data/sql')
      dump = File.read(tmp_dump_file)
      chunks = dump.split(/\n\n/)
      chunks.each do |chunk|
        if m = chunk.match(/INSERT[\sA-Z]+INTO `(.+)`/)
          table_name = m[1]
          sql_file = "db/master_data/sql/#{table_name}.sql"
          logger.info "  create #{sql_file}"
          File.open(sql_file, 'w') do |f|
            f.write(NKF.nkf('-e', chunk))
          end
        end
      end
    end

    def mysqldump_options
      %w(
        --skip-comments
        --no-create-info
        --skip-extended-insert
        --insert-ignore
        --skip-tz-utc
      ).join(' ')
    end

    def mysql_options
      [
        "-u #{db_config['username']}",
        "#{db_config['password'] ? "-p #{db_config['password']}" : ''}",
        "-h #{db_config['host']}",
        "-P #{db_config['port']}",
        db_config['database'],
      ].join(' ')
    end

    def all_table_names
      @all_table_names ||= `mysql #{mysql_options} -e 'show tables' -N -B`.split("\n")
    end

    def master_table_names
      @master_table_names ||= all_table_names.grep(/\A(?:マスターっぽいテーブル)/)
    end

    def tmp_dump_file
      @tmp_dump_file ||= Time.now.strftime('/tmp/mysql_dump_%Y%m%d%H%M%S.sql')
    end

    def clear_tmp_files
      logger.info "  delete #{tmp_dump_file}"
      File.delete(tmp_dump_file)
    end

    def master_table_files
      [
        # 生成したマスターデータファイル
      ].flatten
    end
  end
end
