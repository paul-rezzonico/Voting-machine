import Control.Monad (forever)
import Data.Map(Map, insert, lookup, toList, fromList)
import Data.IORef(newIORef, readIORef, writeIORef)
import Data.HashSet (fromList, member, insert)
import Options.Applicative

data Options = Options{
  listeCandidatsOptn :: String
}

options :: Parser Options
options = Options <$> strOption (long "listCandidats" <> short 'l')

createHashMap :: [String] -> Map String Int
createHashMap list = Data.Map.fromList [(x,0) | x<- list]

main :: IO()
main = do

  lc  <- execParser $ info options mempty

  let mapCandidat = createHashMap $ words $ listeCandidatsOptn lc
  mapCandidatRef <- newIORef mapCandidat

  let mapVoteur = Data.HashSet.fromList[]
  mapVoteurRef <- newIORef mapVoteur
  forever $ do
    putStrLn "Entrer une commande :"
    commands  <- getLine
    candidats <- readIORef mapCandidatRef
    voteurs <- readIORef mapVoteurRef

    case words commands of
      ["voter", voteur, candidat] -> do

        if Data.HashSet.member voteur voteurs then
              putStrLn $ "vous avez deja voté, " ++ voteur ++ " !"
        else do
          writeIORef mapVoteurRef (Data.HashSet.insert voteur voteurs)
          case Data.Map.lookup candidat candidats of
            Just nbVotes -> do
              let votes = nbVotes +1
              writeIORef mapCandidatRef (Data.Map.insert candidat votes candidats)
              putStrLn $ "A voter !, " ++ candidat ++ " est maintenant à " ++ show votes ++ " voix !"

            Nothing -> putStrLn "Candidat introuvable !"

      ["voir", candidat] -> do
        case Data.Map.lookup candidat candidats of
          Just nbVotes -> putStrLn $ "Le nombre de votes pour " ++ candidat ++ " est : " ++ show nbVotes
          Nothing -> putStrLn $ "candidat : " ++ candidat ++ " non-trouvé"

      ["voir"] -> do
        putStrLn "Scores de chaque candidat :"
        mapM_ (\(candidat, nbVotes) -> putStrLn $ candidat ++ " : " ++ show nbVotes ++ " voix.") $ toList candidats

      _ -> do
        putStrLn "Commande inconnue."
