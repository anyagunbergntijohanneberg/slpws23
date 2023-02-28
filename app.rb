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

get('/sjukdomar/new') do
    slim(:"sjukdomar/new")
end

post('/sjukdomar/new') do
    Namn = params[:Namn]
    Sjuk_id = params[:Sjuk_id].to_i
    p "Vi fick in datan #{Namn} och #{Sjuk_id}"
    db = SQLite3::Database.new("db/sjukdomar.db")
    db.execute("INSERT INTO sjukdomar (Namn, Sjuk_id) VALUES (?,?)",Namn, Sjuk_id)
    redirect('/sjukdomar')
end

get('/sjukdomar/:id') do
    id = params[:id].to_i
    db = SQLite3::Database.new("db/sjukdomar.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM sjukdomar WHERE Sjuk_id = ?",id).first
    slim(:"sjukdomar/show",locals:{result:result})
end

