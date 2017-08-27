// initialization
RUNONCEPATH("LaunchGuidance/PitchControl.ks").

CLEARSCREEN.

PRINT "Initiating launch sequence...".
PRINT "Throttling up...".

LOCK STEERING TO HEADING(0,90).
LOCK THROTTLE TO 1.

STAGE.
WAIT 4.

PRINT "Liftoff!".
STAGE.

// start mission timer
SET mission_start TO time.
LOCK mission_time TO time - mission_start.

WAIT UNTIL SHIP:ALTITUDE > 1500.
PRINT "Initiating gravity turn...".

set_pitch_rate(.67, 90).

WAIT UNTIL mission_time:SECONDS > 123.
STAGE.
PRINT " ".
PRINT "Booster separation.".

set_pitch_rate(.13, 25, TRUE).

WAIT UNTIL mission_time:SECONDS > 161.
AG10 ON. // eject launch escape tower

WAIT UNTIL SHIP:MAXTHRUST = 0.
STAGE.
PRINT " ".
PRINT "Core stage separation.".

set_pitch_rate(.05, 17.5, TRUE).

circularize().
