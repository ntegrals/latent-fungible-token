// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LatentFungibleToken is ERC20, Ownable(msg.sender) {
    struct MintMetadata {
        uint256 amount;
        uint256 time;
        uint256 delay;
    }

    mapping(address => MintMetadata[]) private _mints;

    event TokensMinted(address indexed to, uint256 amount, uint256 delay);

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount, uint256 delay) public onlyOwner {
        require(to != address(0), "LFT: mint to the zero address");

        _mint(to, amount);
        _mints[to].push(MintMetadata({ amount: amount, time: block.timestamp, delay: delay }));

        emit TokensMinted(to, amount, delay);
    }

    function balanceOfMatured(address user) public view returns (uint256) {
        uint256 maturedBalance = 0;
        for (uint256 i = 0; i < _mints[user].length; i++) {
            if (block.timestamp >= _mints[user][i].time + _mints[user][i].delay) {
                maturedBalance += _mints[user][i].amount;
            }
        }
        return maturedBalance;
    }

    function getMints(address user) public view returns (MintMetadata[] memory) {
        return _mints[user];
    }

    function mints(address user, uint256 id) public view returns (MintMetadata memory) {
        require(id < _mints[user].length, "LFT: mint id out of bounds");
        return _mints[user][id];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        require(balanceOfMatured(_msgSender()) >= amount, "LFT: transfer amount exceeds matured balance");
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        require(balanceOfMatured(sender) >= amount, "LFT: transfer amount exceeds matured balance");
        return super.transferFrom(sender, recipient, amount);
    }
}
