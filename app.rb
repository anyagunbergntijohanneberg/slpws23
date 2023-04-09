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
    slim(:"/sjukdomar/new")
end

post('/sjukdomar/new') do
    Namn = params[:Namn]
    p "Vi fick in datan #{Namn}"
    db = SQLite3::Database.new("db/sjukdomar.db")
    db.execute("INSERT INTO sjukdomar (Namn) VALUES (?)",Namn)
    redirect('/sjukdomar')
end

get('/login') do
    slim(:"/login")
end

post('/login') do
    
end

get('/login') do
    slim(:"/register")
end

get('/sjukdomar/:id') do
    id = params[:id].to_i
    db = SQLite3::Database.new("db/sjukdomar.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM sjukdomar WHERE Sjuk_id = ?",id).first
    slim(:"sjukdomar/show",locals:{result:result})
end

