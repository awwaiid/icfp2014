
; Initializer
(def main (world something)
     (CONS 0 step))

(def step (aistate world)
     (CONS 0 (onestep world)))

(def onestep (world)
     (if (CEQ (choice_count world) 0)
       (backward_dir world)
       (if (CEQ (choice_count world) 1)
         (only_choice world)
         (decide world))))

(def only_choice (world)
     (if (is_option world (left_dir world))
       (left_dir world)
       (if (is_option world (right_dir world))
         (right_dir world)
         (forward_dir world))))

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
     (if (is_option world (left_dir world))
       (CONS (left_choice world) others)))

(def maybe_forward (world others)
     (if (is_option world (forward_dir world))
       (CONS (forward_choice world) others)))

(def maybe_right (world others)
     (if (is_option world (right_dir world))
       (CONS (right_choice world) others)))

(def left_choice (world)


(def choice_count (world)
     (ADD (is_option world (left_dir world))
          (ADD (is_option world (forward_dir world))
               (is_option world (right_dir world)))))

(def is_option (world dir)
     (not (CEQ (get_lm_in_dir world dir) (wall))))

; Map constants
; -------------

(def wall       () 0)
(def pill       () 1)
(def power_pill () 2)


; Functions to work with relative direction
; -----------------------------------------

(def left_dir (world)
     (dec_dir (lm_direction world)))

(def right_dir (world)
     (inc_dir (lm_direction world)))

(def forward_dir (world)
     (lm_direction world))

(def backward_dir (world)
     (inc_dir (inc_dir (lm_direction world))))

(def get_in_dir (matrix x y dir)
     (if (CEQ dir 0)
       (get_north matrix x y)
       (if (CEQ dir 1)
         (get_east matrix x y)
         (if (CEQ dir 2)
           (get_south matrix x y)
           (get_west  matrix x y)))))

(def inc_dir (dir)
     (if (CEQ dir 0)
       1
       (if (CEQ dir 1)
         2
         (if (CEQ dir 2)
           3
           0))))

(def dec_dir (dir)
     (if (CEQ dir 0)
       3
       (if (CEQ dir 1)
         0
         (if (CEQ dir 2)
           1
           2))))

(def world_map (world)
     (CAR world))

(def lm_status (world)
     (CAR (CDR world)))

(def lm_location (world)
     (CAR (CDR (lm_status world))))

(def lm_x (world)
     (CAR (lm_location world)))

(def lm_y (world)
     (CDR (lm_location world)))

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
(def get_north (matrix x y)
  (getxy matrix x (SUB y 1)))

(def get_lm_south (world)
     (get_south  (world_map world) (lm_x world) (lm_y world)))
(def get_south (matrix x y)
  (getxy matrix x (ADD y 1)))

(def get_lm_east (world)
     (get_east  (world_map world) (lm_x world) (lm_y world)))
(def get_east (matrix x y)
  (getxy matrix (ADD x 1) y ))

(def get_lm_west (world)
     (get_west  (world_map world) (lm_x world) (lm_y world)))
(def get_west (matrix x y)
  (getxy matrix (SUB x 1) y ))

; Language utilities
; ------------------

(def debug (n)
   (DBUG n)
   n)

(def and (a b)
     (if a b a))

(def or (a b)
     (if a a b))

(def not (a)
     (if a 0 1))

(def nth (list n)
  (if n
    (nth (CDR list) (SUB n 1))
    (CAR list))) 

(def length (list)
  (if (ATOM list)
    0
    (ADD 1 (length (CDR list)))))

(def getxy (matrix x y)
  (nth (nth matrix y) x))

(def map (list f1)
     (if (ATOM list)
       list
       (CONS (f1 (CAR list)) (map (CDR list) f1))))

(def grep (list f1)
     (if (ATOM list)
       list
       (if (f1 (CAR list))
         (CONS (f1 (CAR list)) (grep (CDR list) f1))
         (grep (CDR list) f1))))


