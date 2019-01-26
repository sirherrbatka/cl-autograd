(in-package #:cl-user)


(defpackage :cl-autograd.evaluation
  (:use #:common-lisp
        #:cl-autograd.aux-package)
  (:nicknames #:cl-autograd.evaluation)
  (:export
   #:inline-form-gradient
   #:inline-form-weight
   #:inline-form-value))
