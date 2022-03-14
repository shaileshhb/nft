// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

// Importing contract
contract FirstNFT is ERC721URIStorage {
    // using counters to keep track of tokenIDs.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDs;
    uint256 private MAX_MINT_ALLOWED = 1;

    // baseSVG
    // string baseSvg =
    //     "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // We split the SVG at the part where it asks for the background color.
    string svgPartOne =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo =
        "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] colors = ["red", "#08C2A8", "black", "yellow", "blue", "green"];

    string[] firstWords = [
        "DUMB",
        "NOOB",
        "CRAZY",
        "SPOOKY",
        "WILD",
        "BLIINDERS",
        "CRACKING"
    ];
    string[] secondWords = [
        "PIZZA",
        "BURGER",
        "CURRY",
        "SALAD",
        "PANEER",
        "CHICKEN",
        "FRIES"
    ];
    string[] thirdWords = [
        "GAVIN",
        "AT3MIN",
        "AECH",
        "JIM",
        "BEASLY",
        "JOEY",
        "ROSS",
        "KENNY",
        "BISWA"
    ];

    event NewFirstNFT(address sender, uint256 tokenID);
    // event NewFirstNFTCount(address sender, uint256 mintCount);

    // takes 2 parameters -> name and symbol
    constructor() ERC721("CricketNFT", "CRICKET") {
        console.log("This is my first NFT code log!!!!!!!!!!!");
    }

    function pickRandomFirstWord(uint256 tokenID)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenID)))
        );

        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenID)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenID)))
        );

        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenID)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenID)))
        );

        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(uint256 tokenID)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("COLOR", Strings.toString(tokenID)))
        );
        rand = rand % colors.length;
        return colors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function getTotalNFTsMintedSoFar() public view returns (uint256) {
			// emit NewFirstNFTCount(msg.sender, _tokenIDs.current());
			return _tokenIDs.current();
		}

		function getTotalNFTs() public view returns (uint256) {
			return MAX_MINT_ALLOWED;
		}

    // function whihc user can hit to create NFT.
    function makeNFT() public {
        // get current tokenID
        uint256 newItemID = _tokenIDs.current();

        require(newItemID + 1 <= MAX_MINT_ALLOWED, "Maximum mints reached");

        // mint NFT to sender

        // generate 3 random words.
        string memory first = pickRandomFirstWord(newItemID);
        string memory second = pickRandomSecondWord(newItemID);
        string memory third = pickRandomThirdWord(newItemID);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        // concat all words
        // string memory finalSvg = string(
        //     abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        // );

        // Add the random color in.
        string memory randomColor = pickRandomColor(newItemID);
        string memory finalSvg = string(
            abi.encodePacked(
                svgPartOne,
                randomColor,
                svgPartTwo,
                combinedWord,
                "</text></svg>"
            )
        );

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // prepend data:application/json;base64, to our data.
        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenURI);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemID);

        // Set NFT data.
        // _setTokenURI(newItemID, "blah");
        _setTokenURI(newItemID, finalTokenURI);

        // Increment counter for when next NFT is minted.
        _tokenIDs.increment();

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemID,
            msg.sender
        );

        emit NewFirstNFT(msg.sender, newItemID);
    }
}
