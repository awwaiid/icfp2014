
; Initializer
(def main (world something)
     (CONS 0 step))

; return a state, dir
(def step (aistate world)
     (onestep world aistate))
; Keep moving forward
; When we have a choice, choose wisely
; return a dir
(def onestep (world aistate)     
     (if (length aistate)
        (CONS (CDR aistate) (loc_to_loc_dir (lm_loc world) (CAR aistate))) ; then
        (state_helper (get_bfs world) world)) ; else
)

(def state_helper (path world)
    (CONS (CDR path) (loc_to_loc_dir (lm_loc world) (CAR path) )))

;(def best_loc (world)
;    (if (CEQ (choice_count world) 0)
;        (lm_backward_dir world)
;            (if (CEQ (choice_count world) 1)
;                (only_choice world)
;                (loc_to_loc_dir (lm_loc world) (best_choice world) )))
;)

(def get_bfs (world)
    (CDR (bfs (world_map world) (lm_loc world) target_loc)))
(def only_choice (world)
     (CAR (choices world)))
; Unwrap the min choice, and from that unwrap the actual choice (direction)
; returns a loc
(def best_choice (world)
    (if (have_adjacent_pill world)
        (CAR (adjacent_pills world))
        (cadr (bfs (world_map world) (lm_loc world) target_loc))))

(def target_loc (loc)
    (is_any_pill loc))

; Turn choices (directions) into a list of [ (x,y), direction ]
(def choices_loc (world)
     (map2 (choices world) choice_loc world))

(def choice_loc (world choice)
     (get_dir_loc (world_map world) (lm_x world) (lm_y world) choice))

; Find the distance between each available choice and our goal
; dist = integer
; loc = (x,y), content
; @return list(list(dist,loc)
; @param destination = loc
(def choices_dist (world destination_loc)
     (loc_list_xy_dist manhattan_dist (choices_loc world) destination_loc))

(def min_choice_dist (choice_dists)
     (min_choice_dist_rec choice_dists (CONS 999999999 0)))

(def min_choice_dist_rec (choice_dists best)
     (tif (ATOM choice_dists)
       (return best)
       (tif (CGT (CAR (CAR choice_dists)) (CAR best))
         (tailcall min_choice_dist_rec (CDR choice_dists) best)
         (tailcall min_choice_dist_rec (CDR choice_dists) (CAR choice_dists)))))

(def adjacent_pills (world)
    (filter (adjacent_locs (world_map world) (lm_x world) (lm_y world)) is_pill))

(def have_adjacent_pill (world)
    (length (adjacent_pills world)))

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

(def xy_to_loc (xy world)
    (CONS xy (getxy (world_map world) (CAR xy) (CDR xy))))

(def first_pill_xy_north (world)
    (CAR (first_pill_north world)))
(def first_pill_xy_south (world)
    (CAR (first_pill_south world)))
(def first_pill (world)
     (CAR (pill_locs (world_map world))))

(def first_pill_north (world)
     (CAR (pill_locs_north world)))

(def first_pill_south (world)
     (CAR (pill_locs_south world)))

(def pill_locs (worldmap)
    (filter (to_loc_list worldmap) is_any_pill))

(def pill_locs_north (world)
    (filter (north_locs (to_loc_list (world_map world)) (lm_loc world)) is_any_pill))

(def pill_locs_south (world)
    (filter (south_locs (to_loc_list (world_map world)) (lm_loc world)) is_any_pill))

(def is_pill (map_location)
     (CEQ (loc_content map_location) (pill)))

(def is_power_pill (map_location)
     (CEQ (loc_content map_location) (power_pill)))

(def is_fruit (map_location)
     (CEQ (loc_content map_location) (fruit)))

(def is_any_pill (map_location)
     (or (is_power_pill map_location) (is_pill map_location)))
        ;(or (is_fruit map_location))))
        
(def north_locs (loc_list my_loc)
     (filter2 loc_list is_loc_north my_loc)) 

(def is_loc_north (my_loc loc)
     (CGTE (loc_y my_loc) (loc_y loc)))

(def south_locs (loc_list my_loc)
    (filter2 (reverse loc_list) is_loc_south my_loc))

(def is_loc_south (my_loc loc)
    (CGTE (loc_y loc) (loc_y my_loc)))

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
(def lm_is_north (world)
     (CGT (world_middle_height world) (lm_y world)))

; Delicious Libraries
; -------------------

INCLUDE "bot/lib/lang.lisp"
INCLUDE "bot/lib/map.lisp"
INCLUDE "bot/lib/dir.lisp"
INCLUDE "bot/lib/world.lisp"
INCLUDE "bot/lib/bfs.lisp"
