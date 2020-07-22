(defpackage cl-windymelt/tests/main
  (:use :cl
        :cl-windymelt
        :rove))
(in-package :cl-windymelt/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-windymelt)' in your Lisp.

(deftest test2v0
  (testing "is"
    (testing "$T"
      (ok (is t t))
      (ng (is t nil))
      (ok (is #(1 2 3) #(1 2 3)) "Vector comparison in equalp")
      (ok (is t $T))
      (ok (is 2 $T))
      (ok (is "foo" $T))
      (ng (is "" $T))
      (ng (is nil $T))
      (ng (is 0 $T) "Zero should be treated as NOT $T"))
    (testing "F"
      (ok (is nil F))
      (ok (is 0 F))
      (ok (is "" F))
      (ok (is "0" F)))
    (testing "D"
      (ok (is t D))
      (ok (is 0 D))
      (ok (is 2 D))
      (ok (is "" D))
      (ok (is "foo" D))
      (ok (is #(1 2 3) D)))
    (testing "U"
      (ok (is nil U))
      (ng (is t U))
      (ng (is 0 U))
      (ng (is 2 U))
      (ng (is "" U)))
    (testing "DF"
      (ok (is "" DF))
      (ok (is 0 DF))
      (ok (is "0" DF))
      (ng (is nil DF)))))
