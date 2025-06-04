module integer_mate::math_u256 {

    #[test_only]
    use aptos_std::debug;
    #[test_only]
    use std::string::utf8;

    // Some large constants
    const MAX_U256: u256 =
        0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    // Powers of two
    const TWO_TO_THE_64: u256 = 0x1_00000000_00000000;
    const TWO_TO_THE_192: u256 = 0x1_00000000_00000000_00000000_00000000_00000000_00000000;

    public fun div_mod(num: u256, denom: u256): (u256, u256) {
        let p = num / denom;
        let r: u256 = num - (p * denom);
        (p, r)
    }

    public fun shlw(n: u256): u256 {
        n << 64
    }

    public fun shrw(n: u256): u256 {
        n >> 64
    }

    /// Used only to prove lemmas.
    fun lemma_power2s(): () {}

    /// Performs a left shift of 64 bits (1 word) with overflow check.
    /// Returns a tuple containing the shifted value and a boolean indicating overflow.
    /// * `n` - The value to shift left
    /// * returns - (result, overflow) where:
    ///   - result is the shifted value (0 if overflow occurred)
    ///   - overflow is true if the operation would overflow
    public fun checked_shlw(n: u256): (u256, bool) {
        let mask = TWO_TO_THE_192;
        if (n >= mask) {
            // Spec here for readability, but
            // the prover does not need them
            spec {
                assert n >= Pow2(192);
                assert n * Pow2(64) >= MAX_U256;
            };
            (0, true)
        } else {
            spec {
                assert TWO_TO_THE_192 == Pow2(192);
                assert n < Pow2(192);
                assert n * Pow2(64) < MAX_U256;
                assert n << 64 == n * Pow2(64);
            };
            (n << 64, false)
        }
    }

    /// Performs division with optional rounding up
    /// * `num` - The numerator
    /// * `denom` - The denominator
    /// * `round_up` - If true, rounds up the result when there is a remainder
    /// * returns - The quotient, rounded up if specified and there is a remainder
    public fun div_round(num: u256, denom: u256, round_up: bool): u256 {
        let p = num / denom;
        if (round_up && ((p * denom) != num)) { p + 1 }
        else { p }
    }

    public fun add_check(num1: u256, num2: u256): bool {
        (MAX_U256 - num1 >= num2)
    }

    #[test]
    fun test_div_round() {
        div_round(1, 1, true);
    }

    #[test]
    fun test_add() {
        1000u256 + 1000u256;
    }

    #[test]
    fun test_checked_shlw() {
        // should not overflow
        let (result, overflow) = checked_shlw(TWO_TO_THE_64 - 1);
        assert!(overflow == false, 0);
        assert!(result == 0xffffffffffffffff0000000000000000u256, 1);

        // 2^192 should not overflow
        assert!(1 << 192 == TWO_TO_THE_192, 2);
        let (result, overflow) = checked_shlw(TWO_TO_THE_192);
        assert!(overflow == true, 2);
        assert!(result == 0u256, 3);

        // should overflow
        let (result, overflow) = checked_shlw(MAX_U256);
        assert!(overflow == true, 2);
        assert!(result == 0u256, 3);
    }

    #[test]
    /// Test the `div_round` function with a specific case.
    fun test_div_roundup1() {
        let result = div_round(MAX_U256, 1, true);
        debug::print(&utf8(b"round up of MAX_U256 / 1"));
        debug::print(&result);
        assert!(result == MAX_U256, 0);
    }

    #[test]
    /// Test the `div_round` function with a specific case.
    fun test_div_roundup2() {
        let result = div_round(MAX_U256 - 2, 2, true);
        debug::print(&utf8(b"round up of MAX_U256 - 1 / 2"));
        debug::print(&result);
        assert!(result == (MAX_U256 - 2) / 2 + 1, 0);
    }
}
