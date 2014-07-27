
; Initializer
(def main (world something)
     (CONS 0 step))

(def step (aistate world)
     (CONS 0 (flee world)))

(def flee (world)
    (if (ghost_near world) ; Wall forward?
      (inc_dir lm_direction world))     ; yes, change direction
      (lm_direction world))             ; Yes, keep going


INCLUDE "bot/lib/lang.lisp"
INCLUDE "bot/lib/world.lisp"
INCLUDE "bot/lib/dir.lisp"
INCLUDE "bot/lib/map.lisp"

