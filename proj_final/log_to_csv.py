import numpy as np
import matplotlib.pyplot as plt

filename_read = "arduino_serial_treated.log"
filename_csv = "step_response_temp.csv"


temps = []

def add_line_temp(line: str):
    line_split = line.split(":")
    temp_str = line_split[2]
    temp_str = temp_str[1:6]
    temp = float(temp_str)
    temps.append(temp)

def get_temps_from_file():
    with open(filename_read, "r") as f:
        line = f.readline()
        while(line):
            add_line_temp(line)
            line = f.readline()

def save_temps_to_csv():
    with open(filename_csv, "w") as f:
        f.write("seconds,temperature\n")
        for i, temp in enumerate(temps):
            f.write(f"{i},{temp}\n")

get_temps_from_file()
save_temps_to_csv()

arr = np.array(temps)
plt.plot(arr)
plt.show()