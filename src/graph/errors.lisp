(in-package #:cl-autograd.graph)


(define-condition lambda-list-error (program-error)
  ((%lambda-list :initarg :lambda-list
                 :reader lambda-list))
  (:report (lambda (condition stream)
             (format stream
                     "Invalid lambda list: ~a"
                     (lambda-list condition)))))


(define-condition body-error (program-error)
  ((%body :initarg :body
          :reader body))
  (:report (lambda (condition stream)
             (format stream
                     "Invalid body: ~a"
                     (body condition)))))


(define-condition empty-body (body-error)
  ()
  (:report (lambda (condition stream)
             (declare (ignore condition))
             (format stream
                     "Body of the expression is empty!"))))


(define-condition lambda-list-duplicate (lambda-list-error)
  ()
  (:report (lambda (condition stream)
             (format stream
                     "Duplicate symbol found in the lambda-list: ~a."
                     (lambda-list condition)))))


(define-condition lambda-list-nil (lambda-list-error)
  ()
  (:report (lambda (condition stream)
             (format stream
                     "Lambda list contains nil: ~a."
                     (lambda-list condition)))))
