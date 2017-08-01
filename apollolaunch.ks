SET curr_stage TO 0.
SET stage_start TO time.

FUNCTION set_pitch_rate {
    PARAMETER dps. // degrees per second to pitch over
    PARAMETER start_pitch. // degrees above the horizon
    PARAMETER lock_prograde IS 0. // bearing

    SET eastv TO HEADING(90, 0):VECTOR.
    SET northv TO HEADING(0, 0):VECTOR.

    SET start_time TO time.
    LOCK t TO time - start_time.

    IF lock_prograde > 0 {
        LOCK pro_east TO VDOT(SHIP:PROGRADE:VECTOR, eastv) * eastv.
        LOCK pro_north TO VDOT(SHIP:PROGRADE:VECTOR, northv) * northv.

        LOCK pro_compass TO pro_east + pro_north.
        LOCK h TO VANG(northv, pro_compass).
    } ELSE {
        LOCK h TO 90.
    }

    LOCK STEERING TO HEADING(0, h) * R(0, (90 - start_pitch) + dps * t:SECONDS, 0).
}

PRINT "Initiating launch sequence...".
PRINT " ".

STAGE.
LOCK STEERING TO HEADING(SHIP:GEOPOSITION:LAT, 90).
LOCK THROTTLE TO 1.
WAIT 5.

STAGE.
PRINT "Firing engines...".

WAIT 5.5.
STAGE.
SET curr_stage TO 1.
PRINT "Liftoff!".

SET mission_start TO time.
LOCK mission_time TO time - mission_start.

// staging trigger
WHEN SHIP:MAXTHRUST = 0 THEN {
    STAGE.
    SET stage_start TO time.

    PRINT " ".
    PRINT "Stage " + curr_stage + " separation.".
    PRINT "Firing ullage motors...".
    WAIT 1.

    STAGE.
    PRINT "Igniting engines.".
    WAIT 5.

    STAGE.
    PRINT "Separating interstage fairing.".

    SET curr_stage TO curr_stage + 1.

    PRINT "Now on stage " + curr_stage.

    IF curr_stage < 3 {
        PRESERVE.
    }
}.

WAIT UNTIL SHIP:ALTITUDE > 1500.
PRINT "Initiating gravity turn...".
set_pitch_rate(0.5, 90).

WAIT UNTIL mission_time:SECONDS > 135.
AG1 ON. // center engine cutoff

WAIT UNTIL curr_stage = 2.
set_pitch_rate(0, 25, 1).

WAIT UNTIL mission_time:SECONDS > 198.
AG10 ON. // eject launch escape tower

WAIT UNTIL mission_time:SECONDS > 461.
set_pitch_rate(.1666, 25, 1).
