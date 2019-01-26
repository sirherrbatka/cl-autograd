(in-package #:cl-user)


(defpackage :cl-autograd.tape
  (:use #:common-lisp
        #:cl-autograd.aux-package)
  (:nicknames #:cl-autograd.tape)
  (:export
   #:gradient-at
   #:make-state
   #:state-size
   #:state-size
   #:weight-at
   #:state
   #:value-at
   #:with-state))
