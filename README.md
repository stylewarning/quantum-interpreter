# quantum-interpreter
A tiny, self-contained, general-purpose quantum interpreter.

# Getting started

1. git clone https://github.com/tarballs-are-good/quantum-interpreter.git
2. cd quantum-interpreter/
3. Open up a file "quantum_programs.lisp" for example and enter
```
(load "qsim.lisp")
(load "examples.lisp")

(defun run-bell ()
  (run-quantum-program (bell 0 1)
		       (make-machine :quantum-state (make-quantum-state 2)
				     :measurement-register 0)))
(print (run-bell))

(defun run-qft ()
  (run-quantum-program (qft '(0 1 2))
		       (make-machine :quantum-state (make-quantum-state 3)
				     :measurement-register 0)))
(print (run-qft))

(defun roll-die ()
  (machine-measurement-register
   (run-quantum-program
    `((GATE ,+H+ 0) (MEASURE))
    (make-machine :quantum-state (make-quantum-state 1)
		  :measurement-register 0))))

(defun run-roll-die ()
  (loop :repeat 10 :collect (roll-die)))

(print (run-roll-die))

```
4. To run these programs, go to the terminal and enter
```
sbcl --noinform --load quantum_programs.lisp
```

5. To exit the REPL
```
* (quit)
```