RUNONCEPATH("LaunchGuidance/PitchControl.ks").

CLEARSCREEN.

PRINT "Initiating launch sequence...".
PRINT "Throttling up...".

LOCK STEERING TO HEADING(0, 90).
LOCK THROTTLE TO 1.

WAIT 2.
STAGE.
WAIT 4.
STAGE.

PRINT "Liftoff!".

SET mission_start TO TIME.
LOCK mission_time TO TIME - mission_start.

WAIT UNTIL SHIP:ALTITUDE > 1500.
PRINT "Initiating gravity turn...".

set_pitch_rate(.81, 90).

WAIT UNTIL mission_time:SECONDS > 95.
set_pitch_rate(.27, 30, 1).
STAGE.

PRINT "Booster separation.".
RUNONCEPATH("LaunchGuidance/StagingTriggerUllage.ks", 2, 1).

WAIT UNTIL mission_time:SECONDS > 205.
set_pitch_rate(0, 0, 1).

WAIT UNTIL mission_time:SECONDS > 223.
LOCK THROTTLE TO 0.5. // lower acceleration on last fuel of core stage.

WAIT UNTIL curr_stage = 2.
LOCK THROTTLE TO 1.

WAIT 20.
WAIT UNTIL SHIP:ALTITUDE > 140000.
STAGE. // separate fairings

WAIT UNTIL SHIP:VERTICALSPEED < 10.
PRINT "Circularizing...".
hold_altitude().

end_guidance().
