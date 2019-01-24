(in-package #:cl-user)


(defpackage :cl-autograd.algebra
  (:use #:common-lisp
        #:cl-autograd.aux-package)
  (:nicknames #:cl-autograd.algebra)
  (:export
   #:evaluate-form-gradient
   #:evaluate-form-value
   #:evaluate-operator-gradient
   #:evaluate-operator-value
   #:value-at
   #:state-size
   ))
