module MyDbTasks
  class SeedLoader
    def initialize(db_config)
      @db_config = db_config
      @logger = Logger.new(STDOUT)
      @logger.info "database: #{@db_config}"
    end

    def load_seed
      @logger.info 'Load seed data start.'
      # ここでシードデータをロードする
      @logger.info 'Load seed data end.'
    end
  end
end
