from src.conduit.enums import ConduitItemType


struct ConduitTransfer:
    member item_type : felt  # ConduitItemType
    member token : felt  # address
    member from_address : felt
    member to_address : felt
    member identifier : felt
    member amount : felt
end


struct ConduitBatch1155Transfer:
    member token : felt  # address
    member from_address : felt
    member to_address : felt
    member ids_len : felt
    member ids : felt*
    member amounts_len : felt
    member amounts : felt*
end
