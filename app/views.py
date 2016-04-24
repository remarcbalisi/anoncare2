# !flask/bin/python
import os
from flask import Flask, jsonify, request
from os import sys
from models import DBconn
import json, flask
from app import app
import hashlib, uuid
import re
from werkzeug.security import generate_password_hash



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
                # new user is verified unique and has a valid mail. User can be store

                #hash password using "Salted Passwords" source: http://flask.pocoo.org/snippets/54/
                pw_hash = generate_password_hash(password)

                store_user = spcall('store_user', (fname, mname, lname, username, pw_hash, email, role_id), True )

                if store_user[0][0] == 'OK':
                    return jsonify({'status':'OK', 'message':'Successfully add ' + str(fname)})

                elif store_user[0][0] == 'Error':
                    return jsonify({'status':'failed', 'message':'failed to add ' + str(fname)})

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