(in-package #:cl-autograd.tape)


(defclass tape ()
  ((%graph :initarg :graph
           :type 'cl-autograd.graph:expression
           :reader graph)
   (%algebra :initarg :algebra
             :reader algebra)
   (%element-type :initarg :element-type
                  :initform 'single-float
                  :reader element-type)
   (%compiled-value-lambda :initarg :compiled-value-lambda
                           :accessor compiled-value-lambda
                           :initform nil)
   (%compiled-gradient-lambda :initarg :compiled-gradient-lambda
                              :accessor compiled-gradient-lambda
                              :initform nil))
  (:documentation "Object representing expression that can be evaluated."))


(defmethod evaluate ((tape tape) &rest arguments)
  (bind ((graph (graph tape))
         (algebra (algebra tape))
         (forms-count (cl-autograd.graph:forms-count graph))
         (lambda-list (cl-autograd.graph:lambda-list graph))
         (number-of-arguments (length lambda-list))
         (element-type (element-type tape))
         (values-tape (make-array forms-count :element-type element-type)))
    (unless (eql (length arguments)
                 (length lambda-list))
      (error "Wrong number of arguments passed."))
    (iterate
      (for argument-object in lambda-list)
      (for argument in arguments)
      (iterate
        (for i from 0 below (cl-autograd.graph:forms-count argument-object))
        (for form = (cl-autograd.graph:form-at argument-object i))
        (for position = (cl-autograd.graph:index form))
        (setf (aref values-tape position) argument)))
    (iterate
      (for i from (- forms-count 1 number-of-arguments) downto 0)
      (for form = (cl-autograd.graph:form-at graph i))
      (for required-arguments = nil)
      (iterate
        (with count = (cl-autograd.graph:forms-count form))
        (for j from (1- count) downto 0)
        (for subform = (cl-autograd.graph:form-at form j))
        (for index = (cl-autograd.graph:index subform))
        (push (aref values-tape index) required-arguments))
      (for value = (cl-autograd.algebra:evaluate-form-value
                    algebra form required-arguments))
      (setf (aref values-tape i) value))
    (svref values-tape 0)))
