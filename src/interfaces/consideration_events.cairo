%lang starknet

from src.lib.consideration_structs import ReceivedItem, SpentItem

# @dev Emit an event whenever an order is successfully fulfilled.
#
# @param order_hash     The hash of the fulfilled order.
# @param offerer        The offerer of the fulfilled order.
# @param zone           The zone of the fulfilled order.
# @param fulfiller      The fulfiller of the order, or the null address if
#                       there is no specific fulfiller (i.e. the order is
#                       part of a group of orders).
# @param offer          The offer items spent as part of the order.
# @param consideration  The consideration items received as part of the
#                       order along with the recipients of each item.
@event
func OrderFulfilled(
    order_hash: felt,
    offerer: felt,
    zone: felt,
    fulfiller: felt,
    offer_len: felt,
    offer: SpentItem*,
    consideration_len: felt,
    consideration: ReceivedItem*
):
end


# @dev Emit an event whenever an order is successfully cancelled.
#
# @param order_hash The hash of the cancelled order.
# @param offerer    The offerer of the cancelled order.
# @param zone       The zone of the cancelled order.
@event
func OrderCancelled(order_hash: felt, offerer: felt, zone: felt):
end


# @dev Emit an event whenever an order is explicitly validated. Note that
#      this event will not be emitted on partial fills even though they do
#      validate the order as part of partial fulfillment.
#
# @param order_hash The hash of the validated order.
# @param offerer    The offerer of the validated order.
# @param zone       The zone of the validated order.
@event
func OrderValidated(order_hash: felt, offerer: felt, zone: felt):
end


# @dev Emit an event whenever a nonce for a given offerer is incremented.
#
# @param new_nonce The new nonce for the offerer.
# @param offerer   The offerer in question. 
@event
func NonceIncremented(new_nonce: felt, offerer: felt):
end
