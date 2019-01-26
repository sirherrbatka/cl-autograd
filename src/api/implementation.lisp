(in-package #:cl-autograd)


(defmethod inline-value ((expression expression)
                         state)
  (let ((algebra (algebra expression)))
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
                           &rest arguments)
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
           (for i
                from 1
                below (~> expression cl-autograd.graph:forms-count))
           (for form = (cl-autograd.graph:form-at expression i))
           (collecting (cl-autograd.evaluation:inline-form-gradient
                        form state))))))
