pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


contract XdexBar is ERC20("XdexBar", "xXDEX"){
    using SafeMath for uint256;
    IERC20 public xdex;

    constructor(IERC20 _xdex) public {
        xdex = _xdex;
    }

    // Enter the bar. Pay some XDEXs. Earn some shares.
    function enter(uint256 _amount) public {
        uint256 totalXdex = xdex.balanceOf(address(this));
        uint256 totalShares = totalSupply();
        if (totalShares == 0 || totalXdex == 0) {
            _mint(msg.sender, _amount);
        } else {
            uint256 what = _amount.mul(totalShares).div(totalXdex);
            _mint(msg.sender, what);
        }
        xdex.transferFrom(msg.sender, address(this), _amount);
    }

    // Leave the bar. Claim back your XDEXs.
    function leave(uint256 _share) public {
        uint256 totalShares = totalSupply();
        uint256 what = _share.mul(xdex.balanceOf(address(this))).div(totalShares);
        _burn(msg.sender, _share);
        xdex.transfer(msg.sender, what);
    }
}