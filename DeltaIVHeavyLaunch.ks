// initialization
RUNONCEPATH("LaunchGuidance/StagingTrigger.ks", 2).
RUNONCEPATH("LaunchGuidance/PitchControl.ks").

FUNCTION LimitThrust {
    PARAMETER engine_tag.
    PARAMETER thrust_level.

    LIST ENGINES IN engs.
    for eng in engs {
        if eng:TAG = engine_tag {
            SET eng:THRUSTLIMIT TO thrust_level.
        }
    }
}

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

WAIT UNTIL SHIP:ALTITUDE > 1500.
PRINT "Initiating gravity turn...".

set_pitch_rate(0.439, 90).

WAIT UNTIL mission_time:SECONDS >= 47.
LimitThrust("core", 54.5).
PRINT "Core engine entering partial thrust mode.".

WAIT UNTIL mission_time:SECONDS >= 235.
LimitThrust("booster", 54.5). // booster low thrust mode
PRINT "Booster engines entering partial thrust mode.".

set_pitch_rate(0, 0, TRUE).

WAIT UNTIL mission_time:SECONDS > 245.
STAGE.
PRINT " ".
PRINT "Sparating boosters.".

LimitThrust("core", 100).
PRINT "Core engine entering full thrust mode.".

WAIT UNTIL mission_time:SECONDS > 300.
STAGE.
PRINT "Separating fairings.".

circularize().
