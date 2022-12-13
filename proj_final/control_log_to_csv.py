import numpy as np
import matplotlib.pyplot as plt

filename_read = "logs/arduino_serial_control_treated.log"
filename_csv = "control_signal_response.csv"

header = ["Sec", "Temp", "goal_temp", "initial_temp", "error", "integral_error", "u", "PWM", "Kp", "Ki"]
values = []

def add_line_temp(line: str):
    if(not line.startswith("Sec")):
        return

    line_split = line.split("  ")
    def get_value_desired(name: str) -> float:
        str_name = next(v for v in line_split if v.startswith(name))
        val_str = str_name.split(":")[1]
        val_str = val_str.strip()
        return float(val_str)
    values.append([])
    for name in header:
        values[-1].append(get_value_desired(name))

def get_temps_from_file():
    with open(filename_read, "r") as f:
        line = f.readline()
        while(line):
            add_line_temp(line)
            line = f.readline()

def save_temps_to_csv():
    with open(filename_csv, "w") as f:
        f.write(",".join(header) + "\n")
        for vals in values:
            f.write(",".join(str(v) for v in vals) + "\n")

get_temps_from_file()
save_temps_to_csv()

# arr = np.array(temps)
# plt.plot(arr)
# plt.xlabel("Time (seconds)")
# plt.ylabel("Temperature (ºC)")
# plt.show()