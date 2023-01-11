//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract CryptoTransfer {
    address public owner;
    uint256 public balance;

    event TransferReceived(address _from, uint256 _amount);
    event TranferSent(address _from, address _to, uint256 _amount);

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        balance += msg.value;
        emit TransferReceived(msg.sender, msg.value);
    }

    function withdraw(uint256 amount, address payable to) public {
        require(msg.sender == owner, "Only owner can withdraw funds");
        require(amount <= balance, "Insufficient funds");

        to.transfer(amount);
        balance -= amount;
        emit TranferSent(msg.sender, to, amount);
    }

    function transferERC20(
        IERC20 token,
        address to,
        uint256 amount
    ) public {
        require(msg.sender == owner, "Only owner can withdraw funds");
        uint256 erc20balance = token.balanceOf(address(this));
        require(amount <= erc20balance, "Insufficient funds");
        token.transfer(to, amount);
        emit TranferSent(msg.sender, to, amount);
    }

    function getERC20TokenBalance(IERC20 token) public view returns (uint256) {
        uint256 erc20tokenbalance = token.balanceOf(address(this));
        return erc20tokenbalance;
    }
}
