(in-package #:cl-user)


(defpackage :cl-autograd.algebra
  (:use #:common-lisp
        #:cl-autograd.aux-package)
  (:nicknames #:cl-autograd.algebra)
  (:export
   #:operatorp
   #:evaluate-operator-value
   #:evaluate-operator-gradient))
