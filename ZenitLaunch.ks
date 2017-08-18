PARAMETER max_stage IS 2. // 2 for Zenit 2, 3 for Zenit 3SL

// initialization
RUNONCEPATH("LaunchGuidance/StagingTrigger.ks", max_stage).
RUNONCEPATH("LaunchGuidance/PitchControl.ks").

CLEARSCREEN.

PRINT "Initiating launch sequence...".
PRINT "Throttling up...".

LOCK STEERING TO HEADING(0,90).
LOCK THROTTLE TO 1.

WAIT 4.25.

PRINT "Liftoff!".
STAGE.

// start mission timer
SET mission_start TO time.
LOCK mission_time TO time - mission_start.

WAIT UNTIL SHIP:ALTITUDE > 1500. // 21 seconds
PRINT "Initiating gravity turn...".

set_pitch_rate(.701, 90).

WAIT UNTIL get_curr_stage() >= 2.
set_pitch_rate(.111, 10, TRUE).

WAIT 20.
STAGE.
PRINT "Separating fairings.".

WAIT UNTIL mission_time:SECONDS > 225.
set_pitch_rate(0, 0, TRUE).

circularize().
