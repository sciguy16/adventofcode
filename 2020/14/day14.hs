xToNum :: Char -> Char -> Char
xToNum toReplaceWith c =
    if c == 'X'
        then toReplaceWith
        else c

applyMask :: String -> Integer -> String
applyMask mask inp = do
    let toOne = xToNum '1'
    let onesMask = map (toOne) mask
    let toZero = xToNum '0'
    let zeroesMask = map toZero mask
    onesMask ++ " " ++ zeroesMask


main :: IO()
main = do
    let mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"
    let result = applyMask mask 11
    print result
