require 'sinatra'
require 'slim'
require 'sinatra/reloader'
require 'sqlite3'

get('/') do
    slim(:start)
end

get('/sjukdomar') do
    db = SQLite3::Database.new("db/sjukdomar.db")
    db.results_as_hash = true
    result = db.execute('SELECT * FROM sjukdomar')
    slim(:"sjukdomar/index",locals:{sjukdomar:result})
end

