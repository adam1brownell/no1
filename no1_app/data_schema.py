import sqlite3
import subprocess
import os

# Directory containing the SQLite databases
db_dir = "/lib/db/tables/"

# Function to extract table schema from an SQLite database
def extract_table_schema(db_file):
    try:
        # Connect to the SQLite database
        conn = sqlite3.connect(db_file)
        cursor = conn.cursor()

        # Get the list of all tables in the database
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = cursor.fetchall()

        schema_output = []
        
        for table_name in tables:
            table_name = table_name[0]  # Unpack tuple
            
            # Get the schema for the current table
            cursor.execute(f"PRAGMA table_info({table_name});")
            columns = cursor.fetchall()

            # Format the schema output for the table
            schema = f"Table: {table_name}\n"
            for column in columns:
                column_name = column[1]
                column_type = column[2]
                schema += f"   - {column_name} ({column_type})\n"
            
            schema_output.append(schema)
        
        # Close the connection to the database
        conn.close()

        return "\n".join(schema_output)
    
    except sqlite3.Error as e:
        return f"Error reading {db_file}: {e}"

# Main function to check files in the directory and process SQLite files
def check_db_files(directory):
    schema_output = []

    # Loop through each file in the directory
    for filename in os.listdir(os.getcwd()+directory):
        if filename.endswith(".db"):  # Looking for .db files (SQLite databases)
            db_file_path = os.path.join(directory, filename)
            # Check if the file exists
            if not os.path.exists(db_file_path):
                print(f"File {db_file_path} does not exist.")
            else:
                print(f"File {db_file_path} exists.")
            if not os.access(db_file_path, os.R_OK):
                print(f"Cannot read the file: {db_file_path}")
                # subprocess.run(["chmod", "644", db_file_path], check=True)
                continue
            else:
                print(f"Can access: {db_file_path}")
            print(f"Reading schema for {filename}...")
            table_schema = extract_table_schema(db_file_path)
            if table_schema:
                schema_output.append(f"Schema for {filename}:\n{table_schema}")

    return "\n\n".join(schema_output)

def output_data(db_file_path):
    conn = sqlite3.connect(db_file_path)
    cursor = conn.cursor()

    # Fetch all table names
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cursor.fetchall()

    # Print the table name and its columns
    output = []
    for table in tables:
        table_name = table[0]
        if 'adam' in table_name:
            continue
        print(f"***{table_name}***")
        output.append(f"Table: {table_name}\n")

        # Fetch the schema for the table
        cursor.execute(f"PRAGMA table_info({table_name});")
        schema = cursor.fetchall()

        # Print each column under the table
        for column in schema:
            print(f"\t**{column[1]} ({column[2]})")

    # Close the connection
    conn.close()
    
# Check the DB files in /lib/db/tables/ and output schema
if __name__ == "__main__":
    for i in ['garmin','oura']:
        db_file_path = os.path.abspath(f"lib/db/tables/{i}.db")
        print(f"{i}: [[")
        output_data(db_file_path)
        print("]]")
    