
; Language utilities
; ------------------

(def debug (n)
   (DBUG n)
   n)

(def and (a b) (if a b a))

(def or (a b) (if a a b))

(def not (a) (if a 0 1))

(def nth (list n)
  (if n
    (nth (CDR list) (SUB n 1))
    (CAR list))) 

(def length (list)
  (if (ATOM list)
    0
    (ADD 1 (length (CDR list)))))

(def map (list f1)
     (if (ATOM list)
       list
       (CONS (f1 (CAR list)) (map (CDR list) f1))))

(def filter (list f1)
     (if (ATOM list)
       list
       (if (f1 (CAR list))
         (CONS (f1 (CAR list)) (filter (CDR list) f1))
         (filter (CDR list) f1))))


