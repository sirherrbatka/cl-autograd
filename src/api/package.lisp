(in-package #:cl-user)


(defpackage :cl-autograd
  (:use #:common-lisp
        #:cl-autograd.aux-package)
  (:nicknames #:cl-autograd)
  (:export
   #:inline-form-gradient
   #:inline-form-weight
   #:inline-form-value))
