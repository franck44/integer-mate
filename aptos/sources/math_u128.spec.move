spec integer_mate::math_u128 {

    /// This assumption is proved in the next lemma.
    /// The purpose of this axion is to bring it into
    /// scope for the whole module.
    spec module {
        axiom TWO_TO_THE_192 == Pow2(192);
    }

    /// Some useful equalities about large powers of two
    // spec lemma_power2s(): () {
    //     ensures TWO_TO_THE_192 == Pow2(192);
    // }

    spec overflowing_add {
        aborts_if false;
        ensures true ==> n1 + n2 <= MAX_U128 - 1;
    }

    // spec overflowing_add {
    //     aborts_if false;
    //     // ensures result_2 <==> result_1 == 0 && n1 + n2 > MAX_U256;
    // }

    // The checked left shift that should not overflow.
    // spec checked_shlw {
    //     aborts_if false;
    //     ensures result_2 <==>
    //         result_1 == 0 && n * Pow2(64) > MAX_U256;
    //     ensures !result_2 ==> result_1 == n << 64;
    //     ensures !result_2 <==> result_1 == n * Pow2(64);
    // }

    // div modulo.
    // spec div_mod {
    //     aborts_if denom == 0;
    //     // Returns a tuple (p, r) where p is the quotient and r is the remainder.
    //     ensures result_1 * denom + result_2 == num;
    // }

    // This function aborts only when dividing by zero
    // When we return p + 1 it is guaranteed that p + 1 < MAX_U256
    // spec div_round(num: u256, denom: u256, round_up: bool): u256 {
    //     aborts_if denom == 0;
    //     ensures result >= 0;
    // }

    /// Defines a power of 2 function for natural numbers (math ints).
    /// * `n` - The exponent
    /// * returns - 2 raised to the power of n
    spec fun Pow2(n: num): num {
        if (n == 0) { 1 }
        else {
            2 * Pow2(n - 1)
        }
    }
}
