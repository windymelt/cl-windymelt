(defpackage cl-windymelt/tests/main
  (:use :cl
        :cl-windymelt
        :rove))
(in-package :cl-windymelt/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-windymelt)' in your Lisp.

(deftest test2v0
  (testing "is"
    (ok (is "foo" "foo"))
    (ng (is "foo" "FOO"))
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
      (ng (is nil DF))))
  (testing "like"
    (ok (like "foo" "foo"))
    (ok (like "foo" (ppcre:create-scanner "foo")))
    (ng (like "FOO" "foo"))))

(deftest group-by
  (testing "group-by"
    (ok (is (group-by '(0 1 2 3 4) #'oddp)
            '((t 3 1) (nil 4 2 0))))
    (ok (is (group-by '() #'oddp) nil))
    (ok (is (group-by '(1 2 3) #'identity)
            '((3 3) (2 2) (1 1))))))

(deftest jq
  (testing "identity"
    (ok (is (jq '(:|foo| (:|bar| 1)) ".") '(:|foo| (:|bar| 1))) "Dot identity")
    (ok (is (jq '(:|foo| (:|bar| 1)) ".foo") '(:|bar| 1)) "property notation")
    (ok (is (jq '(:|foo| (:|bar| 1)) ".foo.bar") 1) "deep property notation")
    (ok (is (jq '(:|foo| ("a" "b" "c")) ".foo.[1]") "b") "array index notation")
    (ok (is (jq '(1 2 3) ".[]") '(1 2 3)) "array identity notation")
    (ok (is (jq '(:|foo| 1) "{bar: .foo}")
            '(:|bar| 1))
        "object builder notation")
    (ok (is (jq '(:|foo| 1 :|bar| 2) "{bazz: .bar, piyo: .foo}")
            '(:|bazz| 2 :|piyo| 1))
        "object builder notation")))
