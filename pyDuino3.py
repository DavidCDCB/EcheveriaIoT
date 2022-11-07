import serial # pip install pyserial==3.5
import os
import sys
import requests
import threading
import firebase_admin
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
KEYS = ["Temperatura", "Humedad"]

raw_data = ""
new_raw_data = ""

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

def scan_input():
	global raw_data, new_raw_data
	while(True):
		raw_data = str(Serial.readline().decode().strip('\r\n'))
		if(raw_data != ""):
			print(raw_data)
		if(raw_data != new_raw_data and "," in raw_data):
			json_data = json_decode(raw_data)
			put_data(json_data)
			json_data["Fecha"] = strftime("%d/%m/%Y")
			json_data["Hora"] = strftime("%X")
			post_data(json_data)
			print(f"Enviado: {json_data}")
			Serial.write(bytes("OK", 'utf-8'))
			new_raw_data = raw_data

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
json_data = json_decode("90,45")
put_data(json_data)
json_data["Fecha"] = strftime("%d/%m/%Y")
json_data["Hora"] = strftime("%X")
post_data(json_data)

print(database_post_ref.get())
print(database_put_ref.get())
'''