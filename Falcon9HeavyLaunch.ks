// initialization
RUNONCEPATH("LaunchGuidance/StagingTriggerUllage.ks", 2, 1).
RUNONCEPATH("LaunchGuidance/PitchControl.ks").

CLEARSCREEN.

PRINT "Initiating launch sequence...".
PRINT "Throttling up...".

LOCK STEERING TO HEADING(0,90).
LOCK THROTTLE TO 1.

WAIT 2.
STAGE.
WAIT 4.5.
STAGE.
increment_stage().

PRINT "Liftoff!".

// start mission timer
SET mission_start TO time.
LOCK mission_time TO time - mission_start.

WAIT UNTIL SHIP:ALTITUDE > 1500. // 21 seconds
PRINT "Initiating gravity turn...".
set_pitch_rate(0.747, 90).

WAIT UNTIL mission_time:SECONDS > 108.
STAGE.
PRINT "Boosters separation.".
PRINT " ".

set_pitch_rate(.245, 25, TRUE).

WAIT UNTIL mission_time:SECONDS > 210.
set_pitch_rate(0, 0, TRUE).

WAIT UNTIL get_curr_stage() >= 2.
WAIT 10.
STAGE.
PRINT "Separating fairings.".

circularize().
