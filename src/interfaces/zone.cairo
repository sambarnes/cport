from src.lib.consideration_structs import AdvancedOrder, CriteriaResolver

@contract_interface
namespace ZoneInterface:
    # Called by Consideration whenever extraData is not provided by the caller.
    func is_valid_order(
        order_hash: felt,  # bytes32
        caller: felt,  # address
        offerer: felt,  # address
        zone_hash: felt,  # bytes32
    ) -> (valid_order_magic_value: felt):  # bytes4
    end

    # Called by Consideration whenever any extraData is provided by the caller.
    func is_valid_order_including_exta_data(
        order_hash: felt,  # bytes32
        caller: felt,  # address
        order: AdvancedOrder,
        pre_order_hashes_len: felt,
        pre_order_hashes: *felt,  # bytes32
        criteria_resolvers_len: felt,
        criteria_resolvers: *CriteriaResolver,
    ) -> (valid_order_magic_value: felt):  # bytes4
    end
end
