(defpackage cl-windymelt
  (:use :cl :cl-annot :iterate :jonathan :cl-interpol)
  (:shadowing-import-from :trivia :@)
  (:import-from :trivia.ppcre :ppcre))
(in-package :cl-windymelt)

(annot:enable-annot-syntax)

;;; sequence utility
(defun push-alist (&key by)
  "Returns function that pushes sth into acc and returns acc, keyed by (by sth)."
  #'(lambda (sth acc)
      (let ((key (funcall by sth)))
        (if (assoc key acc)
            (progn
              (push sth (cdr (assoc key acc)))
              acc)
            (push (cons key (list sth)) acc)))))

(defun %group-by (seq op)
  (iter (for x #:in seq)
    (accumulate x #:by (push-alist :by op))))

(defun sort-assoc-values (pair)
  (setf (cdr pair) (nreverse (cdr pair)))
  pair)

@export
(defun group-by (seq op &key (preservep nil))
  (if preservep
      (mapcar #'sort-assoc-values (%group-by seq op))
      (%group-by seq op)))

;;; generic map (can be used for hashmap, etc.)
(defun genmap (op seqlike))

;;; generic accessor
;; keys values

;;; JSON

;; easy json modify util
;; jq like accessor
;; modifyer
;; (jq ".") => requrns function
;; #J"." (same)
;; (func JSON) => JSON
;; use arrows
;; (-> *j*
;;     (./ :|key|)
;;     (./ :|depthkey|))
(defmacro ./ (&rest rest)
  `(getf ,@rest))

(interpol:enable-interpol-syntax)

(defmacro jq-read-key! (str)
  `(multiple-value-bind (de to gde gto)
      (ppcre:scan #?/^\s*([^.: ]+)\s*:\s*/ ,str)
    (when de
      (let ((res (subseq ,str (elt gde 0) (elt gto 0))))
        (setf ,str (subseq ,str to))
        res))))

(defparameter *jq-array-idx-re* #?/^\.\[(\d+)\](.*)/)
(defparameter *jq-object-prop-re* #?/^\.([^.{} ]+)\s*(.*)/)
(defun jq-object-builder (json buildfmt)
  (trivia:match buildfmt
    ("{}" :{})
    ("[]" :[])
    ((ppcre *jq-object-prop-re* prop rest)
     (jq-property json prop rest)
     ;; TODO: multiple
     )
    ;; TODO: number, string, boolean literals
    ((ppcre "{(.+)},?\s*" field-pairs-string) ;; object
     (let ((key (jq-read-key! field-pairs-string)))
       (when key
         (let ((val (jq-object-builder json field-pairs-string)))
           (when val
             (list (alexandria:make-keyword key) val))))))))

(defmacro carry-on (res rest)
  `(if (string= ,rest "")
       ,res
       (jq ,res ,rest)))

(defun jq-property (json prop rest)
   (let ((res (getf json (alexandria:make-keyword prop))))
       (carry-on res rest)))

@export
(defun jq (json query)
  (trivia:match query
    ("." json)
    (".[]" json) ;; TODO: if context is object, returns array of values
    ((ppcre *jq-array-idx-re* idx rest) ;; array element notation
     (let ((res (elt json (parse-integer idx))))
       (carry-on res rest)))
    ((ppcre *jq-object-prop-re* prop rest) ;; property notation
     (jq-property json prop rest))
    ((ppcre #?/^(\{.*\})(.*)/ buildfmt rest)
     (let ((res (jq-object-builder json buildfmt)))
       (carry-on res rest)))
    (otherwise (error "broken query: ~S" query))))

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

(defmethod is ((x string) (y string))
  (string= x y))

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

;; like

@export
(defun like (x y)
  (is (ppcre:scan y x) D))
