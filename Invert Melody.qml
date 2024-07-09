import QtQuick 2.0
import MuseScore 3.0

MuseScore {
      onRun: {
            menuPath: "Invert Melody"
            description: "Invert Melody"
            version: "1.1"
            //Create Cursor
            var crs=curScore.newCursor();
            crs.rewind(0);
            //List pitches of notes in all keys
            const CArray=[0,2,4,5,7,9,11];//C
            const GArray=[0,2,4,6,7,9,11];//G
            const DArray=[1,2,4,6,7,9,11];//D
            const AArray=[1,2,4,6,8,9,11];//A
            const EArray=[1,3,4,6,8,9,11];//E
            const BArray=[1,3,4,6,8,10,11];//B
            const GbArray=[1,3,5,6,8,10,11];//F#Gb
            const DbArray=[0,1,3,5,6,8,10];//Db
            const AbArray=[0,1,3,5,7,8,10];//Ab
            const EbArray=[0,2,3,5,7,8,10];//Eb
            const BbArray=[0,2,3,5,7,9,10];//Bb
            const FArray=[0,2,4,5,,7,9,10];//F
            var ZArray={};//Variable list
            //List major/minor Intervals
            const majInterv=[2,4,6,9,11];
            const minInterv=[1,3,5,8,10]; 
            //Variables concerning pitch
            var pitchPrev0=crs.element.notes[0].pitch;//Previouse note of staff 0
            var pitchCur0=crs.element.notes[0].pitch;//Current note of staff 0
            var pitchDiff=pitchPrev0-pitchCur0;//Pitch difference/intervall
            var pitchPrev1=crs.element.notes[0].pitch;//Previouse note of staff 1
            var pitchCur1=crs.element.notes[0].pitch;//Current note of staff 1
            //Variable concerning duration
            var durationDenominator=crs.element.duration.denominator; 
            var x=true; 
            
            //Creating first note
            crs.staffIdx=1;
            crs.setDuration(1,durationDenominator);
            crs.addNote(pitchCur0-12);
            crs.prev();                       
            pitchPrev1=crs.element.notes[0].pitch;
            pitchCur1=crs.element.notes[0].pitch;
            crs.staffIdx=0;
            crs.next();
            durationDenominator=crs.element.duration.denominator;
            //Loop         
            while(x){
                  if (crs.element.notes){
                        //Creating note      
                        pitchCur0=crs.element.notes[0].pitch;
                        pitchDiff=pitchPrev0-pitchCur0;
                        pitchPrev0=crs.element.notes[0].pitch;
                        crs.staffIdx=1;
                        crs.setDuration(1,durationDenominator); 
                        crs.addNote(pitchPrev1+pitchDiff);
                        crs.prev();
                        pitchCur1=crs.element.notes[0].pitch;
                        //Set ZArray to Array of key
                        if (crs.score.keysig==0)
                              ZArray=CArray;
                        if (crs.score.keysig==1)
                              ZArray=GArray;
                        if (crs.score.keysig==2)
                              ZArray=DArray;
                        if (crs.score.keysig==3)
                              ZArray=AArray;
                        if (crs.score.keysig==4)
                              ZArray=EArray;
                        if (crs.score.keysig==5)
                              ZArray=BArray;
                        if (crs.score.keysig==Math.abs(6))//Math.abs required, as F#=6, Gb=-6
                              ZArray=GbArray;
                        if (crs.score.keysig==-5)
                              ZArray=DbArray;
                        if (crs.score.keysig==-4)
                              ZArray=AbArray;
                        if (crs.score.keysig==-3)
                              ZArray=EbArray;
                        if (crs.score.keysig==-2)
                              ZArray=BbArray;
                        if (crs.score.keysig==-1)
                              ZArray=FArray; 
                        //Check: Is note included in ZArray?
                        if (ZArray.indexOf(pitchCur1%12)==-1){
                              //Check: Is interval major or minor?
                              //Change intervals
                              if (majInterv.indexOf(Math.abs(pitchDiff%12))==-1){
                                    if (pitchDiff>0)
                                          pitchDiff=pitchDiff+1;
                                    else
                                          pitchDiff=pitchDiff-1;
                              }
                              else if (minInterv.indexOf(Math.abs(pitchDiff%12))==-1){
                                    if (pitchDiff>0)
                                          pitchDiff=pitchDiff-1;
                                    else
                                          pitchDiff=pitchDiff+1;
                              }
                              //Create new note with corrected pitch      
                              crs.addNote(pitchPrev1+pitchDiff);
                              crs.prev();
                        }
                        //Change variables
                        //and move cursor               
                        pitchPrev1=crs.element.notes[0].pitch;
                        crs.staffIdx=0;
                  }
                  else{
                        
                        crs.addRest();
                        crs.staffIdx=0;
                  }
                  x=crs.next();
                  durationDenominator=crs.element.duration.denominator;
            }
      console.log("hello inversion");
      Qt.quit();
      }     
}   