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
with open("title.ratings.tsv", "r") as f:
    # Read the file line by line
    next(f)
    for line in f:
        # Split the line into a list of values
        values = line.split("\t")
        newVals = []
        newVals.append(values[0])
        newVals.append(float(values[1]))
        newVals.append(int(values[2]))
        # Insert the values into the database
        cursor.execute("INSERT INTO \"Stats\".title_ratings (tconst, averagerating, numvotes) VALUES(%s, %s, %s)", newVals)
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
