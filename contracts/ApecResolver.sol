// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "./optidomains/DiamondResolverUtil.sol";

bytes32 constant APEC_RESOLVER_STORAGE = keccak256("apecgreen.resolver.ApecResolver");

library ApecResolverStorage {
    struct Layout {
        mapping(bytes32 => bytes32) apec;
    }

    bytes32 internal constant STORAGE_SLOT =
        keccak256('apecgreen.contracts.storage.ApecResolverStorage');

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}

// Fallback to use traditional mode
contract ApecResolver is DiamondResolverUtil, IERC165 {
    function setApecKyc(bytes32 node, bytes32 kycHash) public authorised(node) {
        ApecResolverStorage.Layout storage l = ApecResolverStorage.layout();
        l.apec[node] = kycHash;
    }

    function apecKyc(bytes32 node) public view returns(bytes32) {
        ApecResolverStorage.Layout storage l = ApecResolverStorage.layout();
        return l.apec[node];
    }

    function supportsInterface(
        bytes4 interfaceID
    ) public view virtual override(IERC165) returns (bool) {
        return false;
    }
}