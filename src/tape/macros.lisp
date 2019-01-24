(in-package #:cl-autograd.tape)


(defmacro with-state ((state) &body body)
  (once-only (state)
    `(macrolet ((value (form)
                  `(value-at ,',state (cl-autograd.graph:index ,form)))
                (gradient (form)
                  `(gradient-at ,',state (cl-autograd.graph:index ,form))))
       ,@body)))
