ActiveRecord::Base.connection.execute('CREATE TABLE users ("id" INTEGER PRIMARY KEY NOT NULL, "name" varchar(255) NOT NULL)')

class User < ActiveRecord::Base
  validates :name, :absence => true
end
