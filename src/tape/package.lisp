(in-package #:cl-user)


(defpackage :cl-autograd.tape
  (:use #:common-lisp
        #:cl-autograd.aux-package)
  (:nicknames #:cl-autograd.tape)
  (:export
   #:with-state
   #:make-state
   #:state-size
   #:value-at
   #:gradient-at
   #:state-size))
