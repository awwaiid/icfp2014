
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

(def mod (n base)
     (SUB n (MUL (DIV n base) base)))

; List stuff
; ----------

; Somtimes you need to CONS the other way around, with the list first
(def consr (list thing) (CONS thing list))

; Function references
(def cons (element list) (CONS element list))
(def car  (list)         (CAR list))
(def cdr  (list)         (CDR list))

; Fancy caddr type stuff
(def caar (list) (CAR (CAR list)))
(def cadr (list) (CAR (CDR list)))
(def cdar (list) (CDR (CAR list)))
(def cddr (list) (CDR (CDR list)))

(def caaar (list) (CAR (CAR (CAR list))))
(def caadr (list) (CAR (CAR (CDR list))))
(def cadar (list) (CAR (CDR (CAR list))))
(def caddr (list) (CAR (CDR (CDR list))))

(def cdaar (list) (CDR (CAR (CAR list))))
(def cdadr (list) (CDR (CAR (CDR list))))
(def cddar (list) (CDR (CDR (CAR list))))
(def cdddr (list) (CDR (CDR (CDR list))))

; Get the nth entry in a list
(def nth (list n)
  (tif n
    (tailcall nth (CDR list) (SUB n 1))
    (return (CAR list))))

(def length (list)
     (length_rec list 0))

(def length_rec (list n)
  (tif (ATOM list)
    (return n)
    (tailcall length_rec (CDR list) (ADD n 1))))

(def reverse (list)
     (reverse_rec list 0))

(def reverse_rec (list result)
     (tif (ATOM list)
          (return result)
          (tailcall reverse_rec (CDR list) (CONS (CAR list) result))))

; This ends up being the combination of (reverse list1) and list
(def combine (list1 list2)
     (if (ATOM list1)
       list2
       (combine (CDR list1) (CONS (CAR list1) list2))))

; Create a flattened out (list1 list2) without breaking the order of list1
(def append (list1 list2)
     (combine (reverse list1) list2))

(def append_item (list item)
     (reverse (CONS item (reverse list))))

; Given a list and a function (f), take each element in the list,
; call (f element), and make that into a new list
(def map (list f)
     (if (ATOM list)
       list
       (CONS (f (CAR list)) (map (CDR list) f))))

; Like map, but with one param already filled in
(def map2 (list f x)
     (if (ATOM list)
       list
       (CONS (f x (CAR list)) (map2 (CDR list) f x))))

(def map_reverse (list f)
     (map_reverse_rec list 0 f))

(def map_reverse_rec (list result f)
     (tif (ATOM list)
       (return result)
       (tailcall map_reverse_rec (CDR list) (CONS (f (CAR list)) result) f)))

(def map_reverse2 (list f x)
     (map_reverse2_rec list 0 f x))

(def map_reverse2_rec (list result f x)
     (tif (ATOM list)
       (return result)
       (tailcall map_reverse2_rec (CDR list) (CONS (f x (CAR list)) result) f x)))

; Given a list and a boolean function, only keep the elements that return true
; from the function
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

; This was craycray
(def map_partial (list f)
     (if (ATOM list)
       list
       (CONS (apply f (CAR list)) (map_partial (CDR list) f))))

; Meta
; It turns out that we don't need these very much if we use map2
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

