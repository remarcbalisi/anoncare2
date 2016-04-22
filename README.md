# anoncare2
Cleaned version of anoncare2. Temporarily, Anoncare team will work on this repository to set things up.


Hello guys, mag temporarily i set up nato ang system diri na repo. Ngano man?
kay para ma limpyo, dili libog ang codes ug mga organize ang mga directories
ug para matangtang to tanan mga dependencies na gi pang butang nato na walay gamit.


Diri na repository kay walay testing. Ang buhaton lang jud nato kay humanon nato ang system
upto 60%. Diri ta mag push. As I said temporary lang ni na repository, ang final jud(ang ipakita kay sir)
kay https://github.com/erikkaBaguio/Anon-Healthcare-System.


I pull lang ni siya.


# create new folder
git init
git remote add origin https://github.com/remarcbalisi/anoncare2.git
git pull origin master


# create new virtual environemnt

@using virtualenvwrapper
mkvirtualenv anoncare2


@using the usual environment
virtualenv anoncare2 --> ambot dili ko sure sa command.


# installing system requirements
pip install -r requirements.txt


note: kani pa ang mainstall ana


Flask==0.10.1
Flask-Cors==2.1.2
itsdangerous==0.24
Jinja2==2.8
MarkupSafe==0.23
six==1.10.0
SQLAlchemy==1.0.12
Werkzeug==0.11.8


the rest is up to you. Naka base man gud sa inyong mga assigned features ang iinstall. So dapat in every install
ninyo ug mga dependencies ALWAYS UPDATE THE REQUIREMENTS.TXT (PIP FREEZE > REQUIREMENTS.TXT).
after installing (make sure na naka activate ang virtual environment), you can now run the system: python run.py.
The system is running on port:5000, socket will run on port:8000 and UI will run on port:80(apache port).


# SQL FOLDER, DATABASE, CRUD OPERATIONS


inside sql folder naa dira ang crud.sql, table.sql, trigger.sql


@crud.sql

naa diri tanan ang crud operations. Ang mga functions diri nato ibutang tanan. Tapos make sure na clean code. (zen of python)
Please include working functions only. Separate each CRUD operation using the "---". and please provide two line spaces
for every functions or methods

for example:

-------------------------------CRUD FOR USER------------------------------

function show(in id)
   this function will get user by id

function get()
	this function will get all users

function store()
	this function will store new user

function destroy(in id)
	this function will delete a user by id

function update(in id)
	this function will update the user by id

--------------------------------------------------------------------------

naming convention:

show, 
get, 
store, 
destroy, 
update


@ table.sql

Kani may maka werla ang attributes. Attribute id must be serial8 pero naay instance na dili siya serial(auto increment)
pareha kay gege, naay part sa database table niya na dili pwede serial ang id.

@ trigger.sql

trigger functions here.



# Tasking

Add user - josiah

users have 3 roles. So mag create ug role table(josiah).

REMEMBER DILI TA MUGAMIT MUNA UG UI SA ADDING HA? API LANG MUNA. PWEDE MU MUGAMIT UG POSTMAN PARA MAS
DALI.

routes naming convention: /api/anoncare

DEADLINE FOR ADD USER IS UNTIL 11PM. After sa add user you can proceed to next


We don't have log-in pa. Magbuhat ta ug log in: Gege, Josiah, Erikka, Bals.
Wala moy lain buhaton feature kundi login lang jud. Deadline is until 3:00 AM. April 23, 2016.
Yes! kinahanglan mo mag online ug 3am. Shockings diba? hahahaha. Pero If ever gani naay nay maka discover or
makahuman sa login before 3:00 AM, please inform us. Para maka sugod na ang uban sa ilang mga tasking.
Mag hatag kog list sa tasking (NOTE: mag sukod ramo ani after pag naa nay log in feature.).


View user - Gege
Update user - Erikka
Delete user - bals


LATER NA PUD...