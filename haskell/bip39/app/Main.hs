module Main where

import qualified Crypto.Hash.SHA256          as SHA256
import           Data.Bits
import qualified Data.ByteString             as B
import           Data.ByteString.Base16
import           Data.List
import           Data.Word
import           System.Posix.Env.ByteString

-- | parse bip39 wordlist
englishWords :: IO [String]
englishWords = readFile "wordList.txt" >>= return . words

-- | -__-
toint :: (Integral a, Num b) => a -> b
toint = (fromInteger . toInteger)

-- | -______-
w8tw16 :: Word8 -> Word16
w8tw16 = toint

-- | convert command line supplied entropy to mnemonic
-- must be in hex format, 256 bits
main :: IO ()
main = do
    args <- getArgs
    wordList <- englishWords
    --putStrLn $ show $ length wordList
    let
        --bs = fst . decode $ "ef235aacf90d9f4aadd8c92e4b2562e1d9eb97f0df9ba3b508258739cb013db2"
        bs = fst . decode $ args !! 0
        combined = B.snoc bs (B.head $ SHA256.hash bs)
        mnemonic = map ((wordList !! ) . toint) $ bytesToIndices (combined)
    if length args /= 1 then putStrLn "ERROR: incorrect arguments" else do
        putStrLn "converting entropy:"
        --putStrLn $ (show $ B.length combined) ++ ": " ++ (show combined)
        putStrLn $ show bs
        putStrLn "mnemonic:"
        if B.length combined /= 33 then putStrLn "ERROR: incorrect hash length" else
            putStrLn $ intercalate " " mnemonic

-- | (inefficiently) extract bit (as 0 or 1) from bytestring
getBit :: B.ByteString -> Word16 -> Word8
getBit bs i = output where
    output = shift preshift (-1*toshift)
    preshift = (B.index bs (toint i `div` 8)) .&. shift 1 toshift
    -- awkward
    toshift = 7 - (toint i `mod` 8)

-- | convert to mnemonic (indices)
bytesToIndices :: B.ByteString -> [Word16]
bytesToIndices bs = map collect [0..23] where
    collect x = foldl (\acc i -> shift acc 1 + (w8tw16 $ getBit bs (11*x+i))) 0 [0..10]
