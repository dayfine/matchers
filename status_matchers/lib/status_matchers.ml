open Core
open OUnit2

let _fail_on_error status =
  assert_failure ("Expected Ok but got Error: " ^ Status.show status)

let is_ok result =
  match result with Ok _ -> () | Error status -> _fail_on_error status

let is_ok_and_holds matcher result =
  match result with
  | Ok value -> matcher value
  | Error status -> _fail_on_error status

let is_error result = Matchers.is_error result

let _check_error_code ~expected_code (status : Status.t) =
  if not (Status.equal_code status.code expected_code) then
    assert_failure
      (Printf.sprintf "Expected error code %s but got %s"
         (Status.show_code expected_code)
         (Status.show_code status.code))

let _check_error_message ~substring (status : Status.t) =
  let msg_str = Status.show status in
  if not (String.is_substring msg_str ~substring) then
    assert_failure
      (Printf.sprintf "Expected error message to contain '%s' but got: %s"
         substring msg_str)

let is_error_with ?msg expected_code result =
  Matchers.is_error_and_holds
    (fun status ->
      _check_error_code ~expected_code status;
      Option.iter msg ~f:(fun substring ->
          _check_error_message ~substring status))
    result
