
; Map constants
; -------------

(def wall       () 0)
(def pill       () 1)
(def power_pill () 2)

; Matrix stuff
; ------------

(def getxy (matrix x y)
  (nth (nth matrix y) x))

; Compass directional content gets
; --------------------------------

(def get_north (matrix x y)
  (getxy matrix x (SUB y 1)))

(def get_south (matrix x y)
  (getxy matrix x (ADD y 1)))

(def get_east (matrix x y)
  (getxy matrix (ADD x 1) y ))

(def get_west (matrix x y)
  (getxy matrix (SUB x 1) y ))

(def get_in_dir (matrix x y dir)
     (if (CEQ dir 0) (get_north matrix x y)
     (if (CEQ dir 1) (get_east  matrix x y)
     (if (CEQ dir 2) (get_south matrix x y)
                     (get_west  matrix x y)))))

