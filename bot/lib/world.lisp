
; All these things extract data from the world

(def world_map (world)
     (CAR world))

(def lm_status (world)
     (CAR (CDR world)))

(def lm_location (world)
     (CAR (CDR (lm_status world))))

(def lm_loc (world)
     (CONS (lm_location world) 0))

(def lm_x (world)
     (CAR (lm_location world)))

(def lm_y (world)
     (CDR (lm_location world)))

(def lm_direction (world)
     (CAR (CDR (CDR (lm_status world)))))

(def ghost_status (world)
     (CAR (CDR (CDR world))))

(def ghost_location (ghost)
    (CAR (CDR (ghost))))

(def ghost_x (ghost)
     (CAR (ghost_location)))

(def ghost_y (ghost)
     (CDR (ghost_location)))

(def ghost_vit (ghost)
     (CAR (ghost)))

(def ghost_dir (ghost)
     (CDR (CDR (ghost))))

; (def ghost_near (world)
     ; (filter (ghost_status world) (check_ghost lm_x lm_y)))

; (def check_ghost (lm_x lm_y)

