CREATE TABLE College (
  id           SERIAL8 PRIMARY KEY,
  college_name TEXT NOT NULL,
  is_active    BOOLEAN DEFAULT TRUE
);

CREATE TABLE Department (
  id              SERIAL8 PRIMARY KEY,
  department_name TEXT NOT NULL,
  college_id      INT REFERENCES College (id),
  is_active       BOOLEAN DEFAULT TRUE
);


CREATE TABLE Patient_type (
  school_id   SERIAL8 PRIMARY KEY,
  type TEXT
);


CREATE TABLE Personal_info (
  school_id        SERIAL8 PRIMARY KEY,
  fname            TEXT,
  mname            TEXT,
  lname            TEXT,
  age              INT,
  sex_id           TEXT,
  department_id    INT REFERENCES Department (id),
  patient_type_id  INT REFERENCES Patient_type (school_id),
  height           TEXT,
  weight           FLOAT,
  date_of_birth    DATE,
  civil_status     TEXT,  
  name_of_guardian TEXT,
  home_address     TEXT
);

CREATE TABLE Personal_history (
  school_id        SERIAL8 PRIMARY KEY,
  smoking          TEXT,
  allergies        TEXT,
  alcohol          TEXT,
  medication_taken TEXT,
  drugs            TEXT
);


CREATE TABLE Pulmonary (
  school_id   SERIAL8 PRIMARY KEY,
  cough       TEXT,
  dyspnea     TEXT,
  hemoptysis  TEXT,
  tb_exposure TEXT
);

CREATE TABLE Gut (
  school_id        SERIAL8 PRIMARY KEY,
  frequency        TEXT,
  flank_plan       TEXT,
  discharge        TEXT,
  dysuria          TEXT,
  nocturia         TEXT,
  dec_urine_amount TEXT
);

CREATE TABLE Illness (
  school_id     SERIAL8 PRIMARY KEY,
  asthma        TEXT,
  ptb           TEXT,
  heart_problem TEXT,
  hepatitis_a_b TEXT,
  chicken_pox   TEXT,
  mumps         TEXT,
  typhoid_fever TEXT
);

CREATE TABLE Cardiac (
  school_id         SERIAL8 PRIMARY KEY,
  chest_pain        TEXT,
  palpitations      TEXT,
  pedal_edema       TEXT,
  orthopnea         TEXT,
  nocturnal_dyspnea TEXT
);

CREATE TABLE Neurologic (
  school_id             SERIAL8 UNIQUE PRIMARY KEY,
  headache              TEXT,
  seizure               TEXT,
  dizziness             TEXT,
  loss_of_consciousness TEXT
);

CREATE TABLE Patient (
  school_id        SERIAL8 PRIMARY KEY,
  personal_info_id INT REFERENCES Personal_info (school_id),
  personal_history_id INT REFERENCES Personal_history(school_id),
  pulmonary_id     INT REFERENCES Pulmonary (school_id),
  gut_id           INT REFERENCES Gut (school_id),
  illness_id       INT REFERENCES Illness (school_id),
  cardiac_id       INT REFERENCES Cardiac (school_id),
  neurologic_id    INT REFERENCES Neurologic (school_id),
  is_active        BOOLEAN DEFAULT TRUE
);

INSERT INTO Sex VALUES(1, 'Male');
INSERT INTO Sex VALUES(2, 'Female');

INSERT INTO Civil_status VALUES(1, 'Single');
INSERT INTO Civil_status VALUES(2, 'Married');
INSERT INTO Civil_status VALUES(3, 'Divorced');
INSERT INTO Civil_status VALUES(4, 'Widow');

INSERT INTO College VALUES (1, 'SCS');
INSERT INTO College VALUES (2, 'COE');
INSERT INTO College VALUES (3, 'CED');
INSERT INTO College VALUES (4, 'CASS');
INSERT INTO College VALUES (5, 'SET');
INSERT INTO College VALUES (6, 'CBAA');
INSERT INTO College VALUES (7, 'CON');
INSERT INTO College VALUES (8, 'CSM');

INSERT INTO Patient_type VALUES (1, 'Student');
INSERT INTO Patient_type VALUES (2, 'Faculty');
INSERT INTO Patient_type VALUES (3, 'Staff');
INSERT INTO Patient_type VALUES (4, 'Outpatient Department');

INSERT INTO Department VALUES (1, 'Computer Science', 1);


