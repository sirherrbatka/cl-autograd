(in-package #:cl-user)


(defpackage :cl-autograd.algebra
  (:use #:common-lisp
        #:cl-autograd.aux-package)
  (:nicknames #:cl-autograd.algebra)
  (:export
   #:*standard-algebra*
   #:inline-operator-weight
   #:operatorp
   #:inline-operator-value))
