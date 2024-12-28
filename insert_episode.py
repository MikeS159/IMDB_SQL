import psycopg2

# Connect to the database
conn = psycopg2.connect(
    host="localhost",
    port=5432,
    user="postgres",
    password="",
    database="postgres"
)

# Create a cursor
cursor = conn.cursor()

insCnt = 0

# Open the tab-separated file
with open("title.episode.tsv", "r") as f:
    # Read the file line by line
    next(f)
    for line in f:
        # Split the line into a list of values
        values = line.split("\t")
        # Insert the values into the database
        cursor.execute("INSERT INTO \"Stats\".title_episode (tconst, parenttconst, seasonnumber, episodenumber) VALUES(%s, %s, %s, %s)", values)
        # Commit the transaction
        #conn.commit()
        insCnt += 1
        if insCnt % 10000 == 0:
            conn.commit()
            print(insCnt)

# Close the cursor and connection
conn.commit()
cursor.close()
conn.close()
print("Done - ")
print(insCnt)
