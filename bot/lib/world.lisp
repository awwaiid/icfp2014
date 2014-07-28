
; All these things extract data from the world

(def world_map (world)
     (CAR world))

(def lm_status (world)
     (CAR (CDR world)))

(def lm_vitality (world)
     (CAR (lm_status world)))

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

(def lm_lives (world)
     (CAR (CDR (CDR (CDR (lm_status world))))))

(def lm_score (world)
     (CAR (CDR (CDR (CDR (CDR (lm_status world)))))))

(def ghost_list (world)
     (CAR (CDR (CDR world))))

(def first_ghost (world)
     (CAR (ghost_list world)))

(def ghost_vitality (ghost)
     (CAR ghost))

(def ghost_location (ghost)
    (CAR (CDR ghost)))

(def ghost_x (ghost)
     (CAR (ghost_location ghost)))

(def ghost_y (ghost)
     (CDR (ghost_location ghost)))

(def ghost_dir (ghost)
     (CDR (CDR ghost)))

; (def ghost_near (world)
     ; (filter (ghost_list world) (check_ghost lm_x lm_y)))

; (def check_ghost (lm_x lm_y)

(def rand (world max)
     (mod
       (MUL (lm_x world)
       (ADD (lm_y world)
       (ADD (lm_direction world)
       (MUL (lm_lives world)
       ; (ADD (debug (lm_score world))
       (ADD (ghost_x (first_ghost world))
       (ADD (ghost_y (first_ghost world))
       (ADD (ghost_vitality (first_ghost world))
       (ADD (ghost_dir (first_ghost world))
            0))))))))
       max))
