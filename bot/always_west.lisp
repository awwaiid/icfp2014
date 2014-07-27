
(def main (world ghostasm)
     (CONS 0 step))

(def step (aistate world)
     (CONS 0 (dir_west)))

INCLUDE "bot/lib/dir.lisp"

