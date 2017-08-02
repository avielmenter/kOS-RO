PARAMETER max_ap IS 300000.
PARAMETER min_frac IS .975.
PARAMETER should_print IS TRUE.

SET end_launch TO FALSE.

WHEN SHIP:PATCHES[0]:PERIAPSIS > min_frac * SHIP:ALTITUDE OR (SHIP:PATCHES[0]:APOAPSIS > max_ap AND SHIP:PATCHES[0]:PERIAPSIS > 140000) THEN {
    SET end_launch TO TRUE.
}

FUNCTION end_guidance {
    WAIT UNTIL end_launch.
    IF should_print { PRINT "Ending launch guidance.". }

    LOCK THROTTLE TO 0.

    WAIT 3.
    UNLOCK THROTTLE.
    UNLOCK STEERING.
    WAIT 3.
}

FUNCTION launch_ended {
    RETURN end_launch.
}
