module DataSource where

import Database.HDBC.PostgreSQL (connectPostgreSQL, Connection)

connect :: IO Connection
connect = connectPostgreSQL "host=localhost dbname=hrr-sample user=hrr-sample password=hrr-sample port=5432"
