
; Initializer
(def main (world something)
     (CONS 0 step))

(def step (aistate world)
     (CONS 0 (onestep world)))

(def onestep (world)
    (if (get_lm_forward world) ; Wall forward?
      (lm_direction world)     ; No, keep going
      (best_direction world))) ; Yes... I guess we should do something else

(def best_direction (world)
     (if (right_is_good world)
       (inc_dir (lm_direction world))
       (dec_dir (lm_direction world))))

(def right_is_good (world)
   (is_yummy (get_lm_right world)))

(def is_yummy (thing)
     (or (CEQ thing 2)
     (or (CEQ thing 3)
         (CEQ thing 4))))

(def get_lm_right (world)
   (get_lm_in_dir world (inc_dir (lm_direction world))))

(def get_lm_forward (world)
     (get_lm_in_dir world (lm_direction world)))

(def get_lm_in_dir (world dir)
     (get_in_dir
        (world_map world) (lm_x world) (lm_y world) dir))

INCLUDE "bot/lib/lang.lisp"
INCLUDE "bot/lib/world.lisp"
INCLUDE "bot/lib/dir.lisp"
INCLUDE "bot/lib/map.lisp"

