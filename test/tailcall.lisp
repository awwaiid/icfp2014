
(def main ()
     (DBUG (nth (buildlist 4) 2)))

(def buildlist (n)
     (buildlist_rec n 0))

(def buildlist_rec (n list)
     (tif n
       (tailcall buildlist_rec (SUB n 1) (CONS n list))
       (return list)))

(def nth (list n)
  (tif n
    (tailcall nth (CDR list) (SUB n 1))
    (return (CAR list))))

