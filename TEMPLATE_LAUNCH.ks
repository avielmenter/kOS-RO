// initialization
// RUNONCEPATH("LaunchGuidance/StagingTrigger.ks", [max_stage]).
// RUNONCEPATH("LaunchGuidance/StagingTriggerUlagge.ks, [max_stage]").
RUNONCEPATH("LaunchGuidance/PitchControl.ks").

LEARSCREEN.

PRINT "Initiating launch sequence...".
PRINT "Throttling up...".

LOCK STEERING TO HEADING(0,90).
LOCK THROTTLE TO 1.

// LAUNCH SEQUENCE GOES HERE

circularize().
