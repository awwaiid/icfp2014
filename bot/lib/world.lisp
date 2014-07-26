
; All these things extract data from the world

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

(def lm_direction (world)
     (CAR (CDR (CDR (lm_status world)))))

