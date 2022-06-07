%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

from src.conduit.enums import ConduitItemType
from src.conduit.structs import ConduitTransfer
from src.interfaces.conduit import ConduitInterface


func setup{syscall_ptr : felt*, range_check_ptr}() -> (conduit: felt, controller: felt):
    alloc_locals

    local conduit: felt
    local controller: felt
    controller = 123
    %{ ids.conduit = deploy_contract( "./src/conduit/conduit.cairo", [ids.controller]).contract_address %}
    return (conduit=conduit, controller=controller)
end


#
# update_channel
#


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

    %{ stop_prank_callable() %}
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

    %{ stop_prank_callable() %}
    return ()
end


#
# execute
#


@view
func test_execute{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
}():
    alloc_locals

    let (local conduit, controller) = setup()
    local some_caller : felt
    some_caller = 888

    %{ stop_prank_callable = start_prank(caller_address=ids.controller, target_contract_address=ids.conduit) %}
    ConduitInterface.update_channel(contract_address=conduit, channel=some_caller, is_open=TRUE)
    %{ stop_prank_callable() %}

    let (transfers : ConduitTransfer*) = alloc()
    assert transfers[0] = ConduitTransfer(
        item_type=ConduitItemType.ERC712,
        token=123456,
        from_address=111,
        to_address=222,
        identifier=4242,
        amount=1,
    )
    %{ stop_prank_callable = start_prank(caller_address=ids.some_caller, target_contract_address=ids.conduit) %}
    let (result) = ConduitInterface.execute(
        contract_address=conduit,
        transfers_len=1,
        transfers=transfers,
    )
    %{ stop_prank_callable() %}
    
    # Make sure we've got the magic value as a response
    assert result = 1234

    # TODO: more assertions about the transfer we expect to happen

    return ()
end