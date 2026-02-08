#include <LiquidCrystal.h>

// ---------------- LCD ----------------
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

// Track last state so we only redraw when needed
uint8_t lastState = 255;

// ---------------- FPGA INPUT PINS ----------------
// (Make sure these match your wiring)
const int hungerPins[3]    = {22, 23, 24};
const int happinessPins[3] = {25, 26, 27};
const int fsmPins[3]       = {28, 29, 30};

// ---------------- HEART CHARACTERS ----------------
byte emptyLeft[8] = {
  B01110,B10001,B10000,B10000,B01000,B00100,B00010,B00001
};
byte emptyRight[8] = {
  B01110,B10001,B00001,B00001,B00010,B00100,B01000,B10000
};
byte fullLeft[8] = {
  B01110,B11111,B11111,B11111,B01111,B00111,B00011,B00001
};
byte fullRight[8] = {
  B01110,B11111,B11111,B11111,B11110,B11100,B11000,B10000
};

// ---------------- STABLE 3-BIT READ ----------------
uint8_t readStable3Bits(const int pins[3])
{
  uint8_t first = 0;
  uint8_t second = 0;

  for(int i=0;i<3;i++)
    first |= digitalRead(pins[i]) << i;

  delayMicroseconds(200);

  for(int i=0;i<3;i++)
    second |= digitalRead(pins[i]) << i;

  if(first == second)
    return first;
  else
    return second;
}

// ---------------- HEART DRAWING ----------------
void printHearts(uint8_t value)
{
  uint8_t points = value + 1;

  for(int i=0;i<4;i++)
  {
    if(points >= 2){
      lcd.write(byte(2));
      lcd.write(byte(3));
      points -= 2;
    }
    else if(points == 1){
      lcd.write(byte(2));
      lcd.write(byte(1));
      points = 0;
    }
    else{
      lcd.write(byte(0));
      lcd.write(byte(1));
    }
  }
}

// ---------------- SERIAL FACE OUTPUT ----------------
void printFaceSerial(uint8_t state)
{
    String line1;
    String line2;

    switch(state)
    {
        case 0:
            line1 = "   Jelly Pet   ";
            line2 = "     (o.o)     ";
            break;
        case 1:
            line1 = "   Jelly Pet   ";
            line2 = "     (-.-)     ";
            break;
        case 2:
            line1 = "     Eating    ";
            line2 = "     (^o^)     ";
            break;
        case 3:
            line1 = "    Playing    ";
            line2 = "   \\(^u^)/     ";
            break;
        case 4:
            line1 = "     Dizzy     ";
            line2 = "     (o_0)     ";
            break;
        case 5:
            line1 = "   GAME OVER   ";
            line2 = "     (x_x)     ";
            break;
        default:
            line1 = "   Jelly Pet   ";
            line2 = "     (o.o)     ";
    }

    // Line 1 of face
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("                                                                              "+ line1);
    // Line 2 of face
    Serial.println("                                                                              "+ line2);
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    Serial.println("");
    // Bottom border
}


// ---------------- SETUP ----------------
void setup()
{
  Serial.begin(9600);

  for(int i=0;i<3;i++){
    pinMode(hungerPins[i], INPUT);
    pinMode(happinessPins[i], INPUT);
    pinMode(fsmPins[i], INPUT);
  }

  lcd.begin(16,2);

  lcd.createChar(0, emptyLeft);
  lcd.createChar(1, emptyRight);
  lcd.createChar(2, fullLeft);
  lcd.createChar(3, fullRight);

  lcd.clear();
}

// ---------------- MAIN LOOP ----------------
void loop()
{
  uint8_t hunger    = readStable3Bits(hungerPins);
  uint8_t happiness = readStable3Bits(happinessPins);
  uint8_t state     = readStable3Bits(fsmPins);

  // Only redraw when state changes
  if(state != lastState)
  {
    // DEAD state (state == 5)
    if(state == 5)
    {
      // Serial output as box
      printFaceSerial(state);

      // LCD shows GAME OVER
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("   GAME OVER   ");
      lcd.setCursor(0,1);
      lcd.print("     (x_x)     ");
    }
    else
    {
      // Serial output as box
      printFaceSerial(state);

      // LCD shows hearts normally
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("Hungry ");
      printHearts(hunger);

      lcd.setCursor(0,1);
      lcd.print("Happy  ");
      printHearts(happiness);
    }

    lastState = state;
  }

  delay(150);
}

