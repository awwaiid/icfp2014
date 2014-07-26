
; Initializer
(def main (world something)
     (CONS 0 step))

(def step (aistate world)
    (ifnonzero (get_my_left world)
      (CONS 0 3)
      (CONS 0 0))
)

(def map (world)
     (CAR world))

(def my_location (world)
     (CAR (CDR (CAR (CDR world)))))

(def my_x (world)
     (CAR (my_location world)))

(def my_y (world)
     (CDR (my_location world)))

(def debug (n)
   (DBUG n)
   n
)

(def nth (list n)
  (ifnonzero n
    (nth (CDR list) (SUB n 1))
    (CAR list)
  )
) 
  
(def getxy (matrix x y)
  (nth (nth matrix y) x)
)

(def get_my_above (world)
     (get_above  (map world) (my_x world) (my_y world)))
(def get_above (matrix x y)
  (getxy matrix x (SUB y 1)))

(def get_my_below (world)
     (get_below  (map world) (my_x world) (my_y world)))
(def get_below (matrix x y)
  (getxy matrix x (ADD y 1)))

(def get_my_right (world)
     (get_right  (map world) (my_x world) (my_y world)))
(def get_right (matrix x y)
  (getxy matrix (ADD x 1) y ))

(def get_my_left (world)
     (get_left  (map world) (my_x world) (my_y world)))
(def get_left (matrix x y)
  (getxy matrix (SUB x 1) y ))

