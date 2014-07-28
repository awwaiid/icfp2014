
; Initializer
(def main (world something)
     (CONS 0 step))

(def step (aistate world)
     (CONS 0 (onestep world)))

; Move toward the first power pill
(def onestep (world)
     (loc_to_loc_dir
       (lm_loc world)
       ; (cadr (bfs (world_map world) (lm_loc world) (first_pill_loc world)))))
       (cadr (bfs (world_map world) (lm_loc world) target_loc))))

(def target_loc (loc)
     (is_pill loc))

; Pill Finder
; -----------

(def first_pill_loc (world)
     (CAR (pill_locs (world_map world))))

(def pill_locs (worldmap)
     (append
       (filter2 (to_loc_list worldmap) loc_content_is (pill))
       (filter2 (to_loc_list worldmap) loc_content_is (power_pill))))

(def is_pill (map_location)
     (CEQ (loc_content map_location) (pill)))

(def is_power_pill (map_location)
     (CEQ (loc_content map_location) (power_pill)))

(def loc_content_is (type map_location)
     (CEQ (loc_content map_location) type))

; Delicious Libraries
; -------------------

INCLUDE "bot/lib/lang.lisp"
INCLUDE "bot/lib/map.lisp"
INCLUDE "bot/lib/dir.lisp"
INCLUDE "bot/lib/world.lisp"
INCLUDE "bot/lib/bfs.lisp"

