%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_equal
from starkware.cairo.common.uint256 import Uint256, uint256_add
from starkware.starknet.common.syscalls import get_caller_address

from src.interfaces.conduit import ChannelUpdated
from src.conduit.structs import ConduitTransfer, ConduitBatch1155Transfer

#
# Storage
#


@storage_var
func _controller() -> (address : felt):
end


@storage_var
func _channels(address: felt) -> (is_registered : felt):
end


#
# Conditions
#


# Revert if the calling account is not the controller
func require_controller{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }():
    let (msg_sender) = get_caller_address()
    let (registered_controller) = _controller.read()
    with_attr error_message("invalid controller"):
        assert registered_controller = msg_sender
    end
    return ()
end


# Revert if the calling account's channel is not open
func require_channel_open{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }():
    let (msg_sender) = get_caller_address()
    let (is_open) = _channels.read(address=msg_sender)
    with_attr error_message("channel closed"):
        assert is_open = TRUE
    end
    return ()
end


#
# Entrypoint
#


@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    controller : felt
):
    # NOTE: protostar can't prank deployment caller b/c doesn't have deployed address yet,
    #       switched to passing in controller instead.
    _controller.write(value=controller)
    return ()
end


#
# Admin
#


@view
func is_open{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(channel : felt) -> (is_open : felt):
    let (is_open) = _channels.read(address=channel)
    return (is_open)
end


@external
func update_channel{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        channel : felt,
        is_open : felt
    ):
    require_controller()

    let (_current_status) = _channels.read(address=channel)
    with_attr error_message("channel status already set"):
        assert_not_equal(_current_status, is_open)
    end

    _channels.write(address=channel, value=is_open)
    ChannelUpdated.emit(channel=channel, open=is_open)

    return ()
end


#
# Execution
#


@external
func execute{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        transfers_len : felt,
        transfers : ConduitTransfer*
    ) -> (
        magic_value: felt
    ):
    require_channel_open()

    # TODO
    return (magic_value=1234)
end


# @dev Internal function to transfer a given item.
#
# @param item     The item to transfer, including an amount and recipient.
func _transfer{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(item : ConduitTransfer):
    # TODO
    return ()
end
