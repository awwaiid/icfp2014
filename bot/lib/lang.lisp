
; Language utilities
; ------------------

(def debug (n)
   (DBUG n)
   n)

; LOGIC!
; ------
(def and (a b) (if a b a))
(def or (a b) (if a a b))
(def not (a) (if a 0 1))

; Math
; ----
(def abs (n)
     (if (CGT 0 n)
       (MUL n -1)
       n))

; List stuff
; ----------
(def nth (list n)
  (if n
    (nth (CDR list) (SUB n 1))
    (CAR list))) 

(def length (list)
  (if (ATOM list)
    0
    (ADD 1 (length (CDR list)))))

(def map (list f)
     (if (ATOM list)
       list
       (CONS (f (CAR list)) (map (CDR list) f))))

(def filter (list f)
     (if (ATOM list)
       list
       (if (f (CAR list))
         (CONS (CAR list) (filter (CDR list) f))
         (filter (CDR list) f))))

(def map_partial (list f)
     (if (ATOM list)
       list
       (CONS (apply f (CAR list)) (map_partial (CDR list) f))))

; Meta
; ----

(def partial (f args)
     (CONS f args))

(def apply (p arg)
     (CONS arg (CDR p))
     (CAR p)
     (invoke))

