username = params ["username"]
password = params ["password"]
password_confirmation = params ["confirm_password"]

result = db.execute("SELECT id FROM users WHERE username=?", username)
