(defsystem "cl-windymelt"
  :version "0.1.0"
  :author "Windymelt"
  :license ""
  :depends-on (:cl-annot :cl-ppcre :iterate :jonathan :cl-interpol :alexandria :trivia :trivia.ppcre)
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "cl-windymelt/tests"))))

(defsystem "cl-windymelt/tests"
  :author "Windymelt"
  :license ""
  :depends-on ("cl-windymelt"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for cl-windymelt"
  :perform (test-op (op c) (symbol-call :rove :run c)))
