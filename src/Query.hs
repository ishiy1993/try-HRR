module Query where

import Data.Int (Int32)
import Database.Relational.Query
import Database.Relational.Query.Documentation
import Database.Relational.Query.Type (unsafeTypedQuery)
import Database.HDBC (commit)
import Database.HDBC.Session (withConnectionIO')
import Database.HDBC.Record.Query (runQuery')

import DataSource
import Memo

runDB act = withConnectionIO' connect act

printMemos :: IO ()
printMemos = do
    ms <- runDB $ \cn ->
            runQuery cn (relationalQuery $ relation $ query memo) ()
    mapM_ print ms

printMemos' :: IO ()
printMemos' = do
    ms <- runDB $ \cn ->
            runQuery' cn (relationalQuery $ relation $ query memo) ()
    mapM_ print ms

printMemos'' :: IO ()
printMemos'' =
    runDB $ \cn -> do
        ms <- runQuery cn (relationalQuery $ relation $ query memo) ()
        mapM_ print ms

createMemo :: IO ()
createMemo =
    runDB $ \cn ->do
        let m = Memo 4 "memo4"
        runInsert cn insertMemo m
        return ()

createMemo' :: IO ()
createMemo' =
    runDB $ \cn ->do
        let m = Memo 4 "memo4"
        runInsert cn insertMemo m
        commit cn

deleteMemo :: IO ()
deleteMemo =
    runDB $ \cn -> do
        runDelete cn dMemo ()
        commit cn

dMemo :: Delete ()
dMemo = typedDelete tableOfMemo . restriction $ \proj ->
    wheres $ proj ! memoId' .=. value 4

newMemo :: String -> IO Memo
newMemo con =
    runDB $ \cn -> do
        [mid] <- runQuery cn qSeq ()
        let m = Memo mid con
        runInsert cn insertMemo m
        commit cn
        return m

qSeq :: Query () Int32
qSeq = unsafeTypedQuery "SELECT nextval('memo_id');"
