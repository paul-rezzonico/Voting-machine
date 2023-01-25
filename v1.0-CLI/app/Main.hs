import Control.Monad (forever)
import Data.Map(Map, empty, insert, lookup, toList)
import Data.IORef(newIORef, readIORef, writeIORef)
import Data.HashSet (fromList, member, insert)

--Définition de notre type de map :
type MapCandidat = Map String Int

main :: IO()
main = do

  let mapCandidat = empty :: MapCandidat
  let mapCandidat' = Data.Map.insert "Nixos" 0 $ Data.Map.insert "Windows" 0 $ Data.Map.insert "Linux" 0 mapCandidat
  mapCandidatRef <- newIORef mapCandidat'

  let mapVoteur = Data.HashSet.fromList[]
  mapVoteurRef <- newIORef mapVoteur
  forever $ do
    putStrLn "Entrer une commande :"
    command  <- getLine
    candidats <- readIORef mapCandidatRef
    voteurs <- readIORef mapVoteurRef

    case words command of
      ["voter", voteur, candidat] -> do

        case Data.Map.lookup candidat candidats of
          Just nbVotes -> do
            if Data.HashSet.member voteur voteurs then
              putStrLn $ "vous avez deja voté, " ++ voteur ++ " !"
            else do
              writeIORef mapVoteurRef (Data.HashSet.insert voteur voteurs)
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