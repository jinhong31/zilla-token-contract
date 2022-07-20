// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

contract ZillaToken is ERC20, Ownable {

	// Tue Mar 18 2031 17:46:47 GMT+0000
	uint256 constant public END = 1954777607;
	uint256 constant public MAX_ENTRY = 15 * (10 ** 8);
	uint256 constant public SALE_ENTRY = 30000;
	uint8 constant private _DECIMALS = 18;
	address public communityAddress = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;
	address public devAddress = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2;
	address public teamAddress = 0x17F6AD8Ef982297579C203069C1DbfFE4348c372;
	address public farmContractAddr;
	address public burnContractAddr;
	uint256 public price = 0.05 ether;

	constructor() ERC20('Zilla', 'zilla') { 
		_mint(address(this), SALE_ENTRY * (10 ** _DECIMALS));
	}

	function mint(address _user, uint256 _mintAmount) public payable {
		require(block.timestamp <= END, "Expired Sale"); 
		require(msg.sender == farmContractAddr, "Not accessible Contract");
		require(totalSupply() + _mintAmount <= MAX_ENTRY * (10 ** _DECIMALS), "MAX ENTRY EXCEED");
		_mint(_user, _mintAmount);
	}

	function buy(uint256 _buyAmount) external payable {
		require(balanceOf(address(this)) >= _buyAmount, 'Not enough Zilla');
		require(msg.value >= _buyAmount * price / (10 ** _DECIMALS), "Not enough funds!");
		_transfer(address(this), msg.sender, _buyAmount);
	}

	function burn(address _from, uint256 _amount) external {
		require(msg.sender == burnContractAddr, "Not accessible Contract");
    require(balanceOf(_from) >= _amount, "burn amount exceeds balance");
		_transfer(_from, communityAddress, _amount * 2 / 100);
		_transfer(_from, devAddress, _amount * 2 / 100);
		_transfer(_from, teamAddress, _amount * 2 / 100);
		_transfer(_from, address(this), _amount / 100);
		_burn(_from, _amount * 93 / 100);
	}

	function setFarmContractAddr(address _address) public onlyOwner{
		farmContractAddr = _address;
	}

	function setBurnContractAddr(address _address) public onlyOwner{
		burnContractAddr = _address;
	}

	function setPrice(uint256 _price) public onlyOwner{
		price = _price;
	}
}