
; Initializer
(def main (world something)
     (CONS 0 step))

(def step (aistate world)
     (CONS aistate (onestep world)))

(def onestep (world)
    (if (get_lm_forward world)         ; Wall forward?
      (lm_direction world)             ; No, keep going
      (right_dir (lm_direction world)))) ; Yes, turn right

(def get_lm_forward (world)
     (get_lm_in_dir world (lm_direction world)))

(def get_lm_in_dir (world dir)
     (get_in_dir
        (world_map world) (lm_x world) (lm_y world) dir))


INCLUDE "bot/lib/lang.lisp"
INCLUDE "bot/lib/world.lisp"
INCLUDE "bot/lib/dir.lisp"
INCLUDE "bot/lib/map.lisp"

