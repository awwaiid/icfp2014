
; Initializer
(def main (world something)
     (CONS 0 step))

; (def step (aistate world)
    ; (if (get_lm_left world)
      ; (CONS 0 3)
      ; (if (get_lm_above world)
        ; (CONS 0 0)
        ; (if (get_lm_right world)
          ; (CONS 0 1)
          ; (CONS 0 2)))))

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
   (is_yummy (to_lm_right world)))

(def to_lm_right (world)
   (get_lm_in_dir world (inc_dir (lm_direction world))))

(def is_yummy (thing)
     (or (CEQ thing 2)
         (or (CEQ thing 3)
             (CEQ thing 4))))

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

(def lm_direction (world)
     (CAR (CDR (CDR (lm_status world)))))

(def get_in_dir (matrix x y dir)
     (if (CEQ dir 0)
       (get_above matrix x y)
       (if (CEQ dir 1)
         (get_right matrix x y)
         (if (CEQ dir 2)
           (get_below matrix x y)
           (get_left  matrix x y)))))

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


(def get_lm_above (world)
     (get_above  (world_map world) (lm_x world) (lm_y world)))
(def get_above (matrix x y)
  (getxy matrix x (SUB y 1)))

(def get_lm_below (world)
     (get_below  (world_map world) (lm_x world) (lm_y world)))
(def get_below (matrix x y)
  (getxy matrix x (ADD y 1)))

(def get_lm_right (world)
     (get_right  (world_map world) (lm_x world) (lm_y world)))
(def get_right (matrix x y)
  (getxy matrix (ADD x 1) y ))

(def get_lm_left (world)
     (get_left  (world_map world) (lm_x world) (lm_y world)))
(def get_left (matrix x y)
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

(def nth (list n)
  (if n
    (nth (CDR list) (SUB n 1))
    (CAR list))) 

(def getxy (matrix x y)
  (nth (nth matrix y) x))

; (def map (list f)
     ; (if list
       ; (CONS (f (CAR list)) (map (CDR list) f))
       ; list))

