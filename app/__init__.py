from flask import Flask
from flask.ext.cors import CORS


app = Flask(__name__)
app.secret_key = 'thisisthesecretkeyforanoncaresystem'
CORS(app)


from app import views