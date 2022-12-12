#include <Wire.h>

#include <OneWire.h>
#include <DallasTemperature.h>

// Porta do pino de sinal do DS18B20
#define ONE_WIRE_BUS 8

// Define uma instancia do oneWire para comunicacao com o sensor
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

DeviceAddress sensor1;

#define PWM_PIN 3

// Last control update
unsigned long previous_millis = 0;  

// Temperature to change in 180 seconds interval, 1800 seconds total 10 temperatures
const int n_temps = 8;
const int time_temp = 450;
const float temperatures_time[n_temps] = {30.6, 34, 36, 33.2, 34.6, 37.1, 35.1, 31.3};

// Measured temperature
volatile float measured_temperature = 0;
// Goal temperature
volatile float goal_temperature = 0;
// Initial temperature
volatile float initial_temperature = 0;
// Factor to normalize temperature to
const float normalize_temperature_factor = 15.2;

volatile float sec_passed = 0;
// Time in milisseconds between updates
const int dt = 1000;

// Proportional gain of controller
const float Kp = 5.2544; // 5.2544;
// Integral gain of controller
const float Ki = 0.021; // 0.0420;
// Error measured, normalized to system (0, 1)
volatile float e = 0;
// Integral of error measured
volatile float eintegral = 0;
// Output to send to actuator, normalized to system (0, 1)
volatile float u = 0;
// PWM sent to actuator, between 0 and 255
volatile int PWM_out = 0;

void computeE(){
  e = goal_temperature - measured_temperature;
  e /= normalize_temperature_factor;

  eintegral += e * dt / 1000.0f;
}

void computeU(){
  u = Kp * e + Ki * eintegral;
}

void updatePWM(){
  PWM_out = u * 255;
  if(PWM_out < 0){
    PWM_out = 0;    
  }else if(PWM_out > 255){
    PWM_out = 255;    
  }
  analogWrite(PWM_PIN, PWM_out);
}

void controlPlant(){
  computeE();
  computeU();
  updatePWM();
}

void showSensorAddress(DeviceAddress deviceAddress)
{
  for (uint8_t i = 0; i < 8; i++)
  {
    // Adiciona zeros se necessário
    if (deviceAddress[i] < 16) Serial.print("0");
    Serial.print(deviceAddress[i], HEX);
  }
}

void setupDS18B20(){
  sensors.begin();
  // Localiza e mostra enderecos dos sensores
  Serial.println("Localizando sensores DS18B20...");
  Serial.print("Foram encontrados ");
  Serial.print(sensors.getDeviceCount(), DEC);
  Serial.println(" sensores.");
  if (!sensors.getAddress(sensor1, 0)) 
     Serial.println("Sensores nao encontrados !"); 
  // Mostra o endereco do sensor encontrado no barramento
  Serial.print("Endereco sensor: ");
  showSensorAddress(sensor1);
  Serial.println();
  Serial.println();
}

void updateInitialTemperature(){
  sensors.requestTemperatures();
  initial_temperature = sensors.getTempC(sensor1);
}


void setup() { 
  // Begin serial communication at a baud rate of 9600:
  Serial.begin(9600);
  //Declaring LED pin as output
  pinMode(PWM_PIN, OUTPUT);
  setupDS18B20();
  updateInitialTemperature();

  previous_millis = millis();
}

void sensorRead(){
  sensors.requestTemperatures();
  measured_temperature = sensors.getTempC(sensor1);
}

void printValues(){
  // Seconds passed
  Serial.print("Sec: ");
  Serial.print(sec_passed);
  // Tempoerature measured
  Serial.print("  Temp: ");
  Serial.print(measured_temperature);
  // Temperature goal
  Serial.print("  goal_temp: ");
  Serial.print(goal_temperature);
  // Temperature goal
  Serial.print("  initial_temp: ");
  Serial.print(initial_temperature);
  // Error signal
  Serial.print("  error: ");
  Serial.print(e);
  // Integral of error
  Serial.print("  integral_error: ");
  Serial.print(eintegral);
  // Control out
  Serial.print("  u: ");
  Serial.print(u);
  // PWM out (real)
  Serial.print("  PWM: ");
  Serial.print(PWM_out);
  // Kp
  Serial.print("  Kp: ");
  Serial.print(Kp);
  // Ki
  Serial.print("  Ki: ");
  Serial.print(Ki);

  Serial.println("");
}

void updateGoalTemperature(){
  int idx_use = (int)sec_passed / time_temp;
  idx_use %= n_temps;
  goal_temperature = temperatures_time[idx_use];

  /*if(sec_passed > 0 && sec_passed < 100){
    goal_temperature = initial_temperature + 2;
  } else if(sec_passed < 200){
    goal_temperature = initial_temperature + 4;
  } else if(sec_passed < 400){
    goal_temperature = initial_temperature + 10;
  } else {
    goal_temperature = initial_temperature + 6;
  }*/
}

void loop() {
  updateGoalTemperature();
  sensorRead();
  controlPlant();
  printValues();
  sec_passed += dt / 1000.0f;

  unsigned long new_millis = millis();
  // Wait dt milliseconds in total
  delay(dt - (new_millis - previous_millis));
  previous_millis = millis();
}
