FUNCTION get_prograde_bearing {  // projects prograde vector onto compass to find its bearing
    SET eastv TO HEADING(90, 0):VECTOR.
    SET northv TO HEADING(0, 0):VECTOR.

    SET pro_east TO VDOT(SHIP:PROGRADE:VECTOR, eastv) * eastv.
    SET pro_north TO VDOT(SHIP:PROGRADE:VECTOR, northv) * northv.

    SET pro_compass TO pro_east + pro_north.
    RETURN VANG(northv, pro_compass).
}

FUNCTION set_pitch_rate {
    PARAMETER dps. // degrees per second to pitch over
    PARAMETER start_pitch. // degrees above the horizon
    PARAMETER lock_prograde IS 0. // bearing

    SET start_time TO time.
    LOCK t TO time - start_time.

    IF lock_prograde > 0 {
        LOCK h TO get_prograde_bearing() - 90.
    } ELSE {
        LOCK h TO 0.
    }

    LOCK STEERING TO HEADING(h, 90) * R(0, (90 - start_pitch) + dps * t:SECONDS, 0).
}

FUNCTION hold_altitude {
    PARAMETER Kp IS .4.
    PARAMETER Ki IS .1.
    PARAMETER Kd IS 1.5.

    PARAMETER MIN_PITCH IS -10.
    PARAMETER MAX_PITCH IS 30.

    SET pid TO PIDLOOP(Kp, Ki, Kd, MIN_PITCH, MAX_PITCH).
    SET pid:SETPOINT TO 0.

    LOCK h TO get_prograde_bearing() - 90.
    LOCK p TO 90 - pid:UPDATE(time:SECONDS, SHIP:VERTICALSPEED).

    LOCK STEERING TO HEADING(h, 90) * R(0, p, 0).
}

FUNCTION end_guidance {
    PARAMETER max_ap IS 300000.

    WAIT UNTIL SHIP:PATCHES[0]:PERIAPSIS > .975 * SHIP:ALTITUDE OR SHIP:PATCHES[0]:APOAPSIS > max_ap.

    PRINT "Ending launch guidance.".
    LOCK THROTTLE TO 0.
    WAIT 3.
    UNLOCK THROTTLE.
    UNLOCK STEERING.
    WAIT 3.
}
