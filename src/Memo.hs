{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}
module Memo where

import Database.HDBC.Query.TH (defineTableFromDB)
import Database.HDBC.Schema.PostgreSQL (driverPostgreSQL)

import DataSource

defineTableFromDB connect driverPostgreSQL "public" "memo" [''Show]
