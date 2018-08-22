;;;; examples.lisp - examples using qsim.lisp
;;;; Copyright (c) 2018 Robert Smith; see LICENSE.txt for terms.

(defglobal +H+ (make-array '(2 2) :initial-contents (let ((s (/ (sqrt 2.0d0))))
                                                      (list (list s s)
                                                            (list s (- s))))))

(defglobal +CNOT+ #2A((1 0 0 0)
                      (0 1 0 0)
                      (0 0 0 1)
                      (0 0 1 0)))

(defun cphase (angle)
  (make-array '(4 4) :initial-contents `((1 0 0 0)
                                         (0 1 0 0)
                                         (0 0 1 0)
                                         (0 0 0 ,(cis (coerce angle 'double-float))))))

(defun bell (p q)
  `((gate ,+H+ ,p)
    (gate ,+CNOT+ ,p ,q)))

(defun ghz (n)
  (cons `(gate ,+H+ 0)
        (loop :for q :below (1- n)
              :collect `(gate ,+CNOT+ ,q ,(1+ q)))))

(defun qft (qubits)
  (labels ((bit-reversal (qubits)
             (let ((n (length qubits)))
               (if (< n 2)
                   nil
                   (loop :repeat (floor n 2)
                         :for qs :in qubits
                         :for qe :in (reverse qubits)
                         :collect `(GATE ,+swap+ ,qs ,qe)))))
           (%qft (qubits)
             (destructuring-bind (q . qs) qubits
               (if (null qs)
                   (list `(GATE ,+H+ ,q))
                   (let ((cR (loop :with n := (1+ (length qs))
                                   :for i :from 1
                                   :for qi :in qs
                                   :for angle := (/ pi (expt 2 (- n i)))
                                   :collect `(GATE ,(cphase angle) ,q ,qi))))
                     (append
                      (qft qs)
                      cR
                      (list `(GATE ,+H+ ,q))))))))
    (append (%qft qubits) (bit-reversal qubits))))
