
(RTN (CONS 0 step))

(def step (botstate world)
   (DBUG
     (getxy
       (CAR (CAR (CDR (CAR (CDR world)))))
       (CDR (CAR (CDR (CAR (CDR world)))))))

   (CONS 0 1)
)

(def debug (n)
   (DBUG n)
   n
)

(def nth (list n)
  (ifzero n
    (CAR list)
    (nth (CDR list) (SUB n 1))
  )
) 
  
(def getxy (matrix x y)
  (nth (nth matrix y) x)
)

(def get_above (matrix x y)
  (getxy x (SUB y 1)))

(def get_below (matrix x y)
  (getxy x (ADD y 1)))

(def get_right (matrix x y)
  (getxy (ADD x 1) y ))

(def get_left (matrix x y)
  (getxy (SUB x 1) y ))

