$scoreCards = @()

$services = @("teams-integration", "slack-integration")

function GetScoreCardsForService ([string]$service) {
    $body = @"
{
    service(name: "$($service)"){
    id,
    name,
    maintainer {
      name
    },
    scorecards(hideMissingScores: true) {
      edges {
        node {
          id,
          name,
          description,
          
          scorecardSummaries(serviceName: "$($service)", first: 1){
            nodes{
              score,
              maxScore,
              date
            }
          }
        }
      }
    }
  }
} 
"@

$header = @{
 "Authorization"="Bearer $($env:SERVICE_CATALOG_TOKEN)"
} 


$resultJson = Invoke-RestMethod -Uri "https://catalog.githubapp.com/graphql" -Method 'Post' -Body $body -Headers $header 

return $resultJson
}



Foreach ($service in $services)
{
   $scoreCard = GetScoreCardsForService $service
   Foreach($iscoreCard in $scoreCard.data.service.scorecards.edges)
   {
        Foreach($iscorecardSummariesNodes in $iscoreCard.node.scorecardSummaries.nodes)
        {
            if($iscorecardSummariesNodes.score -lt $iscorecardSummariesNodes.maxScore)
            {
                $iscorecardSummariesNodes | Add-Member -NotePropertyName Status -NotePropertyValue "https://pluspng.com/img-png/red-cross-png-red-cross-png-file-2000.png"
            }
            else
            {
                $iscorecardSummariesNodes | Add-Member -NotePropertyName Status -NotePropertyValue "https://pluspng.com/img-png/green-tick-png-hd-green-tick-png-image-600.png"
            }
        }
   }
   $scoreCards = $scoreCards + $scoreCard
}

 $finalToReturn = ($scoreCards | ConvertTo-Json  -Depth 10 -Compress )




 $finalToReturn 
