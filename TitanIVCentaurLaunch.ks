// initialization
RUNONCEPATH("LaunchGuidance/StagingTriggerUllage.ks", 4, 2).
RUNONCEPATH("LaunchGuidance/PitchControl.ks").

CLEARSCREEN.

PRINT "Initiating launch sequence...".
PRINT "Throttling up...".

LOCK STEERING TO HEADING(0,90).
LOCK THROTTLE TO 1.

WAIT 2.
STAGE.
increment_stage().

PRINT "Liftoff!".

// start mission timer
SET mission_start TO time.
LOCK mission_time TO time - mission_start.

WAIT UNTIL SHIP:ALTITUDE > 1500. // 21 seconds
PRINT "Initiating gravity turn...".
set_pitch_rate(.606, 90).

WAIT UNTIL mission_time:SECONDS > 115.
STAGE.
PRINT "Igniting main engine.".

WAIT UNTIL mission_time:SECONDS > 120.
STAGE.
PRINT "Booster separation".
PRINT " ".
increment_stage().

set_pitch_rate(.105, 30, TRUE).

WAIT UNTIL mission_time:SECONDS > 220.
STAGE.
PRINT "Separating fairings.".

WAIT UNTIL get_curr_stage() >= 3.
set_pitch_rate(.03, 20, TRUE).

WAIT UNTIL get_curr_stage() >= 4.
set_pitch_rate(.05, 16, TRUE).

circularize().
