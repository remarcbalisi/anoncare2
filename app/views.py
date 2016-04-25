# !flask/bin/python
import os
from flask import Flask, jsonify, request, session, redirect, url_for
from os import sys
from models import DBconn
import json, flask
from app import app
import re
from werkzeug.security import generate_password_hash
from functools import wraps
import hashlib



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


def login_required(test):
    @wraps(test)
    def wrap(*args, **kwargs):
        if 'logged_in' in session:
            return test(*args, **kwargs)

        else:
            return redirect(url_for('login') )

    return wrap


@app.route('/api/anoncare/logout')
def logout():
    session.pop('logged_in', None)
    return redirect(url_for('index') )


@app.route('/api/anoncare/login', methods=['POST', 'GET'])
def login():

    try:

        if session['logged_in']:
            return redirect(url_for('home') )

    except:

        if request.method == 'POST':
            credentials = json.loads(request.data)
            username = credentials['username']
            password = credentials['password']
            pw_hash = hashlib.md5(password.encode())

            check_credentials = spcall('check_credentials', (username, pw_hash.hexdigest() ))
            #if failed it will return 'FAILED' and if not return 'OK'

            if check_credentials[0][0] == 'failed':
                return jsonify({'status':'failed', 'message':'Invalid credentials please try again'})

            else:
                session['logged_in'] = True
                return redirect(url_for('home') )

        return jsonify({'status':'guest'})


@app.route('/api/anoncare/index')
def index():
    return jsonify({'status':'guest'})


@app.route('/api/anoncare/home')
@login_required
def home():
    return jsonify({'status':'check'})


@app.route('/api/anoncare/user', methods=['POST'])
def store_user():

    data = json.loads(request.data)
    username = data['username']
    email = data['email']

    check_username_exist = spcall('check_username', (username,) )
    check_email_exist = spcall('check_mail', (email,) )

    if check_username_exist[0][0] == 'OK' and check_email_exist[0][0] == 'OK':

        check_mail = re.match('^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$', email)

        if check_mail:
            fname = data['fname']
            mname = data['mname']
            lname = data['lname']
            password = data['password']
            role_id = data['role_id']

            if fname != '' and mname != '' and lname != '' and username != '' and password != '' and role_id != '':
                """
                PASSWORD HASHING
                source: https://pythonprogramming.net/password-hashing-flask-tutorial/

                import hashlib
                password = 'pa$$w0rd'
                h = hashlib.md5(password.encode())
                print(h.hexdigest())

                """
                pw_hash = hashlib.md5(password.encode())

                store_user = spcall('store_user', (fname, mname, lname, username, pw_hash.hexdigest(), email, role_id), True )

                if store_user[0][0] == 'OK':
                    return jsonify({'status':'OK', 'message':'Successfully add ' + str(fname)})

                elif store_user[0][0] == 'Error':
                    return jsonify({'status':'failed', 'message':'failed to add ' + str(fname)})

                else:
                    return jsonify({'ERROR':'404'})

            else:
                return jsonify({'status':'failed', 'message':'Please input required fields!'})

        else:
            return jsonify({'status':'failed', 'message':'Invalid email input!'})

    elif check_username_exist[0][0] == 'EXISTED':
        return jsonify({'status ':'failed', 'message':'username already exist'})

    elif check_email_exist[0][0] == 'EXISTED':
        return jsonify({'status ':'failed', 'message':'email already exist'})

    else:
        return jsonify({'failed':'failed'})


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