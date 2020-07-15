import sqlite3 

connection = sqlite3.connect("data.db")

cursor = connection.cursor()

create_table = "CREATE TABLE users (id int, username text, password text)"
cursor.execute(create_table)


user = (1, "asq", "asdf")

users = [
        (2, "yegc", "asdf"),
        (3, "bvcbs", "asdf"),
        (4, "kjlju", "asdf")
        ]

insert_query = "INSERT INTO users VALUES (?, ?, ?)"
cursor.execute(insert_query, user)
cursor.executemany(insert_query, users)

select_query = "SELECT * FROM users"

for row in cursor.execute(select_query):
    print(row)

connection.commit()
connection.close()
