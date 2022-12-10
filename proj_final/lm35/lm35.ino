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

int out_PWM = 255;
float temperature = 0;
int sec_passed = 0;

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


void setup() { 
  // Begin serial communication at a baud rate of 9600:
  Serial.begin(9600);
  //Declaring LED pin as output
  pinMode(PWM_PIN, OUTPUT);
  setupDS18B20();
}

void PWMUpdate(){
  //Fading the LED
  analogWrite(PWM_PIN, out_PWM);
}

void sensorRead(){
  sensors.requestTemperatures();
  float tempC = sensors.getTempC(sensor1);
  temperature = tempC;
}

void printValues(){

  // Seconds passed
  Serial.print("Sec: ");
  Serial.print(sec_passed);
  // Tempoerature measured
  Serial.print("   Temp: ");
  Serial.print(temperature);
  Serial.print("C");
  // PWM out
  Serial.print("   PWM_out: ");
  Serial.print(out_PWM);
  // Tension out
  Serial.print("   Tension_out: ");
  Serial.print(out_PWM * 5 / 255.0f);
  Serial.println("");

}

void loop() {
  PWMUpdate();
  sensorRead();
  printValues();
  // Serial.print("hi\n");
  delay(1000); // wait a second between readings
  sec_passed += 1;

  return;
}
