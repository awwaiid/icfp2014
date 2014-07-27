
; Initializer
(def main (world something)
     (CONS 0 step))

(def step (aistate world)
     (CONS 0 (onestep world)))

(def onestep (world)
     (if (CEQ (choice_count world) 0)
       (lm_backward_dir world)
       (if (CEQ (choice_count world) 1)
         (only_choice world)
         (decide world))))

(def only_choice (world)
     (CAR (choices world)))

(def decide (world)
     (DBUG 20000)
     (DBUG (lm_location world))
     (DBUG (first_pill (world_map world)))
     (DBUG 20001)
     (DBUG (choices world))
     (DBUG 20002)
     (DBUG (choices_loc world))
     (DBUG 20003)
     (DBUG (choices_dist world))
     (DBUG 20004)
     (DBUG (best_choice world))
     (DBUG 20005)
     (DBUG (CDR (CDR (best_choice world))))
     (DBUG 20006)
     (CDR (CDR (best_choice world))))
     ; (only_choice world))
     ; (direction_of (best_choice world)))

(def first_pill (worldmap)
     (CAR (pill_locs worldmap)))

(def pill_locs (worldmap)
  (filter (to_loc_list worldmap) is_pill))

(def is_pill (map_location)
     (CEQ (loc_content map_location) (power_pill)))


; Choice: (direction x y)

; (def best_choice (world)
     ; (smallest_distance_to (choices world) (first_pill world)))

; (def smallest_distance_to (list pill_xy)


(def choices (world)
     (maybe_left world (maybe_forward world (maybe_right world 0))))
     ; (maybe_backward world (maybe_left world (maybe_forward world (maybe_right world 0)))))
     ; (maybe_forward world (maybe_right world 0)))

(def choices_loc (world)
     (map_partial (choices world) (partial choice_loc_world (CONS world 0))))

; Unwrap the world partial
(def choice_loc_world (args)
     (choice_loc (CAR (CDR args)) (CAR args)))

(def choice_loc (world choice)
     (get_dir_loc (world_map world) (lm_x world) (lm_y world) choice))

(def choices_dist (world)
     (loc_list_xy_dist (choices_loc world) (CAR (first_pill (world_map world)))))

(def min_choice_dist (choice_dists best)
     (if (ATOM choice_dists)
       best
       (if (CGT (CAR (CAR choice_dists)) (CAR best))
         (min_choice_dist (CDR choice_dists) best)
         (min_choice_dist (CDR choice_dists) (CAR choice_dists)))))

(def best_choice (world)
     (min_choice_dist (choices_dist world) (CONS 999999999 0)))


(def maybe_left (world others)
     (if (is_option world (lm_left_dir world))
       (CONS (lm_left_dir world) others)
       others))

(def maybe_forward (world others)
     (if (is_option world (lm_forward_dir world))
       (CONS (lm_forward_dir world) others)
       others))

(def maybe_right (world others)
     (if (is_option world (lm_right_dir world))
       (CONS (lm_right_dir world) others)
       others))

(def maybe_backward (world others)
     (if (is_option world (lm_backward_dir world))
       (CONS (lm_backward_dir world) others)
       others))

(def choice_count (world)
     (length (choices world)))

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


INCLUDE "bot/lib/lang.lisp"
INCLUDE "bot/lib/map.lisp"
INCLUDE "bot/lib/dir.lisp"
INCLUDE "bot/lib/world.lisp"

