(lang dune 3.17)

(name matchers)

(version 0.1.0)

(generate_opam_files true)

(source
 (github dayfine/matchers))

(authors "Di Fan")

(maintainers "Di Fan")

(license MIT)

(package
 (name status)
 (synopsis "Abseil-style status codes and status_or results for OCaml")
 (description
  "A small set of status codes (Ok, Invalid_argument, NotFound, ...), a status record carrying a code and a message, a status_or result type, and helpers for building and combining them.")
 (depends
  (ocaml
   (>= 5.2.0))
  core
  ppx_deriving
  (ounit2 :with-test)))

(package
 (name matchers)
 (synopsis "Testing utilities for Result types with OUnit2")
 (description
  "Provides a fluent matcher API for testing Result and Option types in OCaml with OUnit2. Includes matchers like is_ok_and_holds, is_error, is_some_and, and combinators for cleaner test assertions.")
 (depends
  (ocaml
   (>= 5.2.0))
  core
  ounit2
  status))

(package
 (name ppx_test_matcher)
 (allow_empty)
 (synopsis "PPX deriver for exhaustive record matchers in test assertions")
 (depends
  (ocaml
   (>= 5.2.0))
  ppxlib
  (ounit2 :with-test)
  (matchers :with-test)))
