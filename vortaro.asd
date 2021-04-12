(asdf:defsystem vortaro
  :author "Matt Novenstern <fisxoj@gmail.com>"

  :depends-on ("nest"
               "nest/middlewares/beaver"
               "alexandria"
               "validate"
               "lack-middleware-accesslog"
               "lack-middleware-backtrace"
               "clack-static-asset-middleware"
               "clack-static-asset-djula-helpers"
               "cl-trie")

  :components ((:module "src"
                :components ((:file "datoj")
                             (:file "normaligi")
                             (:file "vortaro"))))

  :build-pathname "vortaro"
  :build-operation "asdf/bundle:program-op"
  :entry-point "vortaro:run")
