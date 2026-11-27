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
 (synopsis "Composable test matchers for OUnit2")
 (description
  "A fluent matcher API for OUnit2 tests: equality, float and ordering matchers, field and combinator matchers, generic Result and Option matchers, and list and map matchers.")
 (depends
  (ocaml
   (>= 5.2.0))
  core
  ounit2))

(package
 (name status_matchers)
 (synopsis "OUnit2 matchers for Status.status_or results")
 (description
  "Matchers for Status.status_or results: is_ok, is_ok_and_holds and is_error that print the status on failure, and is_error_with for checking a status code and message. Builds on the matchers and status packages.")
 (depends
  (ocaml
   (>= 5.2.0))
  core
  ounit2
  matchers
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
