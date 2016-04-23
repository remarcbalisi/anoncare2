# !flask/bin/python
import os
from os import sys
from flask import Flask, jsonify, render_template, request, session, redirect
from functools import wraps
# from flask.ext.httpauth import HTTPBasicAuth
from os import sys
from models import DBconn
import json, flask
from app import app
import re
import hashlib, uuid



def spcall(qry, param, commit=False):
    try:
        dbo = DBconn()
        cursor = dbo.getcursor()
        cursor.callproc(qry, param)
        res = cursor.fetchall()
        if commit:
            dbo.dbcommit()
        return res
    except:
        res = [("Error: " + str(sys.exc_info()[0]) + " " + str(sys.exc_info()[1]),)]
    return res


@app.route('/', methods=['GET'])
def index():
	return jsonify({'hello':'hello world!'})


@app.after_request
def add_cors(resp):
    resp.headers['Access-Control-Allow-Origin'] = flask.request.headers.get('Origin', '*')
    resp.headers['Access-Control-Allow-Credentials'] = True
    resp.headers['Access-Control-Allow-Methods'] = 'POST, OPTIONS, GET, PUT, DELETE'
    resp.headers['Access-Control-Allow-Headers'] = flask.request.headers.get('Access-Control-Request-Headers',
                                                                             'Authorization')
    # set low for debugging
    if app.debug:
        resp.headers["Access-Control-Max-Age"] = '1'
    return resp



def user_exists(username):
    users = spcall('getuserinfo', ())
    index = 0
    count = 0

    for user in users:
        if username == users[index][4]:
            count += 1

        index += 1

    if count == 1:
        return True
    else:
        return False


@app.route('/anoncare.api/users/<int:id>/', methods=['GET'])
def get_user_with_id(id):
    res = spcall("getuserinfoid", (id,), True)
    entries = []

    print "res is ", len(res)

    if len(res) != 0:
        row = res[0]
        entries.append({
            "fname": row[0],
            "mname": row[1],
            "lname": row[2],
            "email": row[3],
            "username": row[4]})

        print "username is ", res[0][4]

        return jsonify({"status": "OK", "message": "OK", "entries": entries})

    else:
        return jsonify({"status": "OK", "message": "No User Found"})


def register_field_empty(fname, mname, lname, email):
    if fname == '':
        return True
    if mname =='':
        return True
    if lname == '':
        return True
    if email == '':
        return True
    else:
        return False


def invalid_email(email):
    match = re.match('^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$', email)

    if match == None:
        return True

    else:
        return False


def hash_password(password):
    salt = uuid.uuid4().hex
    hashed = hashlib.sha256(salt.encode() + password.encode()).hexdigest() + ':' + salt
    return hashed
    # return hashlib.sha256(salt.enode() + password.encode()).hexdigest() + ':' + salt


@app.route('/anoncare.api/user/', methods=['POST'])
def insertuser():
    user = json.loads(request.data)

    print "user is ", user

    fname = user['fname']
    mname = user['mname']
    lname = user['lname']
    email = user['email']
    username = user['username']
    password = user['password']
    role_id = user['role_id']
    is_available = user['is_available']

    if register_field_empty(str(fname), str(mname), str(lname), str(email)):
        return jsonify({'message': 'Empty Field'})

    elif invalid_email(email):
        return jsonify({'email': 'Invalid!'})

    elif user_exists(username):
        return jsonify({'status': 'error'})
    else:
        # hashed_password = hashlib.md5(password)
        # saved_password = hashed_password.hexdigest()
        # password = str(password)
        saved_password = hash_password(password)
        spcall("newuserinfo", (fname, mname, lname, email, username, saved_password, role_id, is_available), True)
        return jsonify({'status': 'OK'})


@app.route('/anoncare.api/password_reset/', methods=['PUT'])
def password_reset():
    id = 3
    input_password = json.loads(request.data)
    new_password = input_password['password']
    spcall("updatepassword", (id, new_password,), True)

    return jsonify({"status": "Password Changed"})
