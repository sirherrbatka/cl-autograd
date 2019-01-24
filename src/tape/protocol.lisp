(in-package #:cl-autograd.tape)


(defgeneric graph (tape)
  (:documentation "Read graph of the tape."))


(defgeneric become-compiled (tape)
  (:documentation "Fills tape object with optimized, compiled function for gradient calculation."))


(defgeneric algebra (tape)
  (:documentation "Returns algebra object stored in the tape."))


(defgeneric evaluate (tape &rest arguments)
  (:documentation "Evaluate tape with arguments. Returns result and gradient."))
