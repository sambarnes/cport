# @dev An order contains eleven components: an offerer, a zone (or account that
#      can cancel the order or restrict who can fulfill the order depending on
#      the type), the order type (specifying partial fill support as well as
#      restricted order status), the start and end time, a hash that will be
#      provided to the zone when validating restricted orders, a salt, a key
#      corresponding to a given conduit, a nonce, and an arbitrary number of
#      offer items that can be spent along with consideration items that must
#      be received by their respective recipient.
struct OrderComponents:
    member offerer: felt  # address
    member zone: felt  # address

    member offer_len: felt
    member offer: *OfferItem

    member consideration_len: felt
    member consideration: *ConsiderationItem

    member order_type: felt  # OrderType enum
    member start_time: felt
    member end_time: felt
    member zoneHash: felt  # bytes32
    member salt: felt
    member conduitKey: felt  # bytes32
    member nonce: felt
end


# @dev An offer item has five components: an item type (ETH or other native
#      tokens, ERC20, ERC721, and ERC1155, as well as criteria-based ERC721 and
#      ERC1155), a token address, a dual-purpose "identifierOrCriteria"
#      component that will either represent a tokenId or a merkle root
#      depending on the item type, and a start and end amount that support
#      increasing or decreasing amounts over the duration of the respective
#      order.
struct OfferItem:
    member item_type: felt  # ItemType
    member token: felt  # address
    member identifier_or_criteria: felt
    member start_amount: felt
    member end_amount: felt
end


# @dev A consideration item has the same five components as an offer item and
#      an additional sixth component designating the required recipient of the
#      item.
struct ConsiderationItem:
    member item_type: felt  # ItemType
    member token: felt  # address
    member identifier_or_criteria: felt
    member start_amount: felt
    member end_amount: felt
    member recipient: felt  # address
end


# @dev A spent item is translated from a utilized offer item an has four
#      components: an item type (ETH or other native tokens, ERC20, ERC721, and
#      ERC1155), a token address, a tokenId, and an amount.
struct SpentItem:
    member item_type: felt  # ItemType
    member token: felt  # address
    member identifier: felt
    member amount: felt
end


# @dev A received item is translated from a utilized consideration item and has
#      the same four components as a spent item, as well as an additional fifth
#      component designating the required recipient of the item.
struct ReceivedItem:
    member item_type: felt  # ItemType
    member token: felt  # address
    member identifier: felt
    member amount: felt
    member recipient: felt  # address
end


# @dev For basic orders involving ETH / native / ERC20 <=> ERC721 / ERC1155
#      matching, a group of six functions may be called that only requires a
#      subset of the usual order arguments. Note the use of a "basicOrderType"
#      enum; this represents both the usual order type as well as the "route"
#      of the basic order (a simple derivation function for the basic order
#      type is `basicOrderType = orderType + (4 * basicOrderRoute)`.)
struct BasicOrderParameters:
    member consideration_token: felt  # address
    member consideration_identifier: felt
    member consideration_amount: felt
    member offerer: felt  # felt
    member zone: felt  # address
    member offer_token: felt  # address
    member offer_identifier: felt
    member offer_amount: felt
    member basic_order_type: felt  # BasicOrderType
    member start_time: felt
    member end_time: felt
    member zone_hash: felt  # bytes32
    member salt: felt
    member offerer_conduit_key: felt  # bytes32
    member fulfiller_conduit_key: felt  # bytes32
    member total_original_additional_recipients: felt
    member additional_recipients_len: felt
    member additional_recipients: *AdditionalRecipient
    member signature_len: felt
    member signature: *felt  # bytes
end


# @dev Basic orders can supply any number of additional recipients, with the
#      implied assumption that they are supplied from the offered ETH (or other
#      native token) or ERC20 token for the order.
struct AdditionalRecipient:
    member amount: felt
    member recipient: felt  # address
end


# @dev The full set of order components, with the exception of the nonce, must
#      be supplied when fulfilling more sophisticated orders or groups of
#      orders. The total number of original consideration items must also be
#      supplied, as the caller may specify additional consideration items.
struct OrderParameters:
    member offerer: felt  # address
    member zone: felt  # address

    member offer_len: felt
    member offer: *OfferItem
    member consideration_len: felt
    member consideration: *ConsiderationItem

    member order_type: felt  # OrderType
    member start_time: felt
    member end_time: felt
    member zone_hash: felt  # bytes32
    member salt: felt
    member conduit_key: felt  # bytes32
    member total_original_consideration_items: felt
    # member offer.length
end


# @dev Orders require a signature in addition to the other order parameters.
struct Order:
    member parameters: OrderParameters
    member signature_len: felt
    member signature: *felt  # bytes
end


# @dev Advanced orders include a numerator (i.e. a fraction to attempt to fill)
#      and a denominator (the total size of the order) in addition to the
#      signature and other order parameters. It also supports an optional field
#      for supplying extra data; this data will be included in a staticcall to
#      `isValidOrderIncludingExtraData` on the zone for the order if the order
#      type is restricted and the offerer or zone are not the caller.
struct AdvancedOrder:
    member parameters: OrderParameters
    member numerator: felt  # uint120
    member denominator: felt  # uint120

    member signature_len: felt
    member signature: *felt  # bytes
    member extra_data_len: felt
    member extra_data: *felt  # bytes
end


# @dev Orders can be validated (either explicitly via `validate`, or as a
#      consequence of a full or partial fill), specifically cancelled (they can
#      also be cancelled in bulk via incrementing a per-zone nonce), and
#      partially or fully filled (with the fraction filled represented by a
#      numerator and denominator).
struct OrderStatus:
    member is_validated: felt
    member is_cancelled: felt
    member numerator: felt  # uint120
    member denominator: felt  # uint120
end


# @dev A criteria resolver specifies an order, side (offer vs. consideration),
#      and item index. It then provides a chosen identifier (i.e. tokenId)
#      alongside a merkle proof demonstrating the identifier meets the required
#      criteria.
struct CriteriaResolver:
    member order_index: felt
    member side: felt  # Side
    member index: felt
    member identifier: felt
    member criteria_proof_len: felt
    member criteria_proof: *felt  # bytes32[]
end


# @dev A fulfillment is applied to a group of orders. It decrements a series of
#      offer and consideration items, then generates a single execution
#      element. A given fulfillment can be applied to as many offer and
#      consideration items as desired, but must contain at least one offer and
#      at least one consideration that match. The fulfillment must also remain
#      consistent on all key parameters across all offer items (same offerer,
#      token, type, tokenId, and conduit preference) as well as across all
#      consideration items (token, type, tokenId, and recipient).
struct Fulfillment:
    member offer_components_len: felt
    member offer_components: *FulfillmentComponent
    member consideration_components_len: felt
    member consideration_components: *FulfillmentComponent
end


# @dev Each fulfillment component contains one index referencing a specific
#      order and another referencing a specific offer or consideration item.
struct FulfillmentComponent:
    member order_index: felt
    member item_index: felt
end


# @dev An execution is triggered once all consideration items have been zeroed
#      out. It sends the item in question from the offerer to the item's
#      recipient, optionally sourcing approvals from either this contract
#      directly or from the offerer's chosen conduit if one is specified. An
#      execution is not provided as an argument, but rather is derived via
#      orders, criteria resolvers, and fulfillments (where the total number of
#      executions will be less than or equal to the total number of indicated
#      fulfillments) and returned as part of `matchOrders`.
struct Execution:
    member item: ReceivedItem
    member offerer: felt  # address
    member conduit_key: felt  # bytes32 
end
