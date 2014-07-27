
(def main ()
  (DBUG (to_xy_content_list (m))))

(def m ()
     (CONS (CONS 1 (CONS 2 (CONS 3 0)))
     (CONS (CONS 4 (CONS 5 (CONS 6 0)))
     (CONS (CONS 7 (CONS 8 (CONS 9 0)))
     0))))

INCLUDE "bot/lib/lang.lisp"
INCLUDE "bot/lib/map.lisp"

