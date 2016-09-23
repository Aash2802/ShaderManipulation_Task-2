// Import the Minim audio framework
import ddf.minim.*;

Minim minim;
AudioPlayer player;

class SoundInput {

  //Constructor -- one time function
  SoundInput(PApplet papp) {
    //Load MP3 file
    // we pass this to Minim so that it can load files from the data directory
    minim = new Minim(papp);

    // loadFile will look in all the same places as loadImage does.
    // this means you can find files that are in the data folder and the 
    // sketch folder. you can also pass an absolute path, or a URL.
    player = minim.loadFile("Enjoy.mp3");

    // play the file from start to finish.
    // if you want to play the file again, 
    // you need to call rewind() first.
    player.play();
    player.loop();
  }

  float getVolume() {
    for (int i = 0; i < player.bufferSize() - 1; i++) {
      float left = player.left.get(i);
      float right = player.right.get(i);
      volume = left + right / 2;
    }
    return volume;
  }

  float volume;
}