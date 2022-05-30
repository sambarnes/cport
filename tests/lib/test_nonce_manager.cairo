%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from src.lib.nonce_manager import _get_nonce, _increment_nonce


@view
func test_nonce_manager{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local alice : felt
    alice = 123

    let (current_nonce) = _get_nonce(address=alice)
    assert current_nonce = 0

    %{ stop_prank_callable = start_prank(ids.alice) %}
    %{ expect_events({"name": "NonceIncremented", "data": [1, ids.alice]}, {"name": "NonceIncremented", "data": [2, ids.alice]}) %}
    _increment_nonce()
    _increment_nonce()
    %{ stop_prank_callable() %}

    let (new_nonce) = _get_nonce(address=alice)
    assert new_nonce = 2
    return ()
end
