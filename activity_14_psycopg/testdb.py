import psycopg2

params = {
    'host': 'localhost', 
    'port': 5432, 
    'dbname': 'hr', 
    'user': 'hr_admin',
    'password': '135791'
}

conn = psycopg2.connect(**params)
if conn: 
    print('Connection to Postgres database ' + params['dbname'] + ' was successful!')

    print('Bye!')
    conn.close()