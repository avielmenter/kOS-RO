// initialization
RUNONCEPATH("LaunchGuidance/StagingTrigger.ks", 3).
RUNONCEPATH("LaunchGuidance/PitchControl.ks").

CLEARSCREEN.

PRINT "Initiating launch sequence...".
PRINT "Throttling up...".

LOCK THROTTLE TO 1.
WAIT 4.25.

PRINT "Liftoff!".
STAGE.

LOCK STEERING TO HEADING(0,90).

// start mission timer
SET mission_start TO time.
LOCK mission_time TO time - mission_start.

WAIT UNTIL SHIP:ALTITUDE > 1500.
PRINT "Initiating gravity turn...".

set_pitch_rate(.61, 90).

WAIT UNTIL mission_time:SECONDS > 132.
set_pitch_rate(.047, 25, 1).

WAIT UNTIL curr_stage = 3.
set_pitch_rate(.14, 25, 1).

// wait a few seconds before separating fairings
WAIT 20.
WAIT UNTIL SHIP:ALTITUDE > 140000.
PRINT "Separating Fairings.".
STAGE.

WAIT UNTIL SHIP:VERTICALSPEED < 20.
PRINT "Circularizing...".
hold_altitude().

WAIT UNTIL SHIP:PATCHES[0]:PERIAPSIS > .975 * SHIP:ALTITUDE OR SHIP:PATCHES[0]:APOAPSIS > 300000.

PRINT "Ending launch guidance.".
LOCK THROTTLE TO 0.
WAIT 3.
UNLOCK THROTTLE.
UNLOCK STEERING.
WAIT 3.
