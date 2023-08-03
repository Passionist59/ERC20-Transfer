// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract USDC is ERC20, Ownable {

    using SafeMath for uint256;

    mapping(address => bool) public whitelist;

    constructor(
        string memory name,
        string memory symbol
    ) ERC20(name, symbol) {}

    /**
     * @dev Token mint function
    */
    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
        whitelist[account] = true; // add the address to the whitelist
    }

    /**
     * @dev Token burn function
    */
    function burn(address account, uint256 amount) public onlyOwner {
        _burn(account, amount);
        whitelist[account] = false; // remove the address from the whitelist
    }

    /**
     * @dev Token airdrop function
     */
    function airdrop(address[] memory recipients, uint256[] memory amounts) public onlyOwner {
        require(recipients.length == amounts.length, "Invalid input length");

        for (uint256 i = 0; i < recipients.length; i++) {
            _mint(recipients[i], amounts[i]);
            whitelist[recipients[i]] = true; // add the address to the whitelist
        }
    }

    /**
    * @dev Add whitelist function
    */
    function addWhiteList(address account) public onlyOwner {
        whitelist[account] = true;
    }

    /**
    * @dev Remove whitelist function
    */
    function removeWhiteList(address account) public onlyOwner {
        whitelist[account] = false;
    }

    /**
     * @dev Transfer tokens from one address to another
     * @param recipient The address to transfer tokens to
     * @param amount The amount of tokens to transfer
     * @return True if successful, false otherwise
     */
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        // require(whitelist[recipient], "Address not in whitelist");
        return super.transfer(recipient, amount);
    }

    /**
     * @dev Transfer tokens from one address to another using an allowance
     * @param sender The address to transfer tokens from
     * @param recipient The address to transfer tokens to
     * @param amount The amount of tokens to transfer
     * @return True if successful, false otherwise
     */
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        // require(whitelist[recipient], "Address not in whitelist");
        return super.transferFrom(sender, recipient, amount);
    }
}
