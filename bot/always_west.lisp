
(def main (world ghostasm)
     (CONS 0 step))

(def step (aistate world)
     (CONS aistate (dir_west)))

INCLUDE "bot/lib/dir.lisp"

