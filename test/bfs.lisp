
(def main ()
     (DBUG 100)
     (DBUG (bfs (mkboard1) (CONS (CONS 1 1) 0) (CONS (CONS 3 1) 0))))
     
(def mkboard1 ()
     (CONS (CONS 0 (CONS 0 (CONS 0 (CONS 0 (CONS 0 0)))))
     (CONS (CONS 0 (CONS 1 (CONS 0 (CONS 1 (CONS 0 0)))))
     (CONS (CONS 0 (CONS 1 (CONS 1 (CONS 1 (CONS 0 0)))))
     (CONS (CONS 0 (CONS 1 (CONS 1 (CONS 1 (CONS 0 0)))))
     (CONS (CONS 0 (CONS 1 (CONS 1 (CONS 1 (CONS 0 0)))))
     (CONS (CONS 0 (CONS 0 (CONS 0 (CONS 0 (CONS 0 0)))))
           0)))))))

INCLUDE "bot/lib/lang.lisp"
INCLUDE "bot/lib/map.lisp"
INCLUDE "bot/lib/bfs.lisp"

