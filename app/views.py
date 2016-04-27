#!flask/bin/python
import os
from os import sys
from flask import Flask, jsonify, request
from models import DBconn
import json, flask
from app import app


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


@app.route('/anoncare.api/patient/', methods=['POST'])
def newpatient():
    data = json.loads(request.data)
    response = spcall('newpatient', (
        data['id'],
        data['fname'],
        data['mname'],
        data['lname'],
        data['age'],
        data['sex'],
        data['department_id'],
        data['patient_type_id'],
        data['height'],
        data['weight'],
        data['date_of_birth'],
        data['civil_status'],
        data['name_of_guardian'],
        data['home_address'],
        data['smoking'],
        data['allergies'],
        data['alcohol'],
        data['medication_taken'],
        data['drugs'], 
        data['cough'],
        data['dyspnea'],
        data['hemoptysis'],
        data['tb_exposure'],
        data['frequency'],
        data['flank_plan'],
        data['discharge'],
        data['dysuria'],
        data['nocturia'],
        data['dec_urine_amount'],
        data['asthma'],
        data['ptb'],
        data['heart_problem'],
        data['hepatitis_a_b'],
        data['chicken_pox'],
        data['mumps'],
        data['typhoid_fever'],
        data['chest_pain'],
        data['palpitations'],
        data['pedal_edema'],
        data['orthopnea'],
        data['nocturnal_dyspnea'],
        data['headache'],
        data['seizure'],
        data['dizziness'],
        data['loss_of_consciousness'],
        data['is_active']))
    if 'Error' in str(response[0][0]):
        return jsonify({'status': 'error', 'message': response[0][0]})

    return jsonify({'status': 'OK', 'message': response[0][0]}), 200

@app.route('/anoncare.api/patient/<id>/', methods=['GET'])
def getpatient_file(id):
    response = spcall('show_patient', [id])
    entries = []
    if len(response) == 0:
        return jsonify({"status": "OK", "message": "No patient file found", "entries": [], "count": "0"})
    else:
        row = response[0]
        entries.append({"id": id,
                        "fname": row[0],
                        "mname": row[1],
                        "lname": row[2],
                        "age": row[3],
                        "sex": row[4],
                        "department": row[5],
                        "patient_type": row[6],
                        "height": row[7],
                        "weight": row[8],
                        "date_of_birth": row[9],
                        "civil_status": row[10],
                        "name_of_guardian": row[11],
                        "home_address": row[12],
                        "smoking": row[13],
                        "allergies": row[14],
                        "alcohol": row[15],
                        "medication_taken": row[16],
                        "drugs": row[17],
                        "cough": row[18],
                        "dyspnea": row[19],
                        "hemoptysis": row[20],
                        "tb_exposure": row[21],
                        "frequency": row[22],
                        "flank_plan": row[23],
                        "discharge": row[24],
                        "dysuria": row[25],
                        "nocturia": row[26],
                        "dec_urine_amount": row[27],
                        "asthma": row[28],
                        "ptb": row[29],
                        "heart_problem": row[30],
                        "hepatitis_a_b": row[31],
                        "chicken_pox": row[32],
                        "mumps": row[33],
                        "typhoid_fever": row[34],
                        "chest_pain": row[35],
                        "palpitations": row[36],
                        "pedal_edema": row[37],
                        "orthopnea": row[38],
                        "nocturnal_dyspnea": row[39],
                        "headache": row[40],
                        "seizure": row[41],
                        "dizziness": row[42],
                        "loss_of_consciousness": row[43],
                        "is_active": row[44]
                        })
        return jsonify({'status': 'OK', 'message': 'OK', 'entries': entries, 'count': len(entries)})


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