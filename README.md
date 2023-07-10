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
`flask --app my_spots.api.flask_app --debug run`

To connect to the postgresql db using psql:
`sudo -u postgres psql my_spots`

To run ngrok and host your localhost:
`ngrok http 5000`

## Frontend

run `dart fix` to fix all warning and issues

### Release
run `flutter build appbundle` on frontend directory to create an android app bundle

### Generating keyfile

password: awesome

What is your first and last name?
  [Suleman]:  Suleman Mahmood
What is the name of your organizational unit?
  [MySpots]:  MySpots
What is the name of your organization?
  [MySpots]:  MySpots
What is the name of your City or Locality?
  [Lahore]:  San Francisco
What is the name of your State or Province?
  [Punjab]:  California
What is the two-letter country code for this unit?
  [PK]:  US
Is CN=Suleman Mahmood, OU=MySpots, O=MySpots, L=San Francisco, ST=California, C=US correct?
  [no]:  yes

Generating 2,048 bit RSA key pair and self-signed certificate (SHA256withRSA) with a validity of 10,000 days
        for: CN=Suleman Mahmood, OU=MySpots, O=MySpots, L=San Francisco, ST=California, C=US
[Storing /home/suleman/upload-keystore.jks]
