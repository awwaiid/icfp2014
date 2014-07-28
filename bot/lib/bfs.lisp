
; BFS - Breadth First Search
; --------------------------

; Returns a path, which is a list of locs from origin_loc to goal_loc
; So, (CAR result) is the origin_loc, (CAR (CDR result)) is the next step, etc
(def bfs (board origin_loc goal_loc)
     ; (DBUG 10000)
     (reverse
       (bfs_engine
         board
         (bfs_initial_path_list origin_loc) ; path_list
         (CONS origin_loc 0)                ; seen locs
         goal_loc)))

(def bfs_initial_path_list (origin_loc)
     ; (DBUG 10001)
     (CONS (CONS origin_loc 0) 0))

(def bfs_engine (board path_list seen goal_loc)
     ; (DBUG 10002)
     ; (DBUG path_list)
     (if (ATOM path_list)
       0 ; No paths exist!
       (if (loc_xy_equal (bfs_cur_loc (bfs_cur_path path_list)) goal_loc)
         (bfs_cur_path path_list) ; we found the shotest path!
         (bfs_add_paths
           board
           path_list
           seen
           goal_loc
           (bfs_expand_path board seen (bfs_cur_path path_list))))))

(def bfs_add_paths (board path_list seen goal_loc new_paths)
     ; (DBUG 10003)
     ; (DBUG new_paths)
     (bfs_engine
       board
       (append (CDR path_list) new_paths)  ; Add to the end of our queue
       (append (bfs_locs new_paths) seen) ; Add to our seen locs
       goal_loc))

; Get the last loc from each path
(def bfs_locs (path_list)
     ; (DBUG 10004)
     (map path_list car))

; Take one path and expand it to a list of paths
; Each new path has new adjacent nodes at the front
(def bfs_expand_path (board seen path)
     ; (DBUG 10005)
     (map2 (bfs_unseen_adjacent_locs board seen path)
           consr path))

(def bfs_unseen_adjacent_locs (board seen path)
     ; (DBUG 10006)
     (bfs_unseen
       seen
       (bfs_adjacent_locs board (bfs_cur_loc path))))


(def bfs_cur_path (path_list)
     ; (DBUG 10007)
     (CAR path_list))

(def bfs_cur_loc (path)
     ; (DBUG 10008)
     (CAR path))

; This is the thing where we can decide to not go through walls
(def bfs_adjacent_locs (board loc)
     ; (DBUG 10009)
     (filter (adjacent_locs board (loc_x loc) (loc_y loc)) bfs_is_ok_loc))

; Everything but walls are OK
; TODO: Also probably ghosts are bad
(def bfs_is_ok_loc (loc)
     ; (DBUG 10010)
     (loc_content loc)) ; implicitly non-wall locs

; Check to see if any loc in loc_list has been seen
(def bfs_unseen (seen loc_list)
     ; (DBUG 10011)
     ; (DBUG seen)
     ; (DBUG loc_list)
     (filter2 loc_list loc_in_list seen))

; True if loc is in loc_list
(def loc_in_list (loc_list loc)
     ; (DBUG 10012)
     (ATOM (filter2 loc_list loc_xy_equal loc)))


