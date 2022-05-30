# @dev Emit an event whenever conduit ownership is transferred.
#
# @param conduit       The conduit for which ownership has been
#                      transferred.
# @param previousOwner The previous owner of the conduit.
# @param newOwner      The new owner of the conduit.
@event
func OwnershipTransferred(conduit: felt, previous_owner: felt, new_owner: felt);
end


# @dev Emit an event whenever a new conduit is created.
#
# @param conduit    The newly created conduit.
# @param conduitKey The conduit key used to create the new conduit.
@event
func NewConduit(conduit: felt, conduit_key: felt):
end


# @dev Emit an event whenever a conduit owner registers a new potential
#      owner for that conduit.
#
# @param conduit           The conduit for which ownership may now be
#                          transferred.
# @param newPotentialOwner The new potential owner of the conduit.
@event
func PotentialOwnerUpdated(conduit: felt, new_potential_owner: felt):
end


# @dev Track the conduit key, current owner, new potential owner, and open
#      channels for each deployed conduit.
struct ConduitProperties:
    member key: felt  # bytes32 
    member owner: felt  # address
    member potential_owner: felt  # address
    member channels_len: felt
    member channels: felt*  # address[]
    # TODO: how to mapping??
    # mapping(address => uint256) channelIndexesPlusOne
end


# @title ConduitControllerInterface
# @notice ConduitControllerInterface contains all external function interfaces,
#         structs, events, and errors for the conduit controller.
@contract_interface
namespace ConduitControllerInterface:
    # @notice Deploy a new conduit using a supplied conduit key and assigning
    #         an initial owner for the deployed conduit. Note that the last
    #         twenty bytes of the supplied conduit key must match the caller
    #         and that a new conduit cannot be created if one has already been
    #         deployed using the same conduit key.
    #
    # @param conduitKey   The conduit key used to deploy the conduit. Note that
    #                     the last twenty bytes of the conduit key must match
    #                     the caller of this contract.
    # @param initialOwner The initial owner to set for the new conduit.
    #
    # @return conduit The address of the newly deployed conduit.
    func create_conduit(conduit_key: felt, initial_owner: felt) -> (conduit: felt):
    end
    
    # @notice Open or close a channel on a given conduit, thereby allowing the
    #         specified account to execute transfers against that conduit.
    #         Extreme care must be taken when updating channels, as malicious
    #         or vulnerable channels can transfer any ERC20, ERC721 and ERC1155
    #         tokens where the token holder has granted the conduit approval.
    #         Only the owner of the conduit in question may call this function.
    #
    # @param conduit The conduit for which to open or close the channel.
    # @param channel The channel to open or close on the conduit.
    # @param isOpen  A boolean indicating whether to open or close the channel.
    func updateChannel(conduit: felt, channel: felt, is_open: felt):
    end
    
    # @notice Initiate conduit ownership transfer by assigning a new potential
    #         owner for the given conduit. Once set, the new potential owner
    #         may call `acceptOwnership` to claim ownership of the conduit.
    #         Only the owner of the conduit in question may call this function.
    #
    # @param conduit The conduit for which to initiate ownership transfer.
    func transfer_ownership(conduit: felt, new_potential_owner: felt):
    end
    
    # @notice Clear the currently set potential owner, if any, from a conduit.
    #         Only the owner of the conduit in question may call this function.
    #
    # @param conduit The conduit for which to cancel ownership transfer.
    func cancel_ownership_transfer(conduit: felt):
    end
    
    # @notice Accept ownership of a supplied conduit. Only accounts that the
    #         current owner has set as the new potential owner may call this
    #         function.
    #
    # @param conduit The conduit for which to accept ownership.
    func accept_ownership(conduit: felt):
    end

    
    # @notice Retrieve the current owner of a deployed conduit.
    #
    # @param conduit The conduit for which to retrieve the associated owner.
    #
    # @return owner The owner of the supplied conduit.
    func owner_of(conduit: felt) -> (owner: felt):
    end

    
    # @notice Retrieve the conduit key for a deployed conduit via reverse
    #         lookup.
    #
    # @param conduit The conduit for which to retrieve the associated conduit
    #                key.
    #
    # @return conduitKey The conduit key used to deploy the supplied conduit.
    func get_key(conduit: felt) -> (conduit_key: felt):
    end
    
    # @notice Derive the conduit associated with a given conduit key and
    #         determine whether that conduit exists (i.e. whether it has been
    #         deployed).
    #
    # @param conduitKey The conduit key used to derive the conduit.
    #
    # @return conduit The derived address of the conduit.
    # @return exists  A boolean indicating whether the derived conduit has been
    #                 deployed or not.
    func get_conduit(conduit_key: felt) -> (conduit: felt, exists: felt):
    end
    
    # @notice Retrieve the potential owner, if any, for a given conduit. The
    #         current owner may set a new potential owner via
    #         `transferOwnership` and that owner may then accept ownership of
    #         the conduit in question via `acceptOwnership`.
    #
    # @param conduit The conduit for which to retrieve the potential owner.
    #
    # @return potentialOwner The potential owner, if any, for the conduit.
    func get_potential_owner(conduit: felt) -> (potential_owner: felt):
    end
    
    # @notice Retrieve the status (either open or closed) of a given channel on
    #         a conduit.
    #
    # @param conduit The conduit for which to retrieve the channel status.
    # @param channel The channel for which to retrieve the status.
    #
    # @return isOpen The status of the channel on the given conduit.
    func get_channel_status(conduit: felt, channel: felt) -> (is_open: felt):
    end
    
    # @notice Retrieve the total number of open channels for a given conduit.
    #
    # @param conduit The conduit for which to retrieve the total channel count.
    #
    # @return totalChannels The total number of open channels for the conduit.
    func get_total_channels(conduit: felt) -> (total_channels: felt):
    end
    
    # @notice Retrieve an open channel at a specific index for a given conduit.
    #         Note that the index of a channel can change as a result of other
    #         channels being closed on the conduit.
    #
    # @param conduit      The conduit for which to retrieve the open channel.
    # @param channelIndex The index of the channel in question.
    #
    # @return channel The open channel, if any, at the specified channel index.
    func get_channel(conduit: felt, channel_index: felt) -> (channel: felt):
    end

    # @notice Retrieve all open channels for a given conduit. Note that calling
    #         this function for a conduit with many channels will revert with
    #         an out-of-gas error.
    #
    # @param conduit The conduit for which to retrieve open channels.
    #
    # @return channels An array of open channels on the given conduit.
    func get_channels(conduit: felt) -> (channels_len: felt, channels: felt*):
    end
    
    # @dev Retrieve the conduit creation code and runtime code hashes.
    func get_conduit_code_hashes() -> (creation_code_hash: felt, runtime_code_hash: felt):
    end

    # TODO: put these errors somewhere it makes sense

    # @dev Revert with an error when attempting to create a new conduit using a
    #      conduit key where the last twenty bytes of the key do not match the
    #      address of the caller.
    # error InvalidCreator();
    
    # @dev Revert with an error when attempting to interact with a conduit that
    #      does not yet exist.
    # error NoConduit();
    
    # @dev Revert with an error when attempting to create a conduit that
    #      already exists.
    # error ConduitAlreadyExists(address conduit);
    
    # @dev Revert with an error when attempting to update channels or transfer
    #      ownership of a conduit when the caller is not the owner of the
    #      conduit in question.
    # error CallerIsNotOwner(address conduit);
    
    # @dev Revert with an error when attempting to register a new potential
    #      owner and supplying the null address.
    # error NewPotentialOwnerIsZeroAddress(address conduit);
    
    # @dev Revert with an error when attempting to claim ownership of a conduit
    #      with a caller that is not the current potential owner for the
    #      conduit in question.
    # error CallerIsNotNewPotentialOwner(address conduit);
    
    # @dev Revert with an error when attempting to retrieve a channel using an
    #      index that is out of range.
    # error ChannelOutOfRange(address conduit);
end
