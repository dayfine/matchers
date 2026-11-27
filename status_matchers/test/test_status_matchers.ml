open OUnit2
open Matchers
open Status_matchers

(* The matcher must fail an OUnit assertion whose message contains
   [substring]. *)
let assert_fails_naming ~substring f =
  match f () with
  | () -> assert_failure "Expected matcher to fail but it passed"
  | exception OUnitTest.OUnit_failure msg ->
      assert_that msg (contains_substring substring)

let _ok : int Status.status_or = Ok 3
let _not_found : int Status.status_or = Status.error_not_found "no such order"

let _invalid : int Status.status_or =
  Status.error_invalid_argument "quantity must be positive"

let test_is_ok_passes_on_ok _ = assert_that _ok is_ok

let test_is_ok_prints_status_on_error _ =
  assert_fails_naming ~substring:"no such order" (fun () ->
      assert_that _not_found is_ok)

let test_is_ok_and_holds_applies_inner _ =
  assert_that _ok (is_ok_and_holds (equal_to 3));
  assert_fails_naming ~substring:"Values should be equal" (fun () ->
      assert_that _ok (is_ok_and_holds (equal_to 4)))

let test_is_ok_and_holds_prints_status_on_error _ =
  assert_fails_naming ~substring:"NotFound" (fun () ->
      assert_that _not_found (is_ok_and_holds (equal_to 3)))

let test_is_error _ =
  assert_that _not_found is_error;
  assert_fails_naming ~substring:"Expected Error but got Ok" (fun () ->
      assert_that _ok is_error)

let test_is_error_with_code _ =
  assert_that _not_found (is_error_with Status.NotFound);
  assert_that _invalid (is_error_with Status.Invalid_argument)

let test_is_error_with_wrong_code_fails _ =
  assert_fails_naming ~substring:"Expected error code" (fun () ->
      assert_that _not_found (is_error_with Status.Invalid_argument))

let test_is_error_with_msg _ =
  assert_that _invalid
    (is_error_with Status.Invalid_argument ~msg:"must be positive");
  assert_fails_naming ~substring:"Expected error message to contain" (fun () ->
      assert_that _invalid
        (is_error_with Status.Invalid_argument ~msg:"too large"))

let test_is_error_with_fails_on_ok _ =
  assert_fails_naming ~substring:"Expected Error but got Ok" (fun () ->
      assert_that _ok (is_error_with Status.NotFound))

let suite =
  "Status_matchers"
  >::: [
         "is_ok_passes_on_ok" >:: test_is_ok_passes_on_ok;
         "is_ok_prints_status_on_error" >:: test_is_ok_prints_status_on_error;
         "is_ok_and_holds_applies_inner" >:: test_is_ok_and_holds_applies_inner;
         "is_ok_and_holds_prints_status_on_error"
         >:: test_is_ok_and_holds_prints_status_on_error;
         "is_error" >:: test_is_error;
         "is_error_with_code" >:: test_is_error_with_code;
         "is_error_with_wrong_code_fails"
         >:: test_is_error_with_wrong_code_fails;
         "is_error_with_msg" >:: test_is_error_with_msg;
         "is_error_with_fails_on_ok" >:: test_is_error_with_fails_on_ok;
       ]

let () = run_test_tt_main suite
