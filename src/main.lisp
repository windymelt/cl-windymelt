(defpackage cl-windymelt
  (:use :cl :cl-annot))
(in-package :cl-windymelt)

(annot:enable-annot-syntax)

;;; sequence utility

(defun group-by (seq op))

;;; generic map (can be used for hashmap, etc.)
(defun genmap (op seqlike))

;;; JSON

;; easy json modify util
;; jq like accessor
;; modifyer
;; (jq ".") => requrns function
;; #J"." (same)
;; (func JSON) => JSON

;;; HTTP
;; dexador

;;; Testing
;; test2 like;

;; "T" in Test2::V0
(defclass <$T> () ())
@export
(defparameter $T (make-instance '<$T>))

(defgeneric is (x y))

@export
(defmethod is (x y)
  (equalp x y))

(defmethod is (x '<$T>)
  (not (null x)))

(defmethod is ((x number) '<$T>)
  (not (zerop x)))

(defmethod is ((x string) '<$T>)
  (string/= x ""))


;; "F" in Test2::V0
(defclass <F> () ())
@export
(defparameter F (make-instance '<F>))

(defmethod is (x '<F>)
  (not (is x $T)))

(defmethod is ((x number) '<F>)
  (zerop x))

(defmethod is ((x string) '<F>)
  (or (string= x "")
      (string= x "0"))) ;; FIXME

;; "D"/"U" in Test2::V0
(defclass <D> () ())
@export
(defparameter D (make-instance '<D>))

(defmethod is (x '<D>)
  (not (null x)))

(defclass <U> () ())
@export
(defparameter U (make-instance '<U>))

(defmethod is (x '<U>)
  (null x))

;; "DF" (defined but F) in Test2::V0
(defclass <DF> () ())
@export
(defparameter DF (make-instance '<DF>))

(defmethod is (x '<DF>)
  (and (is x D)
       (is x F)))

;; TODO: E/DNE/FDNE
