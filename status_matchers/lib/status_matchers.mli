(** Matchers for [Status.status_or] results.

    Open this after [Matchers]. [is_ok], [is_ok_and_holds] and [is_error] here
    shadow the generic versions in [Matchers] with ones specialised to
    [Status.status_or], so a failure prints the status. [is_error_with] checks
    the status code and, optionally, the message.

    {[
    open Matchers
    open Status_matchers

    let test_missing _ =
      assert_that (find_order "nonexistent") (is_error_with NotFound)
    ]} *)

val is_ok : 'a Status.status_or Matchers.matcher
(** [is_ok] asserts a result is [Ok]. On [Error] the failure message includes
    the status.

    Example:
    {[
    assert_that (validate_input valid_data) is_ok
    ]} *)

val is_ok_and_holds :
  'a Matchers.matcher -> 'a Status.status_or Matchers.matcher
(** [is_ok_and_holds matcher] asserts a result is [Ok] and applies [matcher] to
    the value. On [Error] the failure message includes the status.

    Example:
    {[
    assert_that result (is_ok_and_holds (float_equal 150.25))
    ]} *)

val is_error : 'a Status.status_or Matchers.matcher
(** [is_error] asserts a result is [Error], without checking the status. Use
    [is_error_with] to check the code.

    Example:
    {[
    assert_that (validate_input invalid_data) is_error
    ]} *)

val is_error_with :
  ?msg:string -> Status.code -> 'a Status.status_or Matchers.matcher
(** [is_error_with ?msg code] asserts a result is [Error] with status code
    [code]. With [~msg], it also asserts that the printed status contains [msg]
    as a substring.

    Example:
    {[
    assert_that (get_order manager "nonexistent") (is_error_with NotFound)
    ]}
    {[
    assert_that result (is_error_with Invalid_argument ~msg:"must be positive")
    ]} *)
