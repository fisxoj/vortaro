(asdf:defsystem vortaro
  :author "Matt Novenstern <fisxoj@gmail.com>"
  :pathname #P"src/"
  :depends-on ("nest"
               "alexandria"
               "validate"
               "lack-middleware-accesslog"
               "lack-middleware-backtrace"
               "lack-middleware-session"
               "clack-static-asset-middleware"
               "clack-static-asset-djula-helpers"
               "cl-trie")
  :components ((:file "datoj")
               (:file "vortaro")))
