ENV['SINATRA_ENV'] ||= "development"


require 'bundler'
Bundler.require

require 'tty-prompt'
$prompt = TTY::Prompt.new

require 'colorize'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
require_all 'app/models'

 #Added to disable DEBUG level logging (e.g. SQL statements)
 ActiveRecord::Base.logger = nil
