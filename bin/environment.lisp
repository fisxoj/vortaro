#-quicklisp (load "/root/quicklisp/setup")

(push (uiop:getcwd) asdf:*central-registry*)
(ql:quickload :qlot :silent t)
