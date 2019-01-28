(in-package #:cl-autograd.tape)


(defstruct (state (:constructor construct-state))
  (values (make-array 0 :element-type 'double-float)
   :type (simple-array double-float (*)))
  (gradients (make-array 0 :element-type 'double-float)
   :type (simple-array double-float (*)))
  (weights (make-array (list 0 0) :element-type 'double-float)
   :type (simple-array double-float (* *))))


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


(declaim (inline weight-at))
(defun weight-at (state index weight-index)
  (~> state state-weights (aref index weight-index)))


(declaim (inline (setf weight-at)))
(defun (setf weight-at) (new-value state index weight-index)
  (setf (~> state state-weights (aref index weight-index))
        new-value))


(defun make-state (size weights-count)
  (construct-state :values (make-array size :element-type 'double-float)
                   :gradients (make-array size :element-type 'double-float)
                   :weights (make-array `(,size weights-count)
                                        :element-type 'double-float)))
