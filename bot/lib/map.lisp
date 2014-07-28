
; Map constants
; -------------

(def wall       () 0)
(def pill       () 2)
(def power_pill () 3)
(def fruit      () 4)

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

(def get_north_loc (matrix x y)
    (CONS (CONS x (SUB y 1)) (get_north matrix x y)))

(def get_south_loc (matrix x y)
    (CONS (CONS x (ADD y 1)) (get_south matrix x y)))

(def get_west_loc (matrix x y)
    (CONS (CONS (SUB x 1) y) (get_west matrix x y)))

(def get_east_loc (matrix x y)
    (CONS (CONS (ADD x 1) y) (get_east matrix x y)))

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
; this is not a loc
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

; returns integer dir value
; loc 1 = source
; loc 2 = destination
(def loc_to_loc_dir (loc1 loc2)
    (if (CGT (distance_eastwest loc1 loc2) (distance_northsouth loc1 loc2))
        (if (CGT (loc_x loc1) (loc_x loc2)) (dir_west) (dir_east))
        (if (CGT (loc_y loc1) (loc_y loc2)) (dir_north) (dir_south))))
           
(def distance_eastwest (loc1 loc2)
    (abs (SUB (loc_x loc1) (loc_x loc2))))

(def distance_northsouth (loc1 loc2)
    (abs (SUB (loc_y loc1) (loc_y loc2))))

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

(def loc_xy_equal (loc1 loc2)
     (and
       (CEQ (loc_x loc1) (loc_x loc2))
       (CEQ (loc_y loc1) (loc_y loc2))))

(def loc_xy_dist (distf loc xy)
     (distf xy (loc_xy loc)))

; [loc] -> [(dist,loc)]
(def loc_list_xy_dist (distf loc_list xy)
     (if (ATOM loc_list)
       0
       (CONS
         (CONS (loc_xy_dist distf (CAR loc_list) xy) (CAR loc_list))
         (loc_list_xy_dist distf (CDR loc_list) xy))))

; get adjacent locs
(def adjacent_locs (board x y) 
    (CONS (get_north_loc board x y) 
        (CONS (get_east_loc board x y)
            (CONS (get_south_loc board x y)
                (CONS (get_west_loc board x y) 
                    0)))))

; Coordinates
; -----------

(def get_x (xy) (CAR xy))
(def get_y (xy) (CDR xy))

(def xy_eq (xy1 xy2)
     (and (CEQ (get_x xy1) (get_x xy2))
          (CEQ (get_y xy1) (get_y xy2))))

; Distance and Paths
; ------------------

(def manhattan_dist (xy1 xy2)
     (ADD (abs (SUB (get_x xy1) (get_x xy2)))
          (abs (SUB (get_y xy1) (get_y xy2)))))


; A* Algorithm
; create the open list of nodes, initially containing only our starting node
; create the closed list of nodes, initially empty
; while (we have not reached our goal) {
   ; consider the best node in the open list (the node with the lowest f value)
   ; if (this node is the goal) {
       ; then we're done
   ; }
   ; else {
       ; move the current node to the closed list and consider all of its neighbors
       ; for (each neighbor) {
           ; if (this neighbor is in the closed list and our current g value is lower) {
               ; update the neighbor with the new, lower, g value 
               ; change the neighbor's parent to our current node
           ; }
           ; else if (this neighbor is in the open list and our current g value is lower) {
               ; update the neighbor with the new, lower, g value 
               ; change the neighbor's parent to our current node
           ; }
           ; else this neighbor is not in either the open or closed list {
               ; add the neighbor to the open list and set its g value
           ; }
       ; }
   ; }
; }

