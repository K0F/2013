import com.sun.speech.freetts.Voice;
import com.sun.speech.freetts.VoiceManager;
import com.sun.speech.freetts.audio.JavaClipAudioPlayer;



Basnik verlaine;

void setup(){
   verlaine = new Basnik("alan");
    verlaine.mluv("hello, ohtravioso, do you hear me?") ;
} 

public class Basnik {
  String voiceName = "alan";
  VoiceManager voiceManager;
  Voice voice; 

  Basnik(String name){
    voiceName = name;     
    this.setup(); 
  }

  void listAllVoices() {
    System.out.println();
    System.out.println("All voices available:");    
    VoiceManager voiceManager = VoiceManager.getInstance();
    Voice[] voices = voiceManager.getVoices();
    for (int i = 0; i < voices.length; i++) {
      System.out.println("    " + voices[i].getName()
          + " (" + voices[i].getDomain() + " domain)");
    }
  }

  void setup() {
    listAllVoices();
    System.out.println();
    System.out.println("Using voice: " + voiceName);

    voiceManager = VoiceManager.getInstance();
    voice = voiceManager.getVoice(voiceName); 

    voice.setPitch(1.75);
    voice.setPitchShift(0.75);
    voice.setPitchRange(10.1); //mutace
    voice.setStyle("casual");  //"business", "casual", "robotic", "breathy"

    if (voice == null) {
      System.err.println(
          "Cannot find a voice named "
          + voiceName + ".  Please specify a different voice.");
      System.exit(1);
    } 
    voice.allocate();
  }

  void mluv(String _a){     

    if(_a==null){
      _a= "nothing"; 
    }
    voice.speak(_a);

  }

  void exit(){
    voice.deallocate();  
  }
} 
