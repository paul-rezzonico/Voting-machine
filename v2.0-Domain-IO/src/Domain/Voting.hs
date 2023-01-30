{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module Domain.Voting ( Voter (..), Candidate (..), Score (..), AttendenceSheet, BallotPaper (..),
Scoreboard, VoteOutcome (..), VotingMachine (..), emptyVotingMachine, vote, getSingleScore )
where

import Data.Function ((&))
import Data.Hashable (Hashable)
import qualified Data.HashMap.Lazy as HashMap
import qualified Data.HashSet as HashSet
import GHC.Generics (Generic)

newtype Voter = Voter String
  deriving (Eq, Hashable, Generic, Show)

newtype Candidate = Candidate String
  deriving (Eq, Hashable, Show, Generic)

newtype Score = Score Int
  deriving (Eq, Show, Hashable, Generic)

type AttendenceSheet = HashSet.HashSet Voter     -- feuille d'émargement


type Scoreboard = HashMap.HashMap Candidate Score    -- tableau de résultats

data VotingMachine = VotingMachine
  { voters :: AttendenceSheet,
    scores :: Scoreboard
  }
  deriving (Eq, Show, Generic)

data BallotPaper = BallotPaper    -- bulletin de vote
  { voter :: Voter,
    candidate :: Candidate
  }
  deriving (Generic)

data VoteOutcome = VoteAccepted VotingMachine | HasAlreadyVoted | UnknownCandidate
  deriving (Eq, Show, Generic)