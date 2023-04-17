#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <DHT.h>

#define WIFI_SSID "realme 5i"
#define WIFI_PASSWORD "pewo9080"

#define SERVER_URL "http://192.168.43.239:5678"

#define PULSE_SENSOR_PIN A0
#define LED_PIN D1
#define BUTTON_PIN D2
#define WIFI_PIN D3
#define DHT_PIN D5

#define DHT_TYPE DHT11

#define BTN_DELAY 50
#define PULSE_DELAY 1000
#define DHT_DELAY 1500

DHT dht(DHT_PIN, DHT11);

int buttonState = 0;
int lastButtonState = 0;

int lastHumidityValue = 0;

bool invalidPulseSend = false;

unsigned long lastBtnTime = millis();
unsigned long lastHumidityTime = millis();
unsigned long lastPulseTime = millis();

void setup() {
  // Serial.begin(9600);

  pinMode(BUTTON_PIN, INPUT);
  pinMode(LED_PIN, OUTPUT);
  pinMode(WIFI_PIN, OUTPUT);

  connect_wifi();

  dht.begin();
}

void loop() {

  if (WiFi.status() != WL_CONNECTED) {
    reconnect_wifi();
  }

  if ((millis() - lastBtnTime) > 500) {
    digitalWrite(LED_PIN, LOW);
  }

  // Handle button press
  buttonHandle();

  // Handle pulse sensor
  pulseHandle();

  // Handle DHT11 sensor
  humidityHandle();
}

void buttonHandle() {
  int reading = digitalRead(BUTTON_PIN);

  if (reading != lastButtonState) {
    lastBtnTime = millis();
  }

  if ((millis() - lastBtnTime) > BTN_DELAY && reading != buttonState) {
    buttonState = reading;
    if (buttonState == HIGH) {
      digitalWrite(LED_PIN, HIGH);
      pushRequestServer("/pushButton");
    }
  }
  lastButtonState = reading;
}

void pulseHandle() {
  float pulseReading = analogRead(PULSE_SENSOR_PIN);

  if (!isnan(pulseReading) && millis() - lastPulseTime > PULSE_DELAY) {
    lastPulseTime = millis();

    if (pulseReading >= 450) {
      int pulse = (pulseReading - 404) / 5;
      invalidPulseSend = false;
      sendDataServer("/heartbeat", String(pulse));
    } else if (!invalidPulseSend) {
      invalidPulseSend = true;
      sendDataServer("/heartbeat", String(1));
    }
  }
}

void humidityHandle() {
  int humidity = dht.readHumidity();

  if (!isnan(humidity) && millis() - lastHumidityTime > DHT_DELAY && humidity != lastHumidityValue) {
    lastHumidityTime = millis();
    lastHumidityValue = humidity;
    sendDataServer("/temperature", String(humidity));
  }
}

void connect_wifi() {
  digitalWrite(WIFI_PIN, LOW);
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  connectionState();
}

void reconnect_wifi() {
  digitalWrite(WIFI_PIN, LOW);
  WiFi.reconnect();
  connectionState();
}

void connectionState() {
  while (WiFi.status() != WL_CONNECTED) {
    digitalWrite(WIFI_PIN, HIGH);
    delay(500);
    digitalWrite(WIFI_PIN, LOW);
    delay(500);
  }
  digitalWrite(WIFI_PIN, HIGH);
}

void pushRequestServer(String path) {
  HTTPClient http;
  http.begin(SERVER_URL + path);
  http.GET();
  //  int httpResponseCode = http.GET();
  //  if (httpResponseCode > 0) {
  //    Serial.print("HTTP Response onButtonPress code: ");
  //    Serial.println(httpResponseCode);
  //  } else {
  //    Serial.print("Error onButtonPress code: ");
  //    Serial.println(httpResponseCode);
  //  }
  http.end();
}

void sendDataServer(String path, String value) {
  HTTPClient http;
  http.begin(SERVER_URL + path);
  http.addHeader("Content-Type", "application/json");

  String requestBody = "{\"value\": " + value + "}";

  http.POST(requestBody);
  http.end();
}
