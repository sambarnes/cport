struct OrderType:
    # 0: no partial fills, anyone can execute
    FULL_OPEN: felt

    # 1: partial fills supported, anyone can execute
    PARTIAL_OPEN: felt

    # 2: no partial fills, only offerer or zone can execute
    FULL_RESTRICTED: felt

    # 3: partial fills supported, only offerer or zone can execute
    PARTIAL_RESTRICTED: felt
end


struct BasicOrderType:
    # 0: no partial fills, anyone can execute
    ETH_TO_ERC721_FULL_OPEN: felt

    # 1: partial fills supported, anyone can execute
    ETH_TO_ERC721_PARTIAL_OPEN: felt

    # 2: no partial fills, only offerer or zone can execute
    ETH_TO_ERC721_FULL_RESTRICTED: felt

    # 3: partial fills supported, only offerer or zone can execute
    ETH_TO_ERC721_PARTIAL_RESTRICTED: felt

    # 4: no partial fills, anyone can execute
    ETH_TO_ERC1155_FULL_OPEN: felt

    # 5: partial fills supported, anyone can execute
    ETH_TO_ERC1155_PARTIAL_OPEN: felt

    # 6: no partial fills, only offerer or zone can execute
    ETH_TO_ERC1155_FULL_RESTRICTED: felt

    # 7: partial fills supported, only offerer or zone can execute
    ETH_TO_ERC1155_PARTIAL_RESTRICTED: felt

    # 8: no partial fills, anyone can execute
    ERC20_TO_ERC721_FULL_OPEN: felt

    # 9: partial fills supported, anyone can execute
    ERC20_TO_ERC721_PARTIAL_OPEN: felt

    # 10: no partial fills, only offerer or zone can execute
    ERC20_TO_ERC721_FULL_RESTRICTED: felt

    # 11: partial fills supported, only offerer or zone can execute
    ERC20_TO_ERC721_PARTIAL_RESTRICTED: felt

    # 12: no partial fills, anyone can execute
    ERC20_TO_ERC1155_FULL_OPEN: felt

    # 13: partial fills supported, anyone can execute
    ERC20_TO_ERC1155_PARTIAL_OPEN: felt

    # 14: no partial fills, only offerer or zone can execute
    ERC20_TO_ERC1155_FULL_RESTRICTED: felt

    # 15: partial fills supported, only offerer or zone can execute
    ERC20_TO_ERC1155_PARTIAL_RESTRICTED: felt

    # 16: no partial fills, anyone can execute
    ERC721_TO_ERC20_FULL_OPEN: felt

    # 17: partial fills supported, anyone can execute
    ERC721_TO_ERC20_PARTIAL_OPEN: felt

    # 18: no partial fills, only offerer or zone can execute
    ERC721_TO_ERC20_FULL_RESTRICTED: felt

    # 19: partial fills supported, only offerer or zone can execute
    ERC721_TO_ERC20_PARTIAL_RESTRICTED: felt

    # 20: no partial fills, anyone can execute
    ERC1155_TO_ERC20_FULL_OPEN: felt

    # 21: partial fills supported, anyone can execute
    ERC1155_TO_ERC20_PARTIAL_OPEN: felt

    # 22: no partial fills, only offerer or zone can execute
    ERC1155_TO_ERC20_FULL_RESTRICTED: felt

    # 23: partial fills supported, only offerer or zone can execute
    ERC1155_TO_ERC20_PARTIAL_RESTRICTED: felt
end


struct BasicOrderRouteType:
    # 0: provide Ether (or other native token) to receive offered ERC721 item.
    ETH_TO_ERC721: felt

    # 1: provide Ether (or other native token) to receive offered ERC1155 item.
    ETH_TO_ERC1155: felt

    # 2: provide ERC20 item to receive offered ERC721 item.
    ERC20_TO_ERC721: felt

    # 3: provide ERC20 item to receive offered ERC1155 item.
    ERC20_TO_ERC1155: felt

    # 4: provide ERC721 item to receive offered ERC20 item.
    ERC721_TO_ERC20: felt

    # 5: provide ERC1155 item to receive offered ERC20 item.
    ERC1155_TO_ERC20: felt
end


struct ItemType:
    # 0: ETH on mainnet, MATIC on polygon, etc.
    NATIVE: felt

    # 1: ERC20 items (ERC777 and ERC20 analogues could also technically work)
    ERC20: felt

    # 2: ERC721 items
    ERC721: felt

    # 3: ERC1155 items
    ERC1155: felt

    # 4: ERC721 items where a number of tokenIds are supported
    ERC721_WITH_CRITERIA: felt

    # 5: ERC1155 items where a number of ids are supported
    ERC1155_WITH_CRITERIA: felt
end


struct Side:
    # 0: Items that can be spent
    OFFER: felt
    
    # 1: Items that must be received
    CONSIDERATION: felt
end