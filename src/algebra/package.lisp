(in-package #:cl-user)


(defpackage :cl-autograd.algebra
  (:use #:common-lisp
        #:cl-autograd.aux-package)
  (:nicknames #:cl-autograd.algebra)
  (:export
   #:inline-operator-value
   #:inline-operator-weight
   #:operatorp))
