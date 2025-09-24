import serial
import csv

arduinoComPort = "COM4"  # port name
baudRate = 9600  # baud rate

serialPort = serial.Serial(arduinoComPort, baudRate, timeout=1)

csv_path = "regular_data.csv"

with open(csv_path, mode='w', newline='') as csvfile:  # create csv
    writer = csv.writer(csvfile)
    writer.writerow(["rowID", "pan", "irValue"])  # headers
    
    # loop forever, grabbing lines from the serial port
    while True:
        lineOfData = serialPort.readline().decode().strip()
        if not lineOfData:
            continue  # skip empty lines

        parts = lineOfData.split(",")
        if len(parts) == 3:
            try:
                rowID, pan, irValue = (int(p) for p in parts)
                writer.writerow([rowID, pan, irValue])
                csvfile.flush()
            except ValueError:
                # skip malformed data
                continue
