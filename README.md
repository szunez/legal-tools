# A Docker LAMP server and Excel tool
The server uses php/mysql/apache in Docker

The spreadsheet includes a VBA macros for data processing from Harris County District Court records.  

NOTE: This workflow was designed for Criminal offense tracking. The format for Civil cases is different regarding the number of data points.

# starting
Run `docker-compose up` to bring your LAMP stack online

# connecting to MySQL
You can connect to MySQL from an external tool by using ip and port `0.0.0.0:3306` with user "root" and password "root".
If you want to connect from within your php script use `db` as your hostname instead of the usual `localhost`.

# where to place files
You can place your files and folders anywhere in the public folder.

# how to access your projects
Access projects by browsing to http://localhost:8000 and it will use your public folder as the default location