(in-package #:cl-user)


(defpackage :cl-autograd.algebra
  (:use #:common-lisp
        #:cl-autograd.aux-package)
  (:nicknames #:cl-autograd.algebra)
  (:export
   #:evaluate-operator-gradient
   #:evaluate-operator-value
   #:inline-operator-value
   #:operatorp))
