
; Initializer
(def main (world something)
     (CONS 0 step))

(def step (aistate world)
     (CONS 0 (onestep world)))


(def onestep (world)
     (let (choices (lm_choices world)
           count (length choices)

       (count (choice_count world))
       (if (CEQ count 0)
         (backward_dir world)
         (if (CEQ count 1)
           

     (if (CEQ (choice_count world) 0)
       (backward_dir world)
       (if (CEQ (choice_count world) 1)
         (only_choice world)
         (decide world))))

(def onestep (world)
     (if (CEQ (choice_count world) 0)
       (backward_dir world)
       (if (CEQ (choice_count world) 1)
         (only_choice world)
         (decide world))))

(def only_choice (world)
     (if (is_option world (lm_left_dir world))
       (lm_left_dir world)
       (if (is_option world (lm_right_dir world))
         (lm_right_dir world)
         (lm_forward_dir world))))

(def decide (world)
     (direction_of (best_choice world)))

; Choice: (direction x y)

(def best_choice (world)
     (smallest_distance_to (choices world) (first_pill world)))

(def smallest_distance_to (list pill_xy)
     

(def ranked_choices (world)
     (sort

(def choices (world)
     (maybe_left world (maybe_forward world (maybe_right world 0))))

(def maybe_left (world others)
     (if (is_option world (lm_left_dir world))
       (CONS (left_choice world) others)))

(def maybe_forward (world others)
     (if (is_option world (lm_forward_dir world))
       (CONS (forward_choice world) others)))

(def maybe_right (world others)
     (if (is_option world (lm_right_dir world))
       (CONS (right_choice world) others)))

(def left_choice (world)


(def choice_count (world)
     (ADD (is_option world (left_dir world))
          (ADD (is_option world (forward_dir world))
               (is_option world (right_dir world)))))

(def is_option (world dir)
     (not (CEQ (get_lm_in_dir world dir) (wall))))


; Functions to work with relative direction
; -----------------------------------------

(def lm_left_dir (world)
     (dec_dir (lm_direction world)))

(def lm_right_dir (world)
     (inc_dir (lm_direction world)))

(def lm_forward_dir (world)
     (lm_direction world))

(def lm_backward_dir (world)
     (inc_dir (inc_dir (lm_direction world))))

(def get_lm_forward (world)
     (get_lm_in_dir world (lm_direction world)))

(def get_lm_in_dir (world dir)
     (get_in_dir
        (world_map world) (lm_x world) (lm_y world) dir))

(def lm_dir_xy (world dir)
     (get_in_dir
        (world_map world) (lm_x world) (lm_y world) dir))

(def lm_direction (world)
     (CAR (CDR (CDR (lm_status world)))))


; Cardinal directions
; -------------------

(def get_lm_north (world)
     (get_north  (world_map world) (lm_x world) (lm_y world)))

(def get_lm_south (world)
     (get_south  (world_map world) (lm_x world) (lm_y world)))

(def get_lm_east (world)
     (get_east  (world_map world) (lm_x world) (lm_y world)))

(def get_lm_west (world)
     (get_west  (world_map world) (lm_x world) (lm_y world)))


INCLUDE "bot/lib/lang.lisp"
INCLUDE "bot/lib/map.lisp"
INCLUDE "bot/lib/dir.lisp"
INCLUDE "bot/lib/world.lisp"

