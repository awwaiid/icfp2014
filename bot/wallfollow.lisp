
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
    (if (get_lm_forward world)
      (CONS 0 (lm_direction world))
      (CONS 0 (inc_dir (lm_direction world)))))

(def map (world)
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
     (get_in_dir
        (map world) (lm_x world) (lm_y world) (lm_direction world)))

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

(def debug (n)
   (DBUG n)
   n
)

(def nth (list n)
  (if n
    (nth (CDR list) (SUB n 1))
    (CAR list)
  )
) 
  
(def getxy (matrix x y)
  (nth (nth matrix y) x)
)

(def get_lm_above (world)
     (get_above  (map world) (lm_x world) (lm_y world)))
(def get_above (matrix x y)
  (getxy matrix x (SUB y 1)))

(def get_lm_below (world)
     (get_below  (map world) (lm_x world) (lm_y world)))
(def get_below (matrix x y)
  (getxy matrix x (ADD y 1)))

(def get_lm_right (world)
     (get_right  (map world) (lm_x world) (lm_y world)))
(def get_right (matrix x y)
  (getxy matrix (ADD x 1) y ))

(def get_lm_left (world)
     (get_left  (map world) (lm_x world) (lm_y world)))
(def get_left (matrix x y)
  (getxy matrix (SUB x 1) y ))

