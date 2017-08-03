// Include this file to automatically end the launch sequence
PARAMETER max_ap IS 300000.     // maximum apoapsis that a (stable) orbit can have
PARAMETER min_frac IS .975.     // fraction of current ship's altitude before engine cutoff
PARAMETER should_print IS TRUE. // print messages to the terminal?

SET end_launch TO FALSE.

WHEN (SHIP:PATCHES[0]:PERIAPSIS > min_frac * SHIP:ALTITUDE OR SHIP:PATCHES[0]:APOAPSIS > max_ap) AND SHIP:PATCHES[0]:PERIAPSIS > 140000 THEN {
    SET end_launch TO TRUE.
}

FUNCTION end_guidance {
    WAIT UNTIL end_launch.
    IF should_print { PRINT "Ending launch guidance.". }

    LOCK THROTTLE TO 0.
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

    WAIT 3.
    UNLOCK THROTTLE.
    UNLOCK STEERING.
    WAIT 3.
}

FUNCTION launch_ended {
    RETURN end_launch.
}
