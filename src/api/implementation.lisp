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
                            state)
  `(progn
     ,@(iterate
         (with graph = (~> expression graph))
         (for i
              from 1
              below (~> graph cl-autograd.graph:forms-count))
         (for form = (cl-autograd.graph:form-at graph i))
         (collecting (cl-autograd.evaluation:inline-form-gradient form
                                                                  state)))))


(defmethod inline-weight ((expression expression)
                          state)
  `(progn
     (setf (cl-autograd.tape:weight-at ,state 1 0) 1.0d0)
     ,@(iterate
         (with graph = (~> expression graph))
         (with algebra = (~> expression algebra))
         (for i
              from 1
              below (~> graph cl-autograd.graph:forms-count))
         (for form = (cl-autograd.graph:form-at graph i))
         (adjoining (cl-autograd.evaluation:inline-form-weight algebra
                                                               form
                                                               state)))))


(defmethod inline-binding ((expression expression)
                           state
                           arguments)
  (check-type arguments (or symbol list))
  (check-type state symbol)
  (let* ((arguments (if (symbolp arguments)
                        arguments
                        (remove-duplicates arguments)))
         (type (expression-type expression))
         (lambda-list (~> expression graph cl-autograd.graph:lambda-list)))
    (ecase type
      (lambda (unless (eql (length arguments) (length lambda-list))
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
                                  ,arg)))))
      (vector `(progn
                 ,@(iterate
                     (for accepted-argument in lambda-list)
                     (for i from 0)
                     (when (~> accepted-argument cl-autograd.graph:forms-count zerop)
                       (next-iteration))
                     (for form = (cl-autograd.graph:form-at accepted-argument 0))
                     (for index = (cl-autograd.graph:index form))
                     (collecting `(setf (cl-autograd.tape:value-at ,state ,index)
                                        (aref ,arguments ,i)))))))))


(defmethod compile-gradient ((expression expression))
  (with-gensyms (!state)
    (setf (slot-value expression '%gradient-function)
          (compile nil
                   `(lambda (,!state)
                      ,(inline-weight expression !state)
                      ,(inline-gradient expression !state))))))


(defmethod compile-expression ((expression expression) arguments)
  (with-gensyms (!state !vector)
    (setf (slot-value expression '%value-function)
          (compile nil
                   (print
                    `(lambda ,(ecase (expression-type expression)
                                (lambda `(,!state ,@arguments))
                                (vector
                                 (setf arguments !vector)
                                 `(,!state ,!vector)))
                       (declare (optimize (speed 3) (safety 0) (debug 0) (space 0))
                                (type cl-autograd.tape:state ,!state)
                                ,(ecase (expression-type expression)
                                   (lambda `(type double-float ,@arguments))
                                   (vector
                                    `(type (simple-array double-float
                                                         (,(~> expression
                                                               graph
                                                               cl-autograd.graph:lambda-list
                                                               length)))
                                           ,arguments))))
                       ,(inline-binding expression !state arguments)
                       ,(inline-value expression !state)
                       (cl-autograd.tape:value-at ,!state 1)))))))


(defmethod initialize-instance :after ((expression expression) &rest initargs)
  (declare (ignore initargs))
  (compile-expression expression
                      (~>> expression
                           graph
                           cl-autograd.graph:lambda-list
                           (mapcar #'cl-autograd.graph:name)))
  (compile-gradient expression))


(defmethod make-state ((expression expression))
  (~> expression graph cl-autograd.evaluation:make-state))


(defmethod value ((expression expression) values &optional state)
  (let ((state (or state (make-state expression))))
    (check-type state cl-autograd.tape:state)
    (ecase (expression-type expression)
      (lambda (check-type values list)
        (map nil (lambda (x) (check-type x double-float)) values)
        (apply (value-function expression) state values))
      (vector
       (check-type values (simple-array double-float (*)))
       (funcall (value-function expression) state values)))))


(defmethod gradient ((expression expression) state)
  (~> expression gradient-function (funcall state)))
