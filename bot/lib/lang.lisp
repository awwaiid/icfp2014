
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
; (def nth (list n)
  ; (if n
    ; (nth (CDR list) (SUB n 1))
    ; (CAR list))) 

(def nth (list n)
  (tif n
    (tailcall nth (CDR list) (SUB n 1))
    (return (CAR list))))

; (def length (list)
  ; (if (ATOM list)
    ; 0
    ; (ADD 1 (length (CDR list)))))

(def length (list)
     (length_rec list 0))

(def length_rec (list n)
  (tif (ATOM list)
    (return n)
    (tailcall length_rec (CDR list) (ADD n 1))))

(def map (list f)
     (if (ATOM list)
       list
       (CONS (f (CAR list)) (map (CDR list) f))))

; Like map, but with one param already filled in
(def map2 (list f x)
     (if (ATOM list)
       list
       (CONS (f x (CAR list)) (map (CDR list) f x))))

(def filter (list f)
     (if (ATOM list)
       list
       (if (f (CAR list))
         (CONS (CAR list) (filter (CDR list) f))
         (filter (CDR list) f))))

; Like filter, but with one param already filled in
(def filter2 (list f x)
     (if (ATOM list)
       list
       (if (f x (CAR list))
         (CONS (CAR list) (filter2 (CDR list) f x))
         (filter2 (CDR list) f x))))


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

(def curry1 (f args)
     (f (CAR args)))

(def curry2 (f args)
     (f (CAR args)
        (CAR (CDR args))))

(def curry3 (f args)
     (f (CAR args)
        (CAR (CDR args))
        (CAR (CDR (CDR args)))))

(def curry4 (f args)
     (f (CAR args)
        (CAR (CDR args))
        (CAR (CDR (CDR args)))
        (CAR (CDR (CDR (CDR args))))))
