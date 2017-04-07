class CreateUsers < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE users(
        id int not null auto_increment,
        name varchar(255) not null,
        primary key (id)
      ) ENGINE=InnoDB
    SQL
  end

  def down
    execute <<-SQL
      DROP TABLE users
    SQL
  end
end
