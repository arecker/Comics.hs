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
	CREATE TABLE comics(id Integer UNIQUE, created, title, link)
	"""
)

test_data = [
	('Mitochondrial Eve', 'http://www.explosm.net/db/files/Comics/Dave/EVE.png'),
	('Golden Shower', 'http://www.explosm.net/db/files/Comics/Dave/shower.png'),
	('Dad, I keep having nightmares', 'http://www.explosm.net/db/files/Comics/Dave/comicggg1.png')
]

i = 1
for title, link in test_data:
	c.execute("INSERT INTO comics select '%i', CURRENT_DATE, '%s', '%s'" % (i, title, link))
	i = i + 1

conn.commit()
conn.close()