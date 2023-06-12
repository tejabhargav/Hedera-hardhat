// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract tradeOffer {
    using Counters for Counters.Counter;

    address public token1;
    address public token2;
    address public token3;
    address public token4;
    address public token5;


    struct Offer {
        uint256 offerId;

        address offerCreator;

        uint256 offerAmount1;
        uint256 offerAmount2;
        uint256 offerAmount3;
        uint256 offerAmount4;
        uint256 offerAmount5;

        uint256 wantedAmount1;
        uint256 wantedAmount2;
        uint256 wantedAmount3;
        uint256 wantedAmount4;
        uint256 wantedAmount5;

        uint256 offerTimestamp;

        bool offerStatus;
    }

    mapping (uint256 => Offer) offerMapping;

    Counters.Counter private offerCounter;

    constructor(
        address _token1,
        address _token2,
        address _token3,
        address _token4,
        address _token5
    ) {
        token1 = _token1;
        token2 = _token2;
        token3 = _token3;
        token4 = _token4;
        token5 = _token5;
    }

    function makeOffer(
        uint256 _offerAmount1,
        uint256 _offerAmount2,
        uint256 _offerAmount3,
        uint256 _offerAmount4,
        uint256 _offerAmount5,

        uint256 _wantedAmount1,
        uint256 _wantedAmount2,
        uint256 _wantedAmount3,
        uint256 _wantedAmount4,
        uint256 _wantedAmount5
    ) public payable {
        require(
            (
                _offerAmount1 > 0 ||
                _offerAmount2 > 0 ||
                _offerAmount3 > 0 ||
                _offerAmount4 > 0 ||
                _offerAmount5 > 0
            ) && (
                _wantedAmount1 > 0 ||
                _wantedAmount2 > 0 ||
                _wantedAmount3 > 0 ||
                _wantedAmount4 > 0 ||
                _wantedAmount5 > 0

            ),
            "Offer Invalid"
        );

        // Transfer token1 from the sender to this contract
        if (_offerAmount1 > 0) {
            require(
                IERC20(token1).transferFrom(
                    msg.sender,
                    address(this),
                    _offerAmount1 * (10 ** 18)
                ),
                "Transfer of token1 failed"
            );
        }

        // Transfer token2 from the sender to this contract
        if (_offerAmount2 > 0) {
            require(
                IERC20(token2).transferFrom(
                    msg.sender,
                    address(this),
                    _offerAmount2 * (10 ** 18)
                ),
                "Transfer of token2 failed"
            );
        }

        // Transfer token3 from the sender to this contract
        if (_offerAmount3 > 0) {
            require(
                IERC20(token3).transferFrom(
                    msg.sender,
                    address(this),
                    _offerAmount3 * (10 ** 18)
                ),
                "Transfer of token3 failed"
            );
        }

        // Transfer token4 from the sender to this contract
        if (_offerAmount4 > 0) {
            require(
                IERC20(token4).transferFrom(
                    msg.sender,
                    address(this),
                    _offerAmount4 * (10 ** 18)
                ),
                "Transfer of token5 failed"
            );
        }

        // Transfer token4 from the sender to this contract
        if (_offerAmount5 > 0) {
            require(
                IERC20(token5).transferFrom(
                    msg.sender,
                    address(this),
                    _offerAmount5 * (10 ** 18)
                ),
                "Transfer of token4 failed"
            );
        }

        // Generate a new key using the offerCounter
        uint256 offerId = offerCounter.current();
        offerCounter.increment();
        offerMapping[offerId].offerId = offerId;

        //make sender the offer creator
        offerMapping[offerId].offerCreator = msg.sender;

        //save the offer amounts
        offerMapping[offerId].offerAmount1 = _offerAmount1;
        offerMapping[offerId].offerAmount2 = _offerAmount2;
        offerMapping[offerId].offerAmount3 = _offerAmount3;
        offerMapping[offerId].offerAmount4 = _offerAmount4;
        offerMapping[offerId].offerAmount5 = _offerAmount5;
        
        //save the wanted amounts
        offerMapping[offerId].wantedAmount1 = _wantedAmount1;
        offerMapping[offerId].wantedAmount2 = _wantedAmount2;
        offerMapping[offerId].wantedAmount3 = _wantedAmount3;
        offerMapping[offerId].wantedAmount4 = _wantedAmount4;
        offerMapping[offerId].wantedAmount5 = _wantedAmount5;

        //set Time Stamp to now
        offerMapping[offerId].offerTimestamp = block.timestamp;        

        // Update offerStatus mapping
        offerMapping[offerId].offerStatus = true;

    }

    function acceptOffer(uint256 _offerId) public payable {
        require(_offerId >= 0, "Offer does not exist");
        require(offerMapping[_offerId].offerStatus == true, "Invalid Offer");
        require(msg.sender != offerMapping[_offerId].offerCreator, "you cannot except your own offer");
        
        address offerCreator = offerMapping[_offerId].offerCreator;

    //transfer Offered tokens from contract to the offer acceptor

        // Transfer token1 from this contract to the offer acceptor
        if (offerMapping[_offerId].offerAmount1 > 0) {
            require(
                IERC20(token1).transferFrom(
                    address(this),
                    msg.sender,
                    offerMapping[_offerId].offerAmount1 * (10 ** 18)
                ),
                "Transfer of token1 failed"
            );
        }

        // Transfer token2 from this contract to the offer acceptor
        if (offerMapping[_offerId].offerAmount2 > 0) {
            require(
                IERC20(token2).transferFrom(
                    address(this),
                    msg.sender,
                    offerMapping[_offerId].offerAmount2 * (10 ** 18)
                ),
                "Transfer of token2 failed"
            );
        }

        // Transfer token3 from this contract to the offer acceptor
        if (offerMapping[_offerId].offerAmount3 > 0) {
            require(
                IERC20(token3).transferFrom(
                    address(this),
                    msg.sender,
                    offerMapping[_offerId].offerAmount3 * (10 ** 18)
                ),
                "Transfer of token3 failed"
            );
        }

        // Transfer token4 from from this contract to the offer acceptor
        if (offerMapping[_offerId].offerAmount4 > 0) {
            require(
                IERC20(token4).transferFrom(
                    address(this),
                    msg.sender,
                    offerMapping[_offerId].offerAmount4 * (10 ** 18)
                ),
                "Transfer of token4 failed"
            );
        }

        // Transfer token5 from this contract to the offer acceptor
        if (offerMapping[_offerId].offerAmount5 > 0) {
            require(
                IERC20(token5).transferFrom(
                    address(this),
                    msg.sender,
                    offerMapping[_offerId].offerAmount5 * (10 ** 18)
                ),
                "Transfer of token5 failed"
            );
        }

    //transfer wanted tokens from offer acceptor to the offer creator
        
        // Transfer token1 from the offer acceptor to the offer creator
        if (offerMapping[_offerId].wantedAmount1 > 0) {
            require(
                IERC20(token1).transferFrom(
                    msg.sender,
                    offerCreator,
                    offerMapping[_offerId].wantedAmount1 * (10 ** 18)
                ),
                "Transfer of token1 failed"
            );
        }

        // Transfer token2 from the offer acceptor to the offer creator
        if (offerMapping[_offerId].wantedAmount2 > 0) {
            require(
                IERC20(token2).transferFrom(
                    msg.sender,
                    offerCreator,
                    offerMapping[_offerId].wantedAmount2 * (10 ** 18)
                ),
                "Transfer of token2 failed"
            );
        }

        // Transfer token3 from the offer acceptor to the offer creator
        if (offerMapping[_offerId].wantedAmount3 > 0) {
            require(
                IERC20(token3).transferFrom(
                    msg.sender,
                    offerCreator,
                    offerMapping[_offerId].wantedAmount3 * (10 ** 18)
                ),
                "Transfer of token3 failed"
            );
        }

        // Transfer token4 from the offer acceptor to the offer creator
        if (offerMapping[_offerId].wantedAmount4 > 0) {
            require(
                IERC20(token4).transferFrom(
                    msg.sender,
                    offerCreator,
                    offerMapping[_offerId].wantedAmount4 * (10 ** 18)
                ),
                "Transfer of token4 failed"
            );
        }

        // Transfer token5 from the offer acceptor to the offer creator
        if (offerMapping[_offerId].wantedAmount5 > 0) {
            require(
                IERC20(token5).transferFrom(
                    msg.sender,
                    offerCreator,
                    offerMapping[_offerId].wantedAmount5 * (10 ** 18)
                ),
                "Transfer of token5 failed"
            );
        }

        delete offerMapping[_offerId];
    }


    function withdraw(uint256 _offerId) public payable {
        require(_offerId >= 0, "Offer does not exist");
        require(offerMapping[_offerId].offerStatus == true, "offer not available");
        require(msg.sender == offerMapping[_offerId].offerCreator, "you can withdraw only your own offer");
        require(block.timestamp > offerMapping[_offerId].offerTimestamp + (86400 * 2), "Lock-in period not over yet");

        //refund token1
        if (offerMapping[_offerId].offerAmount1 > 0) {
            require(
                IERC20(token1).transferFrom(
                    address(this),
                    msg.sender,
                    offerMapping[_offerId].offerAmount1 * (10 ** 18)
                ),
                    "Transfer of token1 failed"
            );
        }

        //refund token2
        if (offerMapping[_offerId].offerAmount2 > 0) {
            require(
                IERC20(token2).transferFrom(
                    address(this),
                    msg.sender,
                    offerMapping[_offerId].offerAmount2 * (10 ** 18)
                ),
                    "Transfer of token2 failed"
            );
        }
        
        //refund token3
        if (offerMapping[_offerId].offerAmount3 > 0) {
            require(
                IERC20(token3).transferFrom(
                    address(this),
                    msg.sender,
                    offerMapping[_offerId].offerAmount3 * (10 ** 18)
                ),
                    "Transfer of token3 failed"
            );
        }

        //refund token4
        if (offerMapping[_offerId].offerAmount4 > 0) {
            require(
                IERC20(token4).transferFrom(
                    address(this),
                    msg.sender,
                    offerMapping[_offerId].offerAmount4 * (10 ** 18)
                ),
                    "Transfer of token4 failed"
            );
        }

        //refund token5
        if (offerMapping[_offerId].offerAmount5 > 0) {
            require(
                IERC20(token5).transferFrom(
                    address(this),
                    msg.sender,
                    offerMapping[_offerId].offerAmount5 * (10 ** 18)
                ),
                    "Transfer of token5 failed"
            );
        }
        delete offerMapping[_offerId];
        
    }

    //getter functions

    function getContractAssets()
        public
        view
        returns (
            uint256 Clay,
            uint256 Fish,
            uint256 Rock,
            uint256 Wood,
            uint256 Wool
        )
    {
        uint256 balance1 = IERC20(token1).balanceOf(address(this)) / (10 ** 18);
        uint256 balance2 = IERC20(token2).balanceOf(address(this)) / (10 ** 18);
        uint256 balance3 = IERC20(token3).balanceOf(address(this)) / (10 ** 18);
        uint256 balance4 = IERC20(token4).balanceOf(address(this)) / (10 ** 18);
        uint256 balance5 = IERC20(token5).balanceOf(address(this)) / (10 ** 18);

        return (balance1, balance2, balance3, balance4, balance5);
    }

    function getOffer(uint256 _offerId) public view returns(
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
    ) {
            
         Offer storage offer = offerMapping[_offerId];
    
    return (
        offer.offerAmount1,
        offer.offerAmount2,
        offer.offerAmount3,
        offer.offerAmount4,
        offer.offerAmount5,
        offer.wantedAmount1,
        offer.wantedAmount2,
        offer.wantedAmount3,
        offer.wantedAmount4,
        offer.wantedAmount5
        );
    }

    function getOfferString(uint256 _offerId) public view returns (string memory) {
    (
        uint256 offerAmount1,
        uint256 offerAmount2,
        uint256 offerAmount3,
        uint256 offerAmount4,
        uint256 offerAmount5,
        uint256 wantedAmount1,
        uint256 wantedAmount2,
        uint256 wantedAmount3,
        uint256 wantedAmount4,
        uint256 wantedAmount5
    ) = getOffer(_offerId);

    string memory offer = "";

    // Add offered tokens to the offer string
    // concatenate offer string with Clay offered if any
    if (offerAmount1 > 0) {
        offer = string(abi.encodePacked(offer, uint256ToString(offerAmount1), " Clay "));
    }

    // concatenate offer string with Fish offered if any
    if (offerAmount2 > 0) {
        offer = string(abi.encodePacked(offer, uint256ToString(offerAmount2), " Fish "));
    }

    // concatenate offer string with Rock offered if any
    if (offerAmount3 > 0) {
        offer = string(abi.encodePacked(offer, uint256ToString(offerAmount3), " Rock "));
    }

    // concatenate offer string with Wood offered if any
    if (offerAmount4 > 0) {
        offer = string(abi.encodePacked(offer, uint256ToString(offerAmount4), " Wood "));
    }

    // concatenate offer string with Wool offered if any
    if (offerAmount5 > 0) {
        offer = string(abi.encodePacked(offer, uint256ToString(offerAmount5), " Wool "));
    }

    offer = string(abi.encodePacked(offer, " for "));

    // Add wanted tokens to the offer string
    // concatenate offer string with Clay wanted if any
    if (wantedAmount1 > 0) {
        offer = string(abi.encodePacked(offer, uint256ToString(wantedAmount1), " Clay "));
    }

    // concatenate offer string with Fish wanted if any
    if (wantedAmount2 > 0) {
        offer = string(abi.encodePacked(offer, uint256ToString(wantedAmount2), " Fish "));
    }

    // concatenate offer string with Rock wanted if any
    if (wantedAmount3 > 0) {
        offer = string(abi.encodePacked(offer, uint256ToString(wantedAmount3), " Rock "));
    }

    // concatenate offer string with Wood wanted if any
    if (wantedAmount4 > 0) {
        offer = string(abi.encodePacked(offer, uint256ToString(wantedAmount4), " Wood "));
    }

    // concatenate offer string with Wool wanted if any
    if (wantedAmount5 > 0) {
        offer = string(abi.encodePacked(offer, uint256ToString(wantedAmount5), " Wool "));
    }

    return offer;
}


    function uint256ToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }

        uint256 temp = value;
        uint256 digits;

        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }

        return string(buffer);
    }

}
