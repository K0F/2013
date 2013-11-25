// eeg states, indicates the next value we are expecting
import processing.serial.*;
import java.util.ArrayList;
import processing.core.*;
import java.nio.ByteBuffer;
import org.apache.commons.collections.buffer.CircularFifoBuffer;


class rawObs {
  int timestamp;
  int sequence;
  short rawValue;
}

class vectorObs {
  int timestamp;
  int sequence;
  int vectorValue;
}

class eegPort {
  Serial serialPort;

  // Parsing state machine
  // The name describes the data we are currently waiting for


  // various state variables for display of EEG information
  int packetLength = 0;
  int packetCode = 0;
  int poorSignal = 255;
  int readIndex = 0;
  int attention = 0;
  int meditation = 0;
  short rawValue = 0;
  int lastEvent = 0;
  int lastAttention = 0;
  int lastMeditation = 0;
  int vectorBytesLeft = 0;
  dongleState portDongleState = dongleState.DISCONNECTED;
  readState portReadState = readState.SYNC1;

  ArrayList vecArr;
  
  int rawSequence = 0;
  int vectorSequence = 0;

  int failedChecksumCount = 0;

  int readBuffer[];

  CircularFifoBuffer rawDataBuffer;
  CircularFifoBuffer vectorBuffer;
  CircularFifoBuffer attentionBuffer;
  CircularFifoBuffer meditationBuffer;

  // buffer for raw values


  ArrayList getVectors(){

    return vecArr;
  }

  PApplet app;


  eegPort(PApplet applet, Serial serial) {
    app = applet;
    serialPort = serial;

    rawDataBuffer = new CircularFifoBuffer(4096);
    vectorBuffer = new CircularFifoBuffer(4096);
    attentionBuffer = new CircularFifoBuffer(3600);
    meditationBuffer = new CircularFifoBuffer(3600);

    vecArr = new ArrayList();
  }

  void refresh() {
    portReadState = readState.SYNC1;
    serialPort.write((byte)0xc1);
    app.delay(200);
    serialPort.write((byte)0xc2);
  }

  int signedByte(int inByte) {
    ByteBuffer bb = ByteBuffer.allocate(4);
    bb.putInt(inByte);
    return bb.get(3);
  }

  void serialByte(int inByte) {
    switch (portReadState) {
      case SYNC1:
        readBuffer = new int[170];
        packetLength = 0;
        readIndex = 0;
        if (inByte == 170) {
          portReadState = readState.SYNC2;
        }
        break;
      case SYNC2:
        if (inByte == 170) {
          portReadState = readState.LENGTH;
        }
        break;
      case LENGTH:
        packetLength = inByte;
        if (packetLength > 169 || packetLength <= 0) {
          portReadState = readState.SYNC1;
        } 
        else {
          readIndex = 0;
          portReadState = readState.DATA;
          //          app.println("reading " + bytesLeft + " bytes");
        }
        break;
      case DATA:
        readBuffer[readIndex++] = inByte;
        if (readIndex == packetLength) {
          portReadState = readState.CHECKSUM;
        }
        break;
      case CHECKSUM:
        portReadState = readState.SYNC1;
        // run checksum
        int checksum = 0;
        for (int i = 0; i < packetLength; i++) {
          checksum = (checksum + readBuffer[i])%256;
        }
        if (255 - checksum != inByte) {
          //          app.println("checksum fail, calculated " + checksum + ", provided " + inByte +
          //              " for length " + packetLength);
          failedChecksumCount++;
        } 
        else if (packetLength > 0) {
          lastEvent = app.millis();
          parse();
        }
        break;
    }
  }



  void parse() {
    int inByte;

    for (int i = 0; i < packetLength; i++) {
      switch(readBuffer[i]) {
        case 212:      // standby
          portDongleState = dongleState.STANDBY;
          break;
        case 208:      // connected
          portDongleState = dongleState.CONNECTED;
          break;
        case 2:      // poor signal
          inByte = readBuffer[++i];
          if (inByte == 255 && poorSignal == 0) {
            inByte = 49;
          } 
          else if (inByte < 200 && poorSignal == 200) {
            inByte = 254;
          }
          poorSignal = inByte;
          break;
        case 4:      // attention
          inByte = signedByte(readBuffer[++i]);
          if (inByte > 0) {
            attention = inByte;
          }

          lastAttention = app.millis();
          attentionBuffer.add(attention);
          break;
        case 5:      // meditation
          inByte = signedByte(readBuffer[++i]);
          if (inByte > 0) {
            meditation = inByte;
          }

          lastMeditation = app.millis();
          meditationBuffer.add(meditation);
          break;
        case 128:      // raw value
          int rawRowLength = readBuffer[++i];
          int rawA = readBuffer[++i];
          int rawB = readBuffer[++i];

          ByteBuffer bbA = ByteBuffer.allocate(4);
          bbA.putInt(rawA);
          ByteBuffer bbB = ByteBuffer.allocate(4);
          bbB.putInt(rawB);

          ByteBuffer bb = ByteBuffer.allocate(2);
          // value from NeuroSky is little endian, so swap around
          bb.put(1, bbA.get(3));
          bb.put(0, bbB.get(3));

          // short
          rawValue = bb.getShort(0);

          rawSequence++;
          rawObs obs = new rawObs();
          obs.sequence = rawSequence;
          obs.timestamp = app.millis();
          obs.rawValue = rawValue;

          rawDataBuffer.add(obs);
          break;
        case 131:      // vector
          int vectorLength = readBuffer[++i];
          if (vectorLength != 24) {
            // something wrong
            break;
          }

          int tmp [] = new int[8];

          for (int j = 0; j < 8; j++) {
            int vecA = readBuffer[++i];
            int vecB = readBuffer[++i];
            int vecC = readBuffer[++i];
            vectorObs vobs = new vectorObs();

            vobs.timestamp = app.millis();
            vobs.sequence = ++vectorSequence;
            vobs.vectorValue = vecA*255*255 + vecB*255 + vecC;
            vectorBuffer.add(vobs);

            tmp[j] = vecA*255*255 + vecB*255 + vecC;// vobs.vectorValue;



          }

          vecArr.add(tmp);
          
          if (vecArr.size()>width) {
            vecArr.remove(0);
          }

        default:      // unknown
          //          app.println("unknown code " + packetCode);
          break;
      }
    }
  }
}

