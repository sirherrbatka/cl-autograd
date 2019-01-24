(in-package #:cl-autograd.algebra)


(defstruct (state (:constructor construct-state))
  (values (make-array 0 :element-type 'double-float)
   :type (array double-float (*)))
  (gradients (make-array 0 :element-type 'double-float)
   :type (array double-float (*))))


(defun value-at (state index)
  (~> state state-values (aref index)))


(defun gradient-at (state index)
  (~> state state-gradients (aref index)))


(defun state-size (state)
  (~> state state-values (array-dimension 0)))


(defun make-state (size)
  (construct-state :values (make-array size :element-type 'double-float)
                   :gradients (make-array size :element-type 'double-float)))


(defclass fundamental-algebra ()
  ())


(defclass standard-algebra (fundamental-algebra)
  ())
