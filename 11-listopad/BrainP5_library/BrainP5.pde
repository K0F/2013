//
//  A parser for Neurosky EEG brainwave data for Processing.
//  see also : https://github.com/kitschpatrol/Arduino-Brain-Library/tree/master/Brain
//
import processing.core.PApplet;
import processing.serial.*;



class BrainP5 
{
  Serial serial;

  int signalQuality;
  int attention;
  int meditation;
  int [] eegPower = new int[8];

  long last_update_time;

  int payload_size;
  int payload_read_count;
  int last_byte;
  int [] payload_data = new int[256];

  final int READ_HEADER  = 0;
  final int READ_SIZE    = 1;
  final int READ_PAYLOAD = 2;
  int mode = READ_HEADER;
  
  BrainP5(PApplet papplet, String port) {
    serial = new Serial(papplet,  port, 57600);
  }
  
  boolean isAlive() {
    long diff = System.currentTimeMillis() - last_update_time;
    if (diff < 2000) return true;
    return false;
  }

  int eegPower(int idx) {
    return eegPower[idx];
  }

  int delta() {
    return eegPower[0];
  }

  int theta() {
    return eegPower[1];
  }
  
  int lowAlpha() {
    return eegPower[2];
  }
  
  int highAlpha() {
    return eegPower[3];
  }
  
  int lowBeta() {
    return eegPower[4];
  }

  int highBeta() {
    return eegPower[5];
  }

  int lowGamma() {
    return eegPower[6];
  }

  int midGamma() {
    return eegPower[7];
  }

  void read() {
    if ( serial.available() > 0) {
      do {
        int c = serial.read();
        
        switch(mode) {
          case READ_HEADER:
            read_header(c);
            break;
          case READ_SIZE:
            read_size(c);
            break;
          case READ_PAYLOAD:
            read_payload(c);
            break;
        }
        last_byte = c;
      } while(serial.available() > 0);
    }
  }
  
  void read_header(int c) {
    if (c == 0xaa && last_byte == 0xaa) {
      mode = READ_SIZE;
    }
  }
  
  void read_size(int c) {
    payload_size = c;
    payload_read_count = 0;
    mode = READ_PAYLOAD;
  }
  
  void read_payload(int c) {
    payload_data[payload_read_count] = c;
    payload_read_count ++;
    if (payload_read_count == payload_size) {
      parse_payload();
      mode = READ_HEADER;
    }
  }
  
  void parse_payload() {
    int i = 0;
    do {
      int tag = payload_data[i++];
      switch(tag) {
        case 2:
          signalQuality = payload_data[i++];
          break;
        case 4:
          attention = payload_data[i++];
          break;
        case 5:
          meditation = payload_data[i++];
          break;
        case 131:
          int len = payload_data[i++];
          for (int j = 0; j < 8; j++) {
            int p0 =  payload_data[i++];
            int p1 =  payload_data[i++];
            int p2 =  payload_data[i++];
            eegPower[j] = (p0 << 16) | (p1 << 8) | p2;
          }
          break;
        default:
          break;
      }
    } while(i < payload_size);
    
    last_update_time = System.currentTimeMillis();
  }
  
  String to_s() {
    String s = "";
    s += "signalQuality=" + signalQuality + ", ";
    s += "attention=" + attention + ", ";
    s += "meditation=" + meditation + ", ";
    for (int i = 0; i < 8; ++i) {
      s += "e" + i + "=" + eegPower[i] + ", ";
    }
    return s;
  }
}
