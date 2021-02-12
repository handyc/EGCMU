


EGCMU is an Electronic Gene Creation/Manipulation Utility.
It allows the user to design electronic "organisms" which can then be
interpreted as sounds and images.

EGCMU may be freely distributed, but may not be sold without written permission
from the author, Christopher Handy.  Christopher Handy can be reached at this
address: <chandy@cs.siu.edu>


.......................................................................................


Using EGCMU:


The EGCMU screen is divided into a Parent section and a Child section:

---------------------------------------------------------------------------------------
The Parent section displays information on the parent gene.

[Gene A] window   : This window displays the textual genetic data of the parent gene.
                   (EGCMU currently uses only one gene for each electronic "organism".
                    Future versions may include multiple genes for each organism.) 

-Set as Parent    : This button sets whatever is in the parent box as the new parent and
                    breeds new children.  This is useful for inputting new genetic data
                    manually.

|> (Play)         : This button plays the parent gene data through a MIDI device.
|| (Pause)        : This button pauses MIDI playback.
[] (Stop)         : This button stops MIDI playback.
<< (Rewind)       : This button steps backward during MIDI playback.
>> (Fast Forward) : This button steps forward during MIDI playback.


---------------------------------------------------------------------------------------
The Child section displays information on the child genes.

[Child] X [of] Y windows: This area tells the user which gene (X) is being displayed,
                          of a total (Y) child genes.   

[Gene A] window   : This window displays the textual genetic data of the current
                    child gene.
                   (EGCMU currently uses only one gene for each electronic "organism".
                    Future versions may include multiple genes for each organism.) 

-Set as Parent    : This button sets whatever is in the child data box as the new
parent and breeds new children.  By selecting favored offspring, the user can manipulate
the genetic data to create a desired organism. 

|> (Play)         : This button plays the current child gene data through a MIDI device.
|| (Pause)        : This button pauses MIDI playback.
[] (Stop)         : This button stops MIDI playback.
<< (Rewind)       : This button steps backward during MIDI playback.
>> (Fast Forward) : This button steps forward during MIDI playback.

< (Previous Child): This button steps backward through the current child genes.
> (Next Child)    : This button steps forward through the current child genes.

Graphics Window   : This window graphically displays the structure of the current
                    child gene.


---------------------------------------------------------------------------------------

Sticky-play       : Normally, a gene stops playing when the "<" or ">" buttons are
                    clicked.  The sticky-play checkbox allows a user to continue
                    playing a gene while browsing the child genes. 

About             : This button gives information about the program.


.......................................................................................

Sample Session:

Here is a sample session to help demonstrate the features of EGCMU.

1) When the program starts, genetic data is displayed in the "Gene A" box in the Parent
   section of the screen, as well as in the "Gene A" box in the Child section.
   At this point, all child genes contain the same data as the parent gene.

2) Click the "Play" button ( |> ) in the Parent section.
   You should hear music playing (a variation on Bach's Invention #2).

3) Click the "Stop" button ( [] ) in the Parent section.
   The music should stop playing.

4) Click "Set as Parent" in the Child section.
   The text in the Parent section will remain the same, as the child was exactly the
   same as the parent.
   The text in the Child section will change, as the child genes are mutated slightly.

5) Click the "Play" button in the Child section.
   You should hear music similar to that in step 2.

6) Click the "Stop" button in the Child section.
   The music should stop playing.

7) Click ">" and "<" to select the next child/previous child.  The graphics window and
   text window will change as you browse the child genes.  If you play the genes, each
   child will sound slightly different.

8) Using ">" and "<", move to the gene you like best, based on sound/image.  Click the
   "Set as Parent" button in the Child section to breed from this child.

9) The current parent will be replaced with your selection, and new child genes will be 
   created in the Child section.  Repeat steps 7 through 9.


Copyright (c) 2001 by Christopher Handy


