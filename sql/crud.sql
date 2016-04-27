CREATE OR REPLACE FUNCTION store_patient(par_schoolId           INT, par_fname TEXT, par_mname  TEXT, par_lname TEXT, par_age INT, 
                                      par_sex                   TEXT, par_department_id          INT, par_patient_type_id INT, par_height TEXT, par_weight          FLOAT, 
                                      par_date_of_birth         DATE, par_civil_status          TEXT, par_name_of_guardian TEXT, par_home_address TEXT, par_smoking TEXT,
                                      par_allergies             TEXT, par_alcohol               TEXT, par_medicationstaken TEXT, par_drugs        TEXT, par_cough   TEXT, 
                                      par_dyspnea               TEXT, par_hemoptysis            TEXT, par_tb_exposure TEXT, par_frequency TEXT, par_flank_plan      TEXT, 
                                      par_discharge             TEXT, par_dysuria               TEXT, par_nocturia TEXT, par_dec_urine_amount TEXT,  par_asthma     TEXT, 
                                      par_ptb                   TEXT, par_heart_problem         TEXT, par_hepatitis_a_b TEXT, par_chicken_pox TEXT,  par_mumps      TEXT,
                                      par_typhoid_fever         TEXT, par_chest_pain            TEXT, par_palpitations TEXT, par_pedal_edema TEXT,  par_orthopnea   TEXT,
                                      par_nocturnal_dyspnea     TEXT, par_headache              TEXT, par_seizure TEXT, par_dizziness TEXT, par_loss_of_consciousness TEXT,
                                      par_is_active BOOLEAN) RETURNS TEXT AS
$$
DECLARE
  loc_fname TEXT;
  loc_mname TEXT;
  loc_lname TEXT;
  loc_res   TEXT;
  loc_id   INT;

BEGIN

  SELECT INTO loc_id school_id
  FROM Personal_info
  WHERE school_id = par_schoolId;
  
  SELECT INTO loc_fname fname
  FROM Personal_info
  WHERE fname = par_fname AND mname = par_mname AND lname = par_lname;
  IF par_schoolId ISNULL OR par_fname = '' OR par_mname = '' OR par_lname = '' OR par_age ISNULL OR par_sex = '' OR
     par_department_id ISNULL OR par_patient_type_id ISNULL OR par_height = '' OR par_weight ISNULL OR par_date_of_birth ISNULL OR
     par_civil_status = '' OR  par_name_of_guardian = '' OR par_home_address = '' OR par_smoking = '' OR par_allergies = '' OR
     par_alcohol = '' OR par_medicationstaken = '' OR par_drugs = '' OR par_cough = '' OR par_dyspnea = '' OR par_hemoptysis = '' OR
     par_tb_exposure = '' OR par_frequency = '' OR par_flank_plan = '' OR par_discharge = '' OR par_dysuria = '' OR
     par_nocturia = '' OR par_dec_urine_amount = '' OR par_asthma = '' OR par_ptb = '' OR par_heart_problem = '' OR
     par_hepatitis_a_b = '' OR par_chicken_pox = '' OR par_mumps = '' OR par_typhoid_fever = '' OR par_chest_pain = '' OR
     par_palpitations = '' OR par_pedal_edema = '' OR par_orthopnea = '' OR par_nocturnal_dyspnea = '' OR par_headache = '' OR
     par_seizure = '' OR par_dizziness = '' OR par_loss_of_consciousness = ''
  THEN
    loc_res = 'Please fill up the required data';
  ELSIF
    loc_fname ISNULL AND loc_id ISNULL
    THEN
      INSERT INTO Personal_info (school_id, fname, mname, lname,  age, sex, department_id, patient_type_id, height, weight, date_of_birth, civil_status, name_of_guardian, home_address)
      VALUES (par_schoolId, par_fname, par_mname, par_lname, par_age, par_sex_id, par_department_id, par_patient_type_id, par_height, par_weight, par_date_of_birth, par_civil_status_id, par_name_of_guardian, par_home_address);
      INSERT INTO Personal_history (school_id, smoking, allergies, alcohol, medication_taken, drugs)
      VALUES (par_schoolId, par_smoking, par_allergies, par_alcohol, par_medicationstaken, par_drugs);
      INSERT INTO Pulmonary (school_id, cough, dyspnea, hemoptysis, tb_exposure)
      VALUES (par_schoolId, par_cough, par_dyspnea, par_hemoptysis, par_tb_exposure);
      INSERT INTO Gut (school_id, frequency, flank_plan, discharge, dysuria, nocturia, dec_urine_amount)
      VALUES (par_schoolId, par_frequency, par_flank_plan, par_discharge, par_dysuria, par_nocturia, par_dec_urine_amount);
      INSERT INTO Illness (school_id, asthma, ptb, heart_problem, hepatitis_a_b, chicken_pox, mumps, typhoid_fever)
      VALUES (par_schoolId, par_asthma, par_ptb, par_heart_problem, par_hepatitis_a_b, par_chicken_pox, par_mumps, par_typhoid_fever);
      INSERT INTO Cardiac (school_id, chest_pain, palpitations, pedal_edema, orthopnea, nocturnal_dyspnea)
      VALUES (par_schoolId, par_chest_pain, par_palpitations, par_pedal_edema, par_orthopnea, par_nocturnal_dyspnea);
      INSERT INTO Neurologic (school_id, headache, seizure, dizziness, loss_of_consciousness)
      VALUES (par_schoolId, par_headache, par_seizure, par_dizziness, par_loss_of_consciousness);
      INSERT INTO Patient (school_id, personal_info_id, personal_history_id, pulmonary_id, gut_id, illness_id, cardiac_id, neurologic_id, is_active)   
      VALUES (par_schoolId, par_schoolId, par_schoolId, par_schoolId, par_schoolId, par_schoolId, par_schoolId, par_schoolId, par_is_active);

      loc_res = 'OK';
  ELSE
    loc_res = 'Patient already EXISTED';
  END IF;
  RETURN loc_res;
END;
$$
LANGUAGE 'plpgsql';


-- Select * from store_patient('2013-1288', 'David', 'Lopez', 'Guzman', 20, 1, 1, 1, '5 ft 5 inches' , 50 'January 30, 1996', 1, 'Maria Lopez', 'Davao City', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', TRUE);


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION show_patient(IN par_schoolId INT, out TEXT, out TEXT, out TEXT, out INT,
								        out TEXT, out INT, out INT, out TEXT, out FLOAT,  
								        out DATE, out TEXT, out TEXT, out TEXT, out TEXT,  
								        out TEXT, out TEXT, out TEXT, out TEXT, out TEXT, 
  										out TEXT, out TEXT, out TEXT, out TEXT, out TEXT,  
  										out TEXT, out TEXT, out TEXT, out TEXT, out TEXT, 
  										out TEXT, out TEXT, out TEXT, out TEXT, out TEXT,
  										out TEXT, out  TEXT, out TEXT, out TEXT, out TEXT, 
  										out TEXT, out TEXT, out TEXT, out TEXT, out TEXT) RETURNS SETOF RECORD AS
$$

SELECT
    Patient.school_id, 
	Personal_info.fname,
	Personal_info.mname,
	Personal_info.lname,
	Personal_info.age,
	Personal_info.sex_id,
	Personal_info.department_id,
	Personal_info.patient_type_id,
	Personal_info.height,
	Personal_info.weight,
	Personal_info.date_of_birth,
	Personal_info.civil_status_id,
	Personal_info.name_of_guardian,
	Personal_info.home_address,
	Personal_history.smoking,
	Personal_history.allergies,
	Personal_history.alcohol,
	Personal_history.medication_taken,
	Personal_history.drugs,
	Pulmonary.cough,
	Pulmonary.dyspnea,
	Pulmonary.hemoptysis,
	Pulmonary.tb_exposure,
	Gut.frequency,
	Gut.flank_plan,
	Gut.discharge,
	Gut.dysuria,
	Gut.nocturia,
	Gut.dec_urine_amount,
	Illness.asthma,
	Illness.ptb,
	Illness.heart_problem,
	Illness.hepatitis_a_b,
	Illness.chicken_pox,
	Illness.mumps,
	Illness.typhoid_fever,
	Cardiac.chest_pain,
	Cardiac.palpitations,
	Cardiac.pedal_edema,
	Cardiac.orthopnea,
	Cardiac.nocturnal_dyspnea,
	Neurologic.headache,
	Neurologic.seizure,
	Neurologic.dizziness,
	Neurologic.loss_of_consciousness
FROM Patient, Personal_info, Personal_history, Pulmonary, Gut, Illness, Cardiac, Neurologic
Where Patient.school_id = par_schoolId AND Personal_info.school_id = Patient.personal_info_id AND Personal_history.school_id = Patient.personal_history_id AND Pulmonary.school_id = Patient.pulmonary_id AND Gut.school_id = Patient.gut_id AND
      Illness.school_id = Patient.illness_id AND Cardiac.school_id = Patient.cardiac_id AND Neurologic.school_id = Patient.neurologic_id;

$$
LANGUAGE 'sql';

--Select show_patient(20131288);