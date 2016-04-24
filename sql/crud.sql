CREATE OR REPLACE FUNCTION store_personalInfo(par_schoolId INT, par_fname TEXT, par_mname TEXT, par_lname TEXT, par_age INT,
								 par_sex_id INT, par_department_id INT, par_patient_type_id INT, par_height TEXT, par_weight FLOAT, 
								 par_date_of_birth TIMESTAMP, par_civil_status_id INT, par_name_of_guardian TEXT, par_home_address TEXT) RETURNS TEXT AS
$$
DECLARE
	loc_res TEXT;
BEGIN

  INSERT INTO Personal_info(school_id, fname, mname, lname, age,
  							sex_id, department_id, patient_id, height, par_weight
  							date_of_birth, civil_status_id, name_of_guardian, home_address)
  VALUES(par_schoolId, par_fname, par_mname, par_lname, par_age, par_sex_id, par_department_id, par_patient_type_id, par_height, par_weight,
  	     par_date_of_birth, par_civil_status_id, par_name_of_guardian, par_home_address);

  loc_res = 'OK';
  RETURN loc_res;
END;
$$
LANGUAGE 'plpgsql';

---------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION store_personalHistory(par_schoolId INT,par_smoking TEXT, par_allergies TEXT, par_alcohol TEXT, par_medication_taken TEXT,
  										par_drugs TEXT) RETURNS TEXT AS
$$
DECLARE
	loc_res TEXT;
	loc_id INT;
BEGIN
  SELECT INTO loc_id school_id
  FROM Personal_info
  Where school_id = par_schoolId;
  
  INSERT INTO Personal_history(school_id, smoking, allergies, alcohol, medication_taken, drugs)
  VALUES(par_schoolId, par_smoking, par_allergies, par_alcohol, par_medication_taken, par_drugs);

  loc_res = 'OK';
  RETURN loc_res;
END;
$$
LANGUAGE 'plpgsql';

---------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION store_pulmonary(par_schoolId INT, par_cough TEXT, par_dyspnea TEXT, par_hemoptysis TEXT, par_tb_exposure TEXT) RETURNS TEXT AS
$$
DECLARE
	loc_res TEXT;
BEGIN

  INSERT INTO Pulmonary(school_id, cough, dyspnea, hemoptysis, tb_exposure)
  VALUES(par_schoolId, par_cough, par_dyspnea, par_hemoptysis, par_tb_exposure);

  loc_res = 'OK';
  RETURN loc_res;
END;
$$
LANGUAGE 'plpgsql';

-------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION store_gut(par_schoolId INT, par_frequency TEXT, par_flank_plan TEXT, par_discharge TEXT, par_dysuria TEXT, 
							par_nocturia TEXT, par_dec_urine_amount TEXT) RETURNS TEXT AS
$$
DECLARE
	loc_res TEXT;
BEGIN

  INSERT INTO Gut(school_id, frequency, flank_plan, discharge, dysuria, nocturia, dec_urine_amount)
  VALUES(par_schoolId, par_frequency, par_flank_plan, par_discharge, par_dysuria, par_nocturia, par_dec_urine_amount);

  loc_res = 'OK';
  RETURN loc_res;
END;
$$
LANGUAGE 'plpgsql';

------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION store_illness(par_schoolId INT, par_asthma TEXT, par_ptb TEXT, par_heart_problem TEXT, par_hepatitis_a_b TEXT,
  								par_chicken_pox TEXT, par_mumps TEXT, par_typhoid_fever TEXT) RETURNS TEXT AS
$$
DECLARE
	loc_res TEXT;
BEGIN

  INSERT INTO Illness(school_id, asthma, ptb, heart_problem, hepatitis_a_b, chicken_pox, mumps, typhoid_fever)
  VALUES(par_schoolId, par_asthma, par_ptb, par_heart_problem, par_hepatitis_a_b, par_chicken_pox, par_mumps, par_typhoid_fever);

  loc_res = 'OK';
  RETURN loc_res;
END;
$$
LANGUAGE 'plpgsql';

-------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION store_cardiac(par_schoolId INT, par_chest_pain TEXT, par_palpitations TEXT, par_pedal_edema TEXT, par_orthopnea TEXT,
  								par_nocturnal_dyspnea TEXT) RETURNS TEXT AS
$$
DECLARE
	loc_res TEXT;
BEGIN

  INSERT INTO Cardiac(school_id, chest_pain, palpitations, pedal_edema, orthopnea, nocturnal_dyspnea)
  VALUES(par_schoolId, par_chest_pain, par_palpitations, par_pedal_edema, par_orthopnea, par_nocturnal_dyspnea);

  loc_res = 'OK';
  RETURN loc_res;
END;
$$
LANGUAGE 'plpgsql';

--------------------------------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION store_neurologic(par_schoolId INT, par_headache TEXT, par_seizure TEXT, par_dizziness TEXT, par_loss_of_consciousness TEXT) RETURNS TEXT AS
$$
DECLARE
	loc_res TEXT;
BEGIN

  INSERT INTO Neurologic(school_id, headache, seizure, dizziness, loss_of_consciousness)
  VALUES(par_schoolId, par_headache, par_seizure, par_dizziness, par_loss_of_consciousness);

  loc_res = 'OK';
  RETURN loc_res;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION show_patient(IN par_schoolId INT, out TEXT, out TEXT, out TEXT, out INT,
								        out INT, out INT, out INT, out TEXT, out FLOAT,  
								        out TIMESTAMP, out INT, out TEXT, out TEXT, out TEXT,  
								        out TEXT, out TEXT, out TEXT, out TEXT, out TEXT, 
  										out TEXT, out TEXT, out TEXT, out TEXT, out TEXT,  
  										out TEXT, out TEXT, out TEXT, out TEXT, out TEXT, 
  										par_ptb TEXT, par_heart_problem TEXT, par_hepatitis_a_b TEXT, par_chicken_pox TEXT, par_mumps TEXT,
  										par_typhoid_fever TEXT, par_chest_pain  TEXT, par_palpitations TEXT, par_pedal_edema TEXT, par_orthopnea TEXT, 
  										par_nocturnal_dyspnea TEXT, par_headache TEXT, par_seizure TEXT, par_dizziness TEXT, par_loss_of_consciousness TEXT) RETURNS SETOF RECORD AS
$$
DECLARE
	loc_id INT;

SELECT
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
FROM Personal_info, Personal_history, Pulmonary, Gut, Illness, Cardiac, Neurologic
Where par_school_id = '1' AND Personal_info.school_id = par_schoolId AND Personal_history.school_id = par_schoolId AND Pulmonary.school_id = par_schoolId AND Gut.school_id = par_schoolId AND
      Illness.school_id =par_schoolId AND Cardiac.school_id = par_schoolId AND Neurologic.school_id = par_schoolId;

$$
LANGUAGE 'sql';























