(in-package #:cl-autograd)


(defmethod inline-value ((expression expression)
                         state)
  (let ((algebra (algebra expression))
        (expression (graph expression)))
    `(progn
       ,@(iterate
           (for i
                from (~> expression cl-autograd.graph:forms-count 1-
                         (- (~> expression cl-autograd.graph:lambda-list
                                length)))
                downto 1)
           (for form = (cl-autograd.graph:form-at expression i))
           (collecting (cl-autograd.evaluation:inline-form-value algebra
                                                                 form
                                                                 state))))))


(defmethod inline-gradient ((expression expression)
                            state
                            gradient)
  `(progn
     ,@(iterate
         (for i
              from 1
              below (~> expression cl-autograd.graph:forms-count))
         (for form = (cl-autograd.graph:form-at expression i))
         (collecting (cl-autograd.evaluation:inline-form-gradient form
                                                                  state)))))


(defmethod inline-binding ((expression expression)
                           state
                           arguments)
  (check-type arguments list)
  (check-type state symbol)
  (let* ((arguments (remove-duplicates arguments))
         (lambda-list (~> expression graph cl-autograd.graph:lambda-list)))
    (unless (eql (length arguments) (length lambda-list))
      (error "Missing argument!"))
    `(progn
       ,@(iterate
           (for arg in arguments)
           (for accepted-argument = (find arg lambda-list :key
                                          #'cl-autograd.graph:name))
           (when (null accepted-argument)
             (error "Unknown argument!"))
           (when (~> accepted-argument cl-autograd.graph:forms-count zerop)
             (next-iteration))
           (for form = (cl-autograd.graph:form-at accepted-argument 0))
           (for index = (cl-autograd.graph:index form))
           (collecting `(setf (cl-autograd.tape:value-at ,state ,index)
                              ,arg))))))


(defmethod compile-expression ((expression expression) arguments)
  (with-gensyms (!state)
    (setf (slot-value expression '%value-function)
          (compile nil
                   (print
                    `(lambda (,!state ,@arguments)
                       ,(inline-binding expression !state arguments)
                       ,(inline-value expression !state)
                       (cl-autograd.tape:value-at ,!state 1)))))))


(defmethod initialize-instance :after ((expression expression) &rest initargs)
  (declare (ignore initargs))
  (compile-expression expression
                      (~>> expression
                           graph
                           cl-autograd.graph:lambda-list
                           (mapcar #'cl-autograd.graph:name))))


(defmethod value ((expression expression) values &optional state)
  (check-type values list)
  (let ((state (or state
                   (~> expression graph cl-autograd.evaluation:make-state))))
    (apply (value-function expression) state values)))
