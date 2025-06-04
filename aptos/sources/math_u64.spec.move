spec integer_mate::math_u64 {

    /// This assumption is proved in the next lemma.
    /// The purpose of this axion is to bring it into
    /// scope for the whole module.
    spec module {
        // axiom TWO_TO_THE_192 == Pow2(192);
    }

    spec overflowing_add {
        aborts_if false;
        // ensures !result_2 ==> n1 + n2 <= TWO_TO_THE_64 - 1;
        // ensures !result_2 ==>
        // ((n1 as u128) + (n2 as u128) as u128) <= int2bv((MAX_U64 - 1) as u128);
        // ensures !result_2 ==> n1 + n2 <= MAX_U64;
        ensures result_2 <==>
            ((n1 as u128) + (n2 as u128) as u128) > ((MAX_U64) as u128);
        ensures !result_2 ==> result_1 == n1 + n2;
        ensures result_2 ==> n1 > result_1;
    }
}
