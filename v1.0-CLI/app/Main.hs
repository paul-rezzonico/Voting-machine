import Data.Map (Map, empty, insert, lookup, toList)
import Text.Printf (printf)

type Candidat = String
type Voter = String
type Votes = Map Candidat Int

main :: IO ()
main = do
  votes <- processCommand empty
  putStrLn "Au revoir!"

processCommand :: Votes -> IO Votes
processCommand votes = do
  putStrLn "Entrez une commande :"
  command <- getLine
  case words command of
    ["voter", voter, candidat] -> do
      case Data.Map.lookup voter votes of
        Just _ -> putStrLn $ voter ++ " a déjà voté."
        Nothing -> case Data.Map.lookup candidat votes of
          Just _ -> do
            putStrLn $ "Merci pour votre vote, " ++ voter ++ "."
            putStrLn ( voter ++ candidat ++ show(votes))
          Nothing -> putStrLn $ "Candidat " ++ candidat ++ " inconnu."
      processCommand votes
    ["voir", candidat] -> do
      case Data.Map.lookup candidat votes of
        Just count -> putStrLn $ candidat ++ " : " ++ show count ++ " voix."
        Nothing -> putStrLn $ "Candidat " ++ candidat ++ " inconnu."
      processCommand votes
    ["voir"] -> do
      putStrLn "Scores :"
      mapM_ (\(candidat, count) -> putStrLn $ candidat ++ " : " ++ show count ++ " voix.") $ toList votes
      processCommand votes
    _ -> do
      putStrLn "Commande inconnue."
      processCommand votes
