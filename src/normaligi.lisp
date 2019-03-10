(defpackage vortaro/normaligi
  (:use #:cl)
  (:export #:normaligu))

(in-package #:vortaro/normaligi)


(defparameter +afiksoj+ #(#\h #\x #\j #\'))


(defparameter +afikseblaj-karaktroj+ (list (cons #\c #\ĉ)
                                           (cons #\g #\ĝ)
                                           (cons #\j #\ĵ)
                                           (cons #\h #\ĥ)
                                           (cons #\s #\ŝ)
                                           (cons #\u #\ŭ)))


(defun normaligu (string)
  (with-output-to-string (s)
    (flet ((afikso-p (c)
             (find c +afiksoj+ :test #'char=))
           (trovu-afikson (c)
             (cdr (assoc c +afikseblaj-karaktroj+))))
      (loop
        for index below (length string)
        for c = (char string index)

        if (and (trovu-afikson c)
                (< (1+ index) (length string))
                (afikso-p (char string (1+ index))))
          do (princ (trovu-afikson c) s)
          and do (incf index)
        else
          do (princ (char string index) s)))))
