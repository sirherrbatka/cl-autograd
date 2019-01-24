(in-package #:cl-autograd.algebra)


(defclass fundamental-algebra ()
  ())


(defclass standard-algebra (fundamental-algebra)
  ((%operators :type hash-table
               :initform (make-hash-table)
               :reader operators)))
