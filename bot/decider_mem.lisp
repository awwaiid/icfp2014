
; Initializer
(def main (world something)
     (CONS 0 step))

(def step (aistate world)
     (CONS
       (CONS (lm_location) aistate)
       (onestep world aistate)))

; Keep moving forward
; When we have a choice, choose wisely
(def onestep (world xy_history)
     (if (CEQ (choice_count world) 0)
       (lm_backward_dir world)
       (if (CEQ (choice_count world) 1)
         (only_choice world)
         (best_choice world xy_history))))

(def only_choice (world)
     (CAR (choices world)))

; Unwrap the min choice, and from that unwrap the actual choice (direction)
(def best_choice (world)
     (CDR (CDR (min_choice_dist (choices_dist world (first_pill_xy world))))))

; Sorry about the partial stuff
; Turn choices (directions) into a list of [ (x,y), direction ]
(def choices_loc (world)
     (map_partial (choices world) (partial choice_loc_world (CONS world 0))))

; Unwrap the world partial (world, choice)
(def choice_loc_world (args)
     (choice_loc (CAR (CDR args)) (CAR args)))

(def choice_loc (world choice)
     (get_dir_loc (world_map world) (lm_x world) (lm_y world) choice))

; Find the distance between each available choice and our goal
(def choices_dist (world destination)
     (loc_list_xy_dist manhattan_dist (choices_loc world) (CAR (first_pill (world_map world)))))

(def min_choice_dist (choice_dists xy_history)
     (min_choice_dist_rec xy_history choice_dists (CONS 999999999 0)))

(def min_choice_dist_rec (xy_history choice_dists best)
     (if (ATOM choice_dists)
       best
       (if (CGT (CAR (CAR choice_dists)) (CAR best))
         (min_choice_dist_rec (CDR choice_dists) best)
         (min_choice_dist_rec (CDR choice_dists) (CAR choice_dists)))))

(def weighted_dist (choice_dist xy_history)
     (filter xy_history (partial p_xy_eq (CAR (CDR choice_dist))))

(def p_xy_eq (args) (curry2 xy_eq args))

; awwaiid: I don't like this maybe_ blah blah
(def choices (world)
     (maybe_left world (maybe_forward world (maybe_right world 0))))

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

; Pill Finder
; -----------

(def first_pill_xy (world)
     (CAR (first_pill (world_map world))))

(def first_pill (worldmap)
     (CAR (pill_locs worldmap)))

(def pill_locs (worldmap)
  (filter (to_loc_list worldmap) is_pill))

(def is_pill (map_location)
     (CEQ (loc_content map_location) (power_pill)))


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

; Delicious Libraries
; -------------------

INCLUDE "bot/lib/lang.lisp"
INCLUDE "bot/lib/map.lisp"
INCLUDE "bot/lib/dir.lisp"
INCLUDE "bot/lib/world.lisp"

