%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_add
from starkware.starknet.common.syscalls import get_caller_address

from src.interfaces.consideration_events import NonceIncremented

# Define a storage variable.
@storage_var
func _nonces(address: felt) -> (nonce : felt):
end

# @dev Internal function to cancel all orders from a given offerer with a
#      given zone in bulk by incrementing a nonce. Note that only the
#      offerer may increment the nonce.
#
# @return new_nonce The new nonce.
func _increment_nonce{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (new_nonce: felt):
    let (msg_sender) = get_caller_address()
    let (current_nonce) = _nonces.read(address=msg_sender)
    let new_nonce = current_nonce + 1
    _nonces.write(address=msg_sender, value=new_nonce)

    NonceIncremented.emit(new_nonce=new_nonce, offerer=msg_sender)
    return (new_nonce=new_nonce)
end

# @dev Internal view function to retrieve the current nonce for a given
#      offerer.
#
# @param offerer The offerer in question.
#
# @return current_nonce The current nonce.
func _get_nonce{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(address: felt) -> (current_nonce : felt):
    let (current_nonce) = _nonces.read(address=address)
    return (current_nonce=current_nonce)
end
