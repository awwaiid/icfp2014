
; Map constants
; -------------

(def wall       () 0)
(def pill       () 2)
(def power_pill () 3)

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

(def get_dir_xy (matrix x y dir)
     (if (CEQ dir 0) (CONS x (SUB y 1))
     (if (CEQ dir 1) (CONS (ADD x 1) y)
     (if (CEQ dir 2) (CONS x (ADD y 1))
                     (CONS (SUB x 1) y)))))

(def get_in_dir (matrix x y dir)
     (if (CEQ dir 0) (get_north matrix x y)
     (if (CEQ dir 1) (get_east  matrix x y)
     (if (CEQ dir 2) (get_south matrix x y)
                     (get_west  matrix x y)))))

(def get_dir_loc (matrix x y dir)
     (CONS 
       (if (CEQ dir 0) (CONS x (SUB y 1))
       (if (CEQ dir 1) (CONS (ADD x 1) y)
       (if (CEQ dir 2) (CONS x (ADD y 1))
                       (CONS (SUB x 1) y))))
     dir))

; Locations
; loc = ((x,y), content)
; ----------------------

(def to_loc_list_rec (matrix x y)
     (if (ATOM matrix)
       0
     (if (ATOM (CAR matrix))
       (to_loc_list_rec (CDR matrix) 0 (ADD y 1))
       (CONS
         (CONS (CONS x y) (CAR (CAR matrix)))
         (to_loc_list_rec
           (CONS (CDR (CAR matrix)) (CDR matrix)) (ADD x 1) y)))))


(def to_loc_list (matrix)
     (to_loc_list_rec matrix 0 0))

(def loc_content (loc)
     (CDR loc))

(def loc_xy (loc)
     (CAR loc))

(def loc_x (loc)
     (get_x (loc_xy loc)))

(def loc_y (loc)
     (get_y (loc_xy loc)))

(def loc_xy_dist (loc xy)
     (manhattan_dist xy (loc_xy loc)))

; [loc] -> [(dist,loc)]
(def loc_list_xy_dist (loc_list xy)
     (if (ATOM loc_list)
       0
       (CONS
         (CONS (loc_xy_dist (CAR loc_list) xy) (CAR loc_list))
         (loc_list_xy_dist (CDR loc_list) xy))))

; Coordinates
; -----------

(def get_x (xy) (CAR xy))
(def get_y (xy) (CDR xy))

(def manhattan_dist (xy1 xy2)
     (ADD (abs (SUB (get_x xy1) (get_x xy2)))
          (abs (SUB (get_y xy1) (get_y xy2)))))


