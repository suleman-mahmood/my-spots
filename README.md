# MySpots

## Backend

### Virtual environment

To setup the virtual environment
`python -m venv venv`

To activate the python virtual env:
`source venv/bin/activate`

To disable the venv:
`deactivate`

### Installing dependencies

To install packages from requirements.txt:
`pip install -r requirements.txt`

### Deployment

To deploy the app to gcloud:
`gcloud app deploy`

### Development

To run the flask server locally:
`flask --app flask_app --debug run`

To connect to the postgresql db using psql:
`sudo -u postgres psql my_spots`

To run ngrok and host your localhost:
`ngrok http 5000`

## Frontend
