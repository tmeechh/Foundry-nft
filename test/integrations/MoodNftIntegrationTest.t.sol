// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftIntegrationTest is Test {
    MoodNft moodNft;
    string public constant CALM_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgPCEtLSBGYWNlIC0tPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgcj0iNzgiIGZpbGw9InllbGxvdyIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CgogIDwhLS0gRXllczogc29mdCBhbmQgcmVsYXhlZCAtLT4KICA8ZyBjbGFzcz0iZXllcyI+CiAgICA8ZWxsaXBzZSBjeD0iNzAiIGN5PSI4NSIgcng9IjgiIHJ5PSIxMCIgZmlsbD0iYmxhY2siIG9wYWNpdHk9IjAuOSIvPgogICAgPGVsbGlwc2UgY3g9IjEzMCIgY3k9Ijg1IiByeD0iOCIgcnk9IjEwIiBmaWxsPSJibGFjayIgb3BhY2l0eT0iMC45Ii8+CiAgPC9nPgoKICA8IS0tIEdlbnRsZSBzbWlsZSAtLT4KICA8cGF0aCBkPSJNNzAgMTIwIFExMDAgMTQ1IDEzMCAxMjAiCiAgICAgICAgZmlsbD0ibm9uZSIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KCiAgPCEtLSBTb2Z0IGV5ZWxpZHMgZm9yIHJlbGF4ZWQgbG9vayAtLT4KICA8cGF0aCBkPSJNNjIgNzUgUTcwIDcwIDc4IDc1IiBzdHJva2U9ImJsYWNrIiBzdHJva2Utd2lkdGg9IjIiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIvPgogIDxwYXRoIGQ9Ik0xMjIgNzUgUTEzMCA3MCAxMzggNzUiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMiIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIi8+Cjwvc3ZnPgo=";

    string public constant CRAZY_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgPCEtLSBGYWNlIC0tPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CgogIDwhLS0gRXllcyAodGlsdGVkIGFuZCB1bmV2ZW4gc2l6ZXMpIC0tPgogIDxnIGNsYXNzPSJleWVzIj4KICAgIDxlbGxpcHNlIGN4PSI3MCIgY3k9Ijc4IiByeD0iMTAiIHJ5PSIxNCIgdHJhbnNmb3JtPSJyb3RhdGUoLTEwIDcwIDc4KSIgZmlsbD0iYmxhY2siLz4KICAgIDxlbGxpcHNlIGN4PSIxMzAiIGN5PSI4NSIgcng9IjE0IiByeT0iMTAiIHRyYW5zZm9ybT0icm90YXRlKDE1IDEzMCA4NSkiIGZpbGw9ImJsYWNrIi8+CiAgPC9nPgoKICA8IS0tIFppZy16YWcgbW91dGggLS0+CiAgPHBhdGggZD0iTTYwIDEzMCBRODAgMTIwIDkwIDEzNSBRMTAwIDE1MCAxMTAgMTMwIFExMjAgMTE1IDE0MCAxNDAiCiAgICAgICAgZmlsbD0ibm9uZSIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSI0IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiLz4KCiAgPCEtLSBUb25ndWUgc3RpY2tpbmcgb3V0IC0tPgogIDxwYXRoIGQ9Ik05NSAxMzUgUTEwMCAxNjAgMTA1IDEzNSBaIiBmaWxsPSJyZWQiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMiIvPgoKICA8IS0tIE9uZSBleWVicm93IHJhaXNlZCBmb3IgY3JhemluZXNzIC0tPgogIDxwYXRoIGQ9Ik01NSA2MCBRNzAgNTAgODUgNTUiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iNCIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIi8+CiAgPHBhdGggZD0iTTExNSA2MCBRMTMwIDcwIDE0NSA2NSIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSI0IiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPC9zdmc+Cg== ";

    string public constant CRAZY_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjogIk1vb2QgTkZUIiwgImRlc2NyaXB0aW9uIjogIkFuIE5GVCB0aGF0IHJlZmxlY3QgdGhlIG93bmVycyBtb29kLiIsICJhdHRyaWJ1dGVzIjogW3sidHJhaXRfdHlwZSI6ICJtb29kaW5lc3MiLCAidmFsdWUiOiAxMDB9XSwgImltYWdlIjoiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCMmFXVjNRbTk0UFNJd0lEQWdNakF3SURJd01DSWdkMmxrZEdnOUlqUXdNQ0lnYUdWcFoyaDBQU0kwTURBaUlIaHRiRzV6UFNKb2RIUndPaTh2ZDNkM0xuY3pMbTl5Wnk4eU1EQXdMM04yWnlJK0NpQWdQQ0V0TFNCR1lXTmxJQzB0UGdvZ0lEeGphWEpqYkdVZ1kzZzlJakV3TUNJZ1kzazlJakV3TUNJZ1ptbHNiRDBpZVdWc2JHOTNJaUJ5UFNJM09DSWdjM1J5YjJ0bFBTSmliR0ZqYXlJZ2MzUnliMnRsTFhkcFpIUm9QU0l6SWk4K0Nnb2dJRHdoTFMwZ1JYbGxjeUFvZEdsc2RHVmtJR0Z1WkNCMWJtVjJaVzRnYzJsNlpYTXBJQzB0UGdvZ0lEeG5JR05zWVhOelBTSmxlV1Z6SWo0S0lDQWdJRHhsYkd4cGNITmxJR040UFNJM01DSWdZM2s5SWpjNElpQnllRDBpTVRBaUlISjVQU0l4TkNJZ2RISmhibk5tYjNKdFBTSnliM1JoZEdVb0xURXdJRGN3SURjNEtTSWdabWxzYkQwaVlteGhZMnNpTHo0S0lDQWdJRHhsYkd4cGNITmxJR040UFNJeE16QWlJR041UFNJNE5TSWdjbmc5SWpFMElpQnllVDBpTVRBaUlIUnlZVzV6Wm05eWJUMGljbTkwWVhSbEtERTFJREV6TUNBNE5Ta2lJR1pwYkd3OUltSnNZV05ySWk4K0NpQWdQQzluUGdvS0lDQThJUzB0SUZwcFp5MTZZV2NnYlc5MWRHZ2dMUzArQ2lBZ1BIQmhkR2dnWkQwaVRUWXdJREV6TUNCUk9EQWdNVEl3SURrd0lERXpOU0JSTVRBd0lERTFNQ0F4TVRBZ01UTXdJRkV4TWpBZ01URTFJREUwTUNBeE5EQWlDaUFnSUNBZ0lDQWdabWxzYkQwaWJtOXVaU0lnYzNSeWIydGxQU0ppYkdGamF5SWdjM1J5YjJ0bExYZHBaSFJvUFNJMElpQnpkSEp2YTJVdGJHbHVaV05oY0QwaWNtOTFibVFpSUhOMGNtOXJaUzFzYVc1bGFtOXBiajBpY205MWJtUWlMejRLQ2lBZ1BDRXRMU0JVYjI1bmRXVWdjM1JwWTJ0cGJtY2diM1YwSUMwdFBnb2dJRHh3WVhSb0lHUTlJazA1TlNBeE16VWdVVEV3TUNBeE5qQWdNVEExSURFek5TQmFJaUJtYVd4c1BTSnlaV1FpSUhOMGNtOXJaVDBpWW14aFkyc2lJSE4wY205clpTMTNhV1IwYUQwaU1pSXZQZ29LSUNBOElTMHRJRTl1WlNCbGVXVmljbTkzSUhKaGFYTmxaQ0JtYjNJZ1kzSmhlbWx1WlhOeklDMHRQZ29nSUR4d1lYUm9JR1E5SWswMU5TQTJNQ0JSTnpBZ05UQWdPRFVnTlRVaUlITjBjbTlyWlQwaVlteGhZMnNpSUhOMGNtOXJaUzEzYVdSMGFEMGlOQ0lnYzNSeWIydGxMV3hwYm1WallYQTlJbkp2ZFc1a0lpOCtDaUFnUEhCaGRHZ2daRDBpVFRFeE5TQTJNQ0JSTVRNd0lEY3dJREUwTlNBMk5TSWdjM1J5YjJ0bFBTSmliR0ZqYXlJZ2MzUnliMnRsTFhkcFpIUm9QU0kwSWlCemRISnZhMlV0YkdsdVpXTmhjRDBpY205MWJtUWlMejRLUEM5emRtYytDZz09In0=";

    DeployMoodNft deployer;

    address USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewTokenURIIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));
    }

    function testFlipTokenToCrazy() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER);
        moodNft.flipMood(0);

        // OPTION 1 (modern, accurate, recommended ):
        //Compare encoded Base64 tokenURI directly
        assertEq(keccak256(abi.encodePacked(moodNft.tokenURI(0))), keccak256(abi.encodePacked(CRAZY_SVG_URI)));

        // OPTION 2 (simpler, logic-level test)

        //  assertEq(uint256(moodNft.getMood(0)), uint256(MoodNft.Mood.CRAZY));
    }

    //     function testDumpRealTokenURI() public {
    //     // mint and flip so tokenURI uses CRAZY image
    //     vm.prank(USER);
    //     moodNft.mintNft();

    //     vm.prank(USER);
    //     moodNft.flipMood(0);

    //     // prints the full tokenURI (data:application/json;base64,...)
    //     console.log(moodNft.tokenURI(0));
    // }
}
