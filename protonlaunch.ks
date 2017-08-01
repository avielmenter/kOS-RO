// initialization
SET curr_stage TO 0.
SET stage_start TO time.

CLEARSCREEN.

// staging trigger
WHEN SHIP:MAXTHRUST = 0 THEN {
    STAGE.
    SET stage_start TO time.

    PRINT " ".
    PRINT "Stage " + curr_stage + " separation.".

    SET curr_stage TO curr_stage + 1.

    PRINT "Now on stage " + curr_stage.

    IF curr_stage < 3 {
        PRESERVE.
    }
}.

FUNCTION set_pitch_rate {
    PARAMETER dps. // degrees per second to pitch over
    PARAMETER start_pitch. // degrees above the horizon
    PARAMETER lock_prograde IS 0. // bearing

    SET start_time TO time.
    LOCK t TO time - start_time.

    IF lock_prograde > 0 { // projects prograde vector onto compass to find its bearing
        LOCK eastv TO HEADING(90, 0):VECTOR.
        LOCK northv TO HEADING(0, 0):VECTOR.

        LOCK pro_east TO VDOT(SHIP:PROGRADE:VECTOR, eastv) * eastv.
        LOCK pro_north TO VDOT(SHIP:PROGRADE:VECTOR, northv) * northv.

        LOCK pro_compass TO pro_east + pro_north.
        LOCK h TO VANG(northv, pro_compass) - 90.
    } ELSE {
        LOCK h TO 0.
    }

    LOCK STEERING TO HEADING(h, 90) * R(0, (90 - start_pitch) + dps * t:SECONDS, 0).
}

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

WAIT UNTIL SHIP:PATCHES[0]:PERIAPSIS > 195000 OR SHIP:PATCHES[0]:APOAPSIS > 300000.
LOCK THROTTLE TO 0.

WAIT 5.

UNLOCK THROTTLE.
SET THROTTLE TO 0.
PRINT "Ending launch guidance.".
