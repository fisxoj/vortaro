(defpackage :vortaro/datoj
  (:use #:cl
        #:alexandria)
  (:export #:load-dict
           #:suggest
           #:define))

(in-package #:vortaro/datoj)

(defvar *trie* nil)
(defvar *dict* nil)

(defun load-dict ()
  (setf *trie* (make-instance 'cl-trie:trie))
  (setf *dict* (make-hash-table :test 'equal))
  (with-open-file (f "dictionaries/espdict.txt")
    (flet ((insert-line (line trie)
             (let ((colon-position (position #\: line :test #'char=)))
               (when colon-position
                 (let ((word (subseq line 0 (- colon-position 1)))
                       (definition (subseq line (+ colon-position 2))))
                   (setf (cl-trie:lookup trie word)
                         (1+ (cl-trie:lookup trie word 0)))
                   ;; (format t "~&Inserting ~a: ~a" word definition)
                   (alexandria:appendf (gethash word *dict* nil) `(,definition)))))))
      (loop :for line = (read-line f nil 'eof)
            :until (eq line 'eof)
            :do (insert-line line *trie*))))
  *trie*)


(defun suggest (search)
  (alexandria:when-let ((node (cl-trie:find-node *trie* search)))
    (mapcar (lambda (suffix)
              (concatenate 'string (subseq search 0 (1- (length search))) suffix))
            (cl-trie:all-keys node))))

(defun define (search)
  (gethash search *dict*))
