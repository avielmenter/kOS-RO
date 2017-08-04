RUNONCEPATH("LaunchGuidance/PitchControl.ks").
RUNONCEPATH("LaunchGuidance/StagingTriggerUllage.ks", 2, 1).

CLEARSCREEN.

PRINT "Initiating launch sequence...".
PRINT "Throttling up...".

LOCK STEERING TO HEADING(0, 90).
LOCK THROTTLE TO 1.

WAIT 2.
STAGE.
WAIT 4.
STAGE.
increment_stage().

PRINT "Liftoff!".
PRINT " ".

SET mission_start TO TIME.
LOCK mission_time TO TIME - mission_start.

WAIT UNTIL SHIP:ALTITUDE > 1500.
PRINT "Initiating gravity turn...".

set_pitch_rate(.81, 90).

WAIT UNTIL mission_time:SECONDS > 95.
set_pitch_rate(.24, 30, TRUE).
STAGE.

PRINT "Booster separation.".

WAIT UNTIL mission_time:SECONDS > 215.
set_pitch_rate(0, 0, TRUE).

WAIT UNTIL mission_time:SECONDS > 223.
LOCK THROTTLE TO 0.5. // cap acceleration on core stage

WAIT UNTIL curr_stage = 2.
LOCK THROTTLE TO 1.

WAIT 20.
WAIT UNTIL SHIP:ALTITUDE > 140000.
STAGE. // separate fairings
set_pitch_rate(.05, 0, TRUE).

circularize().
