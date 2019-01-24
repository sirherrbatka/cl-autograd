(in-package #:cl-autograd.graph)


(defgeneric content (form)
  (:documentation "Raw content of the form, as used for the construction of the object."))

(defgeneric parents-count (form))

(defgeneric parent-at (form index))

(defgeneric form-type (form)
  (:documentation "Type of form. Either list, number or symbol."))

(defgeneric lambda-list (expression)
  (:documentation "List of all argument objects for the expression."))

(defgeneric form (expression)
  (:documentation "Raw form passed used to create expression."))

(defgeneric argumentp (form)
  (:documentation "Form is dereference of the argument?"))

(defgeneric argument (form)
  (:documentation "Return argument dereferenced in the form, or null."))

(defgeneric forms-count (forms-container)
  (:documentation "How many forms this forms-container holds?"))

(defgeneric form-at (forms-container index)
  (:documentation "Extract form from the form container (either expression, form or argument)"))

(defgeneric name (argument)
  (:documentation "Symbol designating name of the argument."))

(defgeneric index (form))
