import serial # pip install pyserial==3.5
import os
import sys
import datetime
import threading
import firebase_admin
from random import randint
from time import sleep, strftime
from firebase_admin import credentials
from firebase_admin import db

COMPILE = False
SERIAL = True

FILE = sys.argv[1] # Archívo a compilar
BOARD = sys.argv[2] # uno o mega
PORT = sys.argv[3] # Nombre del puerdo COM donde se detecta el Arduino
BAUD = 9600

# sudo python3 pyDuino3.py ProtoBlue uno /dev/ttyACM0

DATABASE = "https://pruebabd-7538a-default-rtdb.firebaseio.com/"
KEYS = ["Temperatura_a", "Humedad_a","Temperatura_t","Humedad_t"]

raw_data = ""
new_raw_data = ""
invalido = False

def connect_db(database_url):
	cred = credentials.Certificate("./config.json")
	firebase_admin.initialize_app(cred, {
		'databaseURL': database_url
	})

def json_decode(raw_data):
	values = raw_data.split(",")
	return dict(zip(KEYS, values))

def put_data(data):
	global database_put_ref
	database_put_ref.update(data)

def post_data(data):
	global database_post_ref
	database_post_ref.push(data)

def in_out():
	global raw_data
	for dato in range(100):
		sleep(2)
		Serial.write(bytes(str(dato), 'utf-8'))
		raw_data = str(Serial.readline().decode().strip('\r\n'))
		print(raw_data)

def make_data_fake():
	json_data = []
	dia = datetime.datetime.strptime("2022-9-5", "%Y-%m-%d")
	hora = datetime.datetime.strptime("18:04:30", "%X")
	for i in range(50):
		json_object = {}
		dia = dia + datetime.timedelta(days=1)
		for j in range(5):
			json_object["Fecha"] = str(dia.strftime("%Y-%m-%d"))
			hora = hora + datetime.timedelta(hours=1)
			json_object["Hora"] = str(hora.strftime("%X"))
			json_object["Temperatura_a"] = randint(15,25)
			json_object["Humedad_a"] = randint(10,15)
			json_object["Temperatura_t"] = randint(20,40)
			json_object["Humedad_t"] = randint(40,60)
			json_data.append(json_object)
			json_object = {}
	return json_data

def is_invalid(raw_data):
	if("," in raw_data):
		if(raw_data.index(",") != 0 and raw_data.index(",") != len(raw_data)-1):
			return False
	if(raw_data != "Preparado..."):
		print(f"--->Dato invalido!!! {raw_data}")
	return True

def scan_input():
	global raw_data, new_raw_data
	while(True):
		raw_data = str(Serial.readline().decode().strip('\r\n'))

		if(raw_data != ""):
			print(raw_data)
			if(raw_data != new_raw_data and is_invalid(raw_data) == False and invalido == False):
				json_data = json_decode(raw_data)
				put_data(json_data)
				json_data["Fecha"] = strftime("%Y-%m-%d")
				json_data["Hora"] = strftime("%X")
				post_data(json_data)
				print(f"Enviado: {json_data}")
				Serial.write(bytes("OK", 'utf-8'))
				new_raw_data = raw_data
			
			invalido = is_invalid(raw_data)

if(COMPILE == True):
	out = os.popen(f"arduino -v --upload {FILE}.ino --board arduino:avr:{BOARD} --port {PORT}")
	tx = out.read()
	out.close()
	if("Compiling core" not in tx):
		print("Error al subir el archivo")
		exit()

if(SERIAL == True):
	print('Inicializando comunicación serial...')
	sleep(3)
	Serial = serial.Serial(PORT, BAUD, timeout = .1)
	sleep(1)
	os.system("clear")
	print(Serial.name)

	threading.Thread(target = scan_input).start()

connect_db(DATABASE)
database_put_ref = db.reference("/apimata")
database_post_ref = db.reference("/apimataHistorico")

'''
fake_data = make_data_fake()
for fake in fake_data:
	print(fake)
	post_data(fake)


json_data = json_decode("90,45")
put_data(json_data)
json_data["Fecha"] = strftime("%d/%m/%Y")
json_data["Hora"] = strftime("%X")
post_data(json_data)

print(database_post_ref.get())
print(database_put_ref.get())

'''