require 'sinatra'
require 'slim'
require 'sinatra/reloader'
require 'sqlite3'
require 'BCrypt'

enable :sessions



get('/') do 
    slim(:start)
end

get('/error') do
    slim(:error)
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

get('/register') do
    slim(:register)
end

post('/users/new') do
    username = params[:username]
    password = params[:password]
    password_confirmation = params[:password_confirmation]

    if (password == password_confirmation)
        #lägg till användare
        password_digest = BCrypt::Password.create(password)
        db = SQLite3::Database.new('db/sjukdomar.db')
        db.execute("INSERT INTO Users (username,pwdigest) VALUES (?,?)", username,password_digest)
        redirect('/')
    else 
    
        #Felhantering
        "Lösenorden matchar ej!"
    
    end
end

get('/sjukdomar/:id') do
    id = params[:id].to_i
    db = SQLite3::Database.new("db/sjukdomar.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM sjukdomar WHERE Sjuk_id = ?",id).first
    slim(:"sjukdomar/show",locals:{result:result})
end

get('/login') do
    slim(:login)
end

post('/login') do
    username = params[:username]
    password = params[:password]
    db = SQLite3::Database.new('db/sjukdomar.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM users WHERE username = ?",username).first
    pwdigest = result["pwdigest"]
    id = result["id"]

    if BCrypt::Password.new(pwdigest) == password
        redirect('/')
    else
        "FEL LÖSEN!"
    end
end