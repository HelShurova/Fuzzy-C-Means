module CmdLineOptions(Options(..), parseArgs) where

import System.Console.GetOpt
import System.Environment

data Options = Options {
    delimiter :: String
  , ignoreFirstLine :: Bool
  , ignoreFirstColumn :: Bool
  , ignoreLastColumn :: Bool
  , input :: String
  , output :: String
  , accuracy :: Double
  , numCluster :: Int
  , isHamming :: Bool
  , startAttachment :: Bool
  } deriving (Eq, Show)

defaultOptions = Options {
    delimiter = ","
  , ignoreFirstLine = False
  , ignoreFirstColumn = False
  , ignoreLastColumn = False
  , input = "files/butterfly.txt"
  , output = ""
  , accuracy = 0.01
  , numCluster = 6
  , isHamming = False
  , startAttachment = False
  }

options :: [OptDescr (Options -> Options)]
options =
  [ Option ['d'] ["delimiter"]
      (ReqArg (\d opts -> opts { delimiter = d }) "DELIMITER")
      "delimiter of attributes of objects in csv file"
  , Option ['h'] ["ignoreFirstLine"]
      (NoArg (\opts -> opts { ignoreFirstLine = True }))
      "ignore first line - as it can be a header"
  , Option ['f'] ["ignoreFirstColumn"]
      (NoArg (\opts -> opts { ignoreFirstColumn = True }))
      "ignore first column - lines can be numbered"
  , Option ['l'] ["ignoreLastColumn"]
      (NoArg (\opts -> opts { ignoreLastColumn = True }))
      "ignore last column - it can be class marker"
  , Option ['i'] ["inputFile"]
      (ReqArg (\i opts -> opts { input = i }) "INPUT_FILE")
      "input csv file with objects"
  , Option ['o'] ["outputFile"]
      (ReqArg (\o opts -> opts { output = o }) "OUTPUT_FILE")
      "output file with matrix of belonings"
  , Option ['a'] ["accuracy"]
      (ReqArg (\a opts -> opts { accuracy = (read a) }) "ACCURACY")
      "accuracy"
  , Option ['n'] ["numCluster"]
      (ReqArg (\n opts -> opts { numCluster = (read n) }) "NUMBER_OF_CLUSTERS")
      "number of clusters"
  , Option ['m'] ["isHamming"]
      (NoArg (\opts -> opts { isHamming = True }))
      "true - for hamming distance, false(default) - euclide distance"
  , Option ['s'] ["startAttachment"]
      (NoArg (\opts -> opts { startAttachment = True }))
      "true - start with calculating matrix of belonings, false(default) - start with random centres"
  ]

parseArgs :: IO Options
parseArgs = do
    argv <- getArgs
    case getOpt RequireOrder options argv of
        (opts, [], []) -> return (foldl (flip id) defaultOptions opts)
        (_, _, errs) -> ioError (userError (concat errs ++ (usageInfo ("Usage: [OPTION...]") options)))
    