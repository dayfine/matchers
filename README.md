# matchers

Composable test matchers for OCaml and OUnit2, split out of
[dayfine/trading](https://github.com/dayfine/trading). Four opam packages
live in this repo:

- **`status`**: Abseil-style status codes (`Ok`, `Invalid_argument`,
  `NotFound`, ...), a `Status.t` record with a code and a message, a
  `'a status_or = ('a, Status.t) Result.t` type, and helpers such as
  `invalid_argument_error`, `error_not_found` and `combine_status_list`.
- **`matchers`**: a fluent matcher API on top of OUnit2. A matcher is an
  `'a -> unit` function that fails the running test; `assert_that value
  matcher` applies one. It includes `equal_to`, `float_equal` (NaN-aware),
  `gt`/`ge`/`lt`/`le`, `field`, `all_of`, `not_`, `is_ok_and_holds`,
  `is_error_and_holds`, `is_some_and`, `elements_are`,
  `unordered_elements_are`, `each`, `one`, `contains_entry` and more. The
  Result matchers work for any error type. No dependency on `status`.
- **`status_matchers`**: matchers for `Status.status_or`. `is_error_with code
  ~msg` checks the status code and message; `is_ok`, `is_ok_and_holds` and
  `is_error` shadow the generic ones and print the status when they fail.
  Depends on `matchers` and `status`.
- **`ppx_test_matcher`**: a deriver. `[@@deriving test_matcher]` on a record
  type generates `match_<type>` with one required labelled argument per field,
  so adding a field breaks every call site until it is handled. Use `__` (from
  `Matchers`) to ignore a field on purpose.

## Install

Not on opam-repository; pin from git. `status_matchers` needs `matchers` and
`status`, and the ppx tests use `matchers`, so pin the ones you use:

```sh
opam pin add status git+https://github.com/dayfine/matchers.git
opam pin add matchers git+https://github.com/dayfine/matchers.git
opam pin add status_matchers git+https://github.com/dayfine/matchers.git
opam pin add ppx_test_matcher git+https://github.com/dayfine/matchers.git
```

Then in a `dune` file:

```dune
(test
 (name my_test)
 (libraries ounit2 matchers status_matchers)
 (preprocess
  (pps ppx_test_matcher)))
```

## Usage

From the test suites in this repo:

```ocaml
open OUnit2
open Matchers

type point = { x : float; y : float } [@@deriving test_matcher]

let test_point_matcher_all_fields _ =
  let p = { x = 1.0; y = 2.0 } in
  assert_that p (match_point ~x:(float_equal 1.0) ~y:(float_equal 2.0))

let test_point_matcher_ignore_with_wildcard _ =
  let p = { x = 1.0; y = 2.0 } in
  (* Only check x, explicitly ignore y with __ *)
  assert_that p (match_point ~x:(float_equal 1.0) ~y:__)

let test_gt_passes _ =
  assert_that 5 (gt (module Int_ord) 4);
  assert_that 1.0 (gt (module Float_ord) 0.0)
```

Result matchers take any error type:

```ocaml
let _err : (int, string) Result.t = Error "bad input"

let test_is_error_and_holds_generic _ =
  assert_that _err (is_error_and_holds (contains_substring "bad"))
```

For `Status.status_or`, open `Status_matchers` after `Matchers`:

```ocaml
open Matchers
open Status_matchers

let _invalid : int Status.status_or =
  Status.error_invalid_argument "quantity must be positive"

let test_is_error_with_msg _ =
  assert_that _invalid (is_error_with Status.Invalid_argument ~msg:"must be positive")
```

`status` on its own:

```ocaml
open OUnit2
open Status

let test_combine_status_list_single_error _ =
  let status_list =
    [
      Result.Ok ();
      Result.Error (invalid_argument_error "first error");
      Result.Ok ();
    ]
  in
  match combine_status_list status_list with
  | Result.Ok () -> assert_failure "Expected Error when one status is Error"
  | Result.Error status ->
      assert_equal Invalid_argument status.code;
      assert_equal "first error" status.message
```

## Development

```sh
opam install . --deps-only --with-test
dune build
dune runtest
dune build @fmt
```

## License

MIT. See [LICENSE](LICENSE).
