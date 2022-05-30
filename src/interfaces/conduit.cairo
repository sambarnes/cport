from src.lib.conduit_structs import ConduitTransfer, ConduitBatch1155Transfer


# @dev Emit an event whenever a channel is opened or closed.
#
# @param channel The channel that has been updated.
# @param open    A boolean indicating whether the conduit is open or not.
@event
func ChannelUpdated(channel: felt, open: felt):
end


# @title ConduitInterface
# @author 0age
# @notice ConduitInterface contains all external function interfaces, events,
#         and errors for conduit contracts.
@contract_interface
namespace ConduitInterface:
    # @notice Execute a sequence of ERC20/721/1155 transfers. Only a caller
    #         with an open channel can call this function.
    #
    # @param transfers The ERC20/721/1155 transfers to perform.
    #
    # @return magicValue A magic value indicating that the transfers were
    #                    performed successfully.
    func execute(
        conduit_transfers_len: felt,
        conduit_transfers: ConduitTransfer*
    ) -> (magic_value: felt):  # bytes4
    end
    
    # @notice Execute a sequence of batch 1155 transfers. Only a caller with an
    #         open channel can call this function.
    #
    # @param batch1155Transfers The 1155 batch transfers to perform.
    #
    # @return magicValue A magic value indicating that the transfers were
    #                    performed successfully.
    func execute_batch_1155(
        batch_1155_transfers_len: felt,
        batch_1155_transfers: ConduitBatch1155Transfer*
    ) -> (magic_value: felt):  # bytes4
    end

    
    # @notice Execute a sequence of transfers, both single and batch 1155. Only
    #         a caller with an open channel can call this function.
    #
    # @param standardTransfers  The ERC20/721/1155 transfers to perform.
    # @param batch1155Transfers The 1155 batch transfers to perform.
    #
    # @return magicValue A magic value indicating that the transfers were
    #                    performed successfully.
    func execute_with_batch_1155(
        standard_transfers_len: felt,
        standard_transfers: ConduitTransfer*,
        batch_1155_transfers_len: felt,
        batch_1155_transfers: ConduitBatch1155Transfer*
    ) -> (magic_value: felt):  # bytes4
    end

    
    # @notice Open or close a given channel. Only callable by the controller.
    #
    # @param channel The channel to open or close.
    # @param isOpen  The status of the channel (either open or closed).
    func update_channel(channel: felt, is_open: felt):
    end

    #
    # TODO: where to add these errors? idk if they can go in namespaces, probably
    # need consts elsewhere instead
    #

    # @dev Revert with an error when attempting to execute transfers using a
    #      caller that does not have an open channel.
    # error ChannelClosed();
    
    # @dev Revert with an error when attempting to execute a transfer for an
    #      item that does not have an ERC20/721/1155 item type.
    # error InvalidItemType();
    
    # @dev Revert with an error when attempting to update the status of a
    #      channel from a caller that is not the conduit controller.
    # error InvalidController();
    
    # @dev Revert with an error when attempting to execute an 1155 batch
    #      transfer using calldata not produced by default ABI encoding or with
    #      different lengths for ids and amounts arrays.
    # error Invalid1155BatchTransferEncoding();
end
