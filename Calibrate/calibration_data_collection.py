import serial
import csv

arduinoComPort = "COM4" # port number
baudRate = 9600 # baud rate

# open serial port
serialPort = serial.Serial(arduinoComPort, baudRate, timeout=1)

# create csv file for calibration data
with open('calibration_data.csv', mode='a', newline='') as csvfile:
    writer = csv.writer(csvfile)
    
    # read from arduino while running
    while True:
        # read one line from serial, decode to string, strip whitespace
        lineOfData = serialPort.readline().decode(errors="ignore").strip()
        
        if not lineOfData: # skip empty lines
            continue
        
        if lineOfData.isdigit():  # only process numbers
            value = int(lineOfData)
            print(f"IR value = {value}") # print to make sure it's working
            writer.writerow([value]) # write to csv
            csvfile.flush()
