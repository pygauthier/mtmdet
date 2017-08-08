Import-Csv -Path “checkuser.csv” | 
        ForEach {$Name = $_.Identity 
                 $Searcher = [ADSISearcher]"(sAMAccountName=$Name)"
                $Results = $Searcher.FindOne()
                If ($Results -eq $Null) {"$Name n'existe plus dans l'AD"}
                Else {"-- $Name utilisateur trouvé dans l'AD"}}