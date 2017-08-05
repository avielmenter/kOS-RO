// initialization
RUNONCEPATH("LaunchGuidance/StagingTriggerUllage.ks", 3, 1).
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

WAIT UNTIL SHIP:ALTITUDE > 1500. // 18 seconds
PRINT "Initiating gravity turn...".
set_pitch_rate(.735, 90).

WAIT UNTIL mission_time:SECONDS > 120.
STAGE.
PRINT "Booster separation".
set_pitch_rate(.21, 15, TRUE).

WAIT UNTIL get_curr_stage() >= 2.
set_pitch_rate(.048, 20, TRUE).

WAIT 20.
STAGE.
PRINT "Separating fairings.".

WAIT UNTIL get_curr_stage() >= 3.
set_pitch_rate(0, 16, TRUE).

circularize().
