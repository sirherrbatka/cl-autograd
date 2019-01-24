(in-package #:cl-autograd.evaluation)


(declaim (inline state-values))
(declaim (inline state-gradients))


(defstruct (state (:constructor construct-state))
  (values (make-array 0 :element-type 'double-float)
   :type (array double-float (*)))
  (gradients (make-array 0 :element-type 'double-float)
   :type (array double-float (*))))


(declaim (inline value-at))
(defun value-at (state index)
  (~> state state-values (aref index)))


(declaim (inline (setf value-at)))
(defun (setf value-at) (new-val state index)
  (setf (~> state state-values (aref index)) new-val))


(declaim (inline (setf gradient-at)))
(defun (setf gradient-at) (new-val state index)
  (setf (~> state state-gradients (aref index)) new-val))


(declaim (inline gradient-at))
(defun gradient-at (state index)
  (~> state state-gradients (aref index)))


(declaim (inline state-size))
(defun state-size (state)
  (~> state state-values (array-dimension 0)))


(defun make-state (size)
  (construct-state :values (make-array size :element-type 'double-float)
                   :gradients (make-array size :element-type 'double-float)))


(defclass fundamental-algebra ()
  ())


(defclass standard-algebra (fundamental-algebra)
  ((%operators :type hash-table
               :initform (make-hash-table)
               :reader operators)))
