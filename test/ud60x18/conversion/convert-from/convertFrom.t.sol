// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "src/UD60x18.sol";
import { UD60x18_Test } from "../../UD60x18.t.sol";

contract ConvertFrom_Test is UD60x18_Test {
    function lessThanOne_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: ZERO }));
        sets.push(set({ x: 1 }));
        sets.push(set({ x: 1e18 - 1 }));
        return sets;
    }

    function test_ConvertFrom_LessThanOne() external parameterizedTest(lessThanOne_Sets()) {
        uint256 actual = convert(s.x);
        uint256 expected = 0;
        assertEq(actual, expected);
    }

    modifier GreaterThanOrEqualToOne() {
        _;
    }

    function greaterThanOne_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, expected: 0.000000000000000001e18 }));
        sets.push(set({ x: 1e18 + 1, expected: 0.000000000000000001e18 }));
        sets.push(set({ x: 2e18 - 1, expected: 0.000000000000000001e18 }));
        sets.push(set({ x: 2e18, expected: 0.000000000000000002e18 }));
        sets.push(set({ x: 2e18 + 1, expected: 0.000000000000000002e18 }));
        sets.push(set({ x: E, expected: 0.000000000000000002e18 }));
        sets.push(set({ x: PI, expected: 0.000000000000000003e18 }));
        sets.push(set({ x: 1729e18, expected: 0.000000000000001729e18 }));
        sets.push(set({ x: 4.2e45, expected: 4.2e27 }));
        sets.push(set({ x: MAX_WHOLE_UD60x18, expected: MAX_SCALED_UD60x18 }));
        sets.push(set({ x: MAX_UD60x18, expected: MAX_SCALED_UD60x18 }));
        return sets;
    }

    function test_ConvertFrom() external parameterizedTest(greaterThanOne_Sets()) GreaterThanOrEqualToOne {
        uint256 actual = convert(s.x);
        uint256 expected = UD60x18.unwrap(s.expected);
        assertEq(actual, expected);
    }
}
