import sqlite3
import os

"""
Drops sqlite database, re creates the schema,
and inserts test data
"""

if os.path.exists('comics.db'):
	os.remove('comics.db')

conn = sqlite3.connect('comics.db')
c = conn.cursor()

c.execute(
	"""
	CREATE TABLE comics(DATETIME created, title, url)
	"""
)

test_data = [
	('Mitochondrial Eve', 'http://www.explosm.net/db/files/Comics/Dave/EVE.png'),
	('Golden Shower', 'http://www.explosm.net/db/files/Comics/Dave/shower.png'),
	('Dad, I keep having nightmares', 'http://www.explosm.net/db/files/Comics/Dave/comicggg1.png')
]

for title, link in test_data:
	c.execute("INSERT INTO comics select CURRENT_TIMESTAMP, '%s', '%s'" % (title, link))

conn.commit()
conn.close()