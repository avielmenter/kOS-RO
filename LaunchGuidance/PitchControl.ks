FUNCTION get_prograde_bearing {  // projects prograde vector onto compass to find its bearing
    SET eastv TO HEADING(90, 0):VECTOR.
    SET northv TO HEADING(0, 0):VECTOR.

    SET pro_east TO VDOT(SHIP:PROGRADE:VECTOR, eastv) * eastv.
    SET pro_north TO VDOT(SHIP:PROGRADE:VECTOR, northv) * northv.

    SET pro_compass TO pro_east + pro_north.
    RETURN VANG(northv, pro_compass).
}

FUNCTION set_pitch_rate {   // turns the rocket over at a fixed rate in degrees per second
    PARAMETER dps.                      // degrees per second to pitch over
    PARAMETER start_pitch.              // degrees above the horizon at the start of turn
    PARAMETER lock_prograde IS FALSE.   // lock rocket to prograde bearing?

    SET start_time TO time.
    LOCK t TO time - start_time.

    IF lock_prograde {
        LOCK h TO get_prograde_bearing() - 90.
    } ELSE {
        LOCK h TO 0.
    }

    LOCK STEERING TO HEADING(h, 90) * R(0, (90 - start_pitch) + dps * t:SECONDS, 0).
}

FUNCTION hold_altitude { // PID controller to maintain vertical speed of 0 by controlling pitch
    PARAMETER cutoff IS { RETURN FALSE. }.

    PARAMETER min_pitch IS -10.
    PARAMETER max_pitch IS 30.

    PARAMETER Kp IS 1.
    PARAMETER Ki IS .1.
    PARAMETER Kd IS 1.

    SET start_vspeed TO SHIP:VERTICALSPEED.

    SET pid TO PIDLOOP(Kp, Ki, Kd, min_pitch, max_pitch).
    SET pid:SETPOINT TO SHIP:VERTICALSPEED.

    LOCK h TO get_prograde_bearing() - 90.
    LOCK p TO 90 - pid:UPDATE(time:SECONDS, SHIP:VERTICALSPEED).

    LOCK STEERING TO HEADING(h, 90) * R(0, p, 0).

    UNTIL pid:SETPOINT <= 0 OR cutoff() { // I'd prefer to just LOCK pid:SETPOINT, but kOS doesn't support locking of struct members
        WAIT 1.
        SET pid:SETPOINT TO pid:SETPOINT - 1.
    }

    SET pid:SETPOINT to 0.
}
