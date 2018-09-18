
//**** TEXT
void writeLine(String S, int i) { text(S,30,20+i*40);} // writes S at line i

//**** PICTURES
void snapPictureToJPG() {saveFrame("../IMAGES/PICTURES_JPG/"+PicturesFileName+nf(pictureCounterJPG++,3)+".jpg"); snapJPG=false;}
void snapPictureToTIF() {saveFrame("../IMAGES/PICTURES_TIF/"+PicturesFileName+nf(pictureCounterTIF++,3)+".tif"); snapTIF=false;}
void snapFrameToTIF(){saveFrame("../IMAGES/MOVIE_FRAMES_TIF_DELETE_AFTERWARDS/F"+nf(frameCounter++,4)+".tif");} 
void startRecordingPDF(){beginRecord(PDF,"../IMAGES/PICTURES_PDF/"+PicturesFileName+nf(pictureCounterPDF++,3)+".pdf"); }
void endRecordingPDF()  {endRecord(); recordingPDF=false;}
      /****************************
      To make a movie : 
      reduce canvas size to produce smaller size movie file, 
        for example size(400, 400) if more resolution is not needed  
      Use SPACE to ensue that the help text with the title, your name, and you photo is visible
      Press '`' to start filming,
      Film the help text for a second
      Pess SPACE to hide the help text and interact with model or start an animation 
      press '`' to pause and again to restart and then pause, as desired
      Then, from within your Processing sketch, 
      from the processing menu, select: Tools > Movie Maker. 
      Click on Choose… Navigate to your Sketch Folder. 
      Select the folder IMAGES/MOVIE_FRAMES_TIF_DELETE_AFTERWARDS 
      Press Create Movie, 
      Select the parameters you want. 
      
      WARNING: This may not work for a large canvas!
      MAKE SURE THAT YOU DELETE THE MOVIE_FRAMES_TIF_DELETE_AFTERWARDS folder before submitting !!!
      ****************************/

// *****  CLIPBOARD ITS CONTENT MAY BE USED TO SET FILENAME FOR SAVING/READING POINTS
public static String getClipboard() {   // returns content of clipboard (if it contains text) or null
       Transferable t = Toolkit.getDefaultToolkit().getSystemClipboard().getContents(null);
       try {if (t != null && t.isDataFlavorSupported(DataFlavor.stringFlavor)) {
               String text = (String)t.getTransferData(DataFlavor.stringFlavor);
               return text; }} 
       catch (UnsupportedFlavorException e) { } catch (IOException e) { }
       return null;
       }
       
//Not used in this sketch, but convenient for saving 
public static void setClipboard(String str) { // This method writes a string to the system clipboard. 
       StringSelection ss = new StringSelection(str);
       Toolkit.getDefaultToolkit().getSystemClipboard().setContents(ss, null);
       }
       
  
