
; (def zero () 0)
; (def one  () 1)
; (def two  () 2)

; (def debug (n)
   ; (DBUG n)
   ; n)

; (def and (a b)
     ; (if a b a))

; (def or (a b)
     ; (if a a b))

; (def not (a)
     ; (if a 0 1))

; (def nth (list n)
  ; (if n
    ; (nth (CDR list) (SUB n 1))
    ; (CAR list))) 

; (def getxy (matrix x y)
  ; (nth (nth matrix y) x))

(def main ()
  (DBUG (map (CONS 1 (CONS 2 (CONS 3 0))) addone)))

(def addone (n)
     (ADD n 1))

(def map (list f1)
     (if (ATOM list)
       list
       (CONS (f1 (CAR list)) (map (CDR list) f1))))
