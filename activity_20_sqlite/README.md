# Instructions

This activity illustrates how to setup a database using SQLite. 

## Database Script

Save the following SQL script named **pls.sql**. 

```
CREATE TABLE pls (
    id INT PRIMARY KEY, 
    name VARCHAR(50) NOT NULL
);

INSERT INTO pls VALUES 
    (1, 'Python'), 
    (2, 'Java'), 
    (3, 'SQL');
```

## Database Setup

Create a new virtual environment and write the following python script named **dbsetup.py**. 

```
import sqlite3

conn = sqlite3.connect('pls.db')
with open('pls.sql') as f:
    conn.executescript(f.read())
conn.commit()
print('done!')
```

After the script runs, a new file named **pls.db** is created. That file is your SQLite database!

## Database Query

Write the following python script named **testdb.py**: 

```
import sqlite3

conn = sqlite3.connect('pls.db')
cur = conn.cursor()
sql = 'SELECT * FROM pls'
cur.execute(sql)
for row in cur.fetchall():
    print(row)
conn.close()
```

