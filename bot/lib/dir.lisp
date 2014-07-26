
; Inefficient way to get constants :)
; -----------------------------------
(def dir_north () 0)
(def dir_east  () 1)
(def dir_south () 2)
(def dir_west  () 3)

; Relative directions
; -------------------

(def inc_dir (dir)
     (if (CEQ dir 0) 1
     (if (CEQ dir 1) 2
     (if (CEQ dir 2) 3
       0))))

(def dec_dir (dir)
     (if (CEQ dir 0) 3
     (if (CEQ dir 1) 0
     (if (CEQ dir 2) 1
       2))))

(def left_dir (dir)
     (dec_dir dir))

(def right_dir (dir)
     (inc_dir dir))

(def forward_dir (dir)
     dir)

(def backward_dir (dir)
     (inc_dir (inc_dir dir)))

