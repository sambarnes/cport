%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin

from src.interfaces.conduit import ConduitInterface


func setup{syscall_ptr : felt*, range_check_ptr}() -> (conduit: felt, controller: felt):
    alloc_locals

    local conduit: felt
    local controller: felt
    controller = 123
    %{ ids.conduit = deploy_contract( "./src/conduit/conduit.cairo", [ids.controller]).contract_address %}
    return (conduit=conduit, controller=controller)
end


@view
func test_conduit_update_channel_not_controller{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
}():
    alloc_locals
    let (local conduit, controller) = setup()

    %{ expect_revert(error_message="invalid controller") %}
    ConduitInterface.update_channel(contract_address=conduit, channel=1, is_open=TRUE)
    return ()
end


@view
func test_conduit_update_channel_already_set{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
}():
    alloc_locals
    let (local conduit, controller) = setup()

    %{ stop_prank_callable = start_prank(caller_address=ids.controller, target_contract_address=ids.conduit) %}

    %{ expect_revert(error_message="channel status already set") %}
    ConduitInterface.update_channel(contract_address=conduit, channel=1, is_open=FALSE)

    %{ stop_prank_callable(target_contract_address=ids.conduit) %}
    return ()
end


@view
func test_conduit_update_channel_successfully{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
}():
    alloc_locals
    let (local conduit, controller) = setup()

    %{ stop_prank_callable = start_prank(caller_address=ids.controller, target_contract_address=ids.conduit) %}
    ConduitInterface.update_channel(contract_address=conduit, channel=1, is_open=TRUE)

    %{ expect_revert(error_message="channel status already set") %}
    ConduitInterface.update_channel(contract_address=conduit, channel=1, is_open=TRUE)

    %{ stop_prank_callable(target_contract_address=ids.conduit) %}
    return ()
end
