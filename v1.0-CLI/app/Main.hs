import Control.Monad (forever)
import Data.Map(Map, empty, insert, lookup, toList, adjust)
import Data.IORef(newIORef, readIORef, writeIORef)

--Définition de notre type de map :
type MapCandidat = Map String Int
type MapVoteur = Map String Int

main :: IO()
main = do

  let mapCandidat = empty :: MapCandidat
  let mapCandidat' = insert "Nixos" 0 $ insert "Windows" 0 $ insert "Linux" 0 mapCandidat
  mapCandidatRef <- newIORef mapCandidat'

  let mapVoteur = empty :: MapVoteur
  mapVoteurRef <- newIORef mapVoteur
  
  forever $ do 
    putStrLn "Entrer une commande :"
    command  <- getLine

    case words command of 
      ["voter", voteur, candidat] -> do
        candidats <- readIORef mapCandidatRef

        case Data.Map.lookup candidat candidats of 
          Just nbVotes -> do
            
            let map <-
            putStrLn $ "A voter !, " ++ candidat ++ " est maintenant à " ++ show nbVotes ++ "voix !"

          Nothing -> putStrLn "Candidat introuvable !"
      
      ["voir", candidat] -> do
        candidats <- readIORef mapCandidatRef
        case Data.Map.lookup candidat candidats of 
          Just nbVotes -> putStrLn $ "Le nombre de votes pour " ++ candidat ++ " est : " ++ show nbVotes
          Nothing -> putStrLn $ "candidat : " ++ candidat ++ " non-trouvé"
      
      ["voir"] -> do
        candidats <- readIORef mapCandidatRef
        putStrLn "Scores de chaque candidat :"
        mapM_ (\(candidat, nbVotes) -> putStrLn $ candidat ++ " : " ++ show nbVotes ++ " voix.") $ toList candidats

      _ -> do
        putStrLn "Commande inconnue."