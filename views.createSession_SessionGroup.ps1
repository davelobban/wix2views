$viewsUsername=""
$viewsPw=""
$siteRoot="https://app.viewsapp.net/api/restful/"
$outputDir="U:\s\"

Function GetHeaders(){
    $pair = "$($viewsUsername):$($viewsPw)"

    $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

    $basicAuthValue = "Basic $encodedCreds"

    $accept= "application/xml"
    $head = @{"Accept"=$accept;
        "Authorization" = $basicAuthValue
    }
    return $head
}

Function Post ($u, $body){
    Write-output "POST ....................."
    echo "########POST###################Response.....for uri $u"
    
    #$head=GetHeaders
    echo $u >> "$outputDir\resp.$now.txt"
    echo $head >> "$outputDir\resp.$now.txt"

    $response = Invoke-WebRequest -Method Post -Headers $head -Uri $u -UseBasicParsing -Verbose -Body $body

    echo $response >> "$outputDir\resp.$now.txt"
    echo $($response.Content) >> "$outputDir\resp.$now.txt"
    return $response
}

Function AddSessionGroup($projectXml, $sessionGroupXml){
    $pagePath="work/sessiongroups"
    $uri= "$siteRoot$pagePath"
    echo $uri
    echo ".. add sessiongroup xml: $sessionGroupXml"
    $j=Post $uri $sessionGroupXml
    echo $j > "$outputDir\newSessionGroup.$now.txt"
    return $j
}

Function AddSessionToProject($projectId, $sessionXml){
    $pagePath="work/sessiongroups/"
    $finalPathPart="/sessions"
    $createSessionUri= "$siteRoot$pagePath$projectId$finalPathPart"
    echo ".. add session to session group xml: $sessionXml"

    $j=Post $createSessionUri $sessionXml
    echo $j > "$outputDir\$now.newSession.$projectId.txt"
    return $j
}

Function NewSession(){
    $testSessionGroupId=107
    $newSessionDate="2023-02-12"
    $newSessionStartTime="12:01"
    $newSessionDuration="01:00"
    $newSessionName="Another test session (auto-generated)"
    $newSessionXml = "<session><SessionGroupID>$testSessionGroupId</SessionGroupID><SessionType>Individual</SessionType><Name>$newSessionName</Name>" `
    +"<StartDate>$newSessionDate</StartDate><StartTime>$newSessionStartTime</StartTime><Duration>$newSessionDuration</Duration><Cancelled>0</Cancelled>" `
    +"<LeadStaff>1</LeadStaff><VenueID>1</VenueID><RestrictedRecord>0</RestrictedRecord><ContactType>Individual</ContactType><Next/><Previous/></session>"
    echo "..new session xml: $newSessionXml "
    $j=AddSessionToProject $testSessionGroupId $newSessionXml
    echo $j > "$outputDir\$now.newSession.txt"
    return $j
}

Function NewSessionGroup(){
    $projectTitle="TestprojectTwo"
    $projectDesc="test project 2 Description (do not use please)"
    $projXml=-join ("<sessiongroup><Title>$projectTitle</Title><Type>Individual</Type><Programmes/><Projects>1</Projects><BookingMode>Session</BookingMode><RegisterGroupings/>" ,
    "<RestrictedRecord>0</RestrictedRecord><AllowSessionTypes>Session|Event</AllowSessionTypes><Description>$projectDesc</Description><LeadStaff>22</LeadStaff>" ,
    "<VenueID>1</VenueID><StartDate>2023-02-14</StartDate><EndDate>2023-02-14</EndDate><PlannedSessions>0</PlannedSessions>" ,
    "<AgeGroupFrom>8</AgeGroupFrom><AgeGroupTo>21</AgeGroupTo><NumberOfPlaces>0</NumberOfPlaces>" ,
    "<Cost>2.00</Cost><BookingFee/>" ,
    "<TypeName>sessiongroup</TypeName></sessiongroup>")

    echo $projXml
    $j= AddSessionGroup $projXml
    echo $j > "$outputDir\$now.newSessionGroup.txt"
    return $j

}

$head= GetHeaders
echo $head
$now = Get-Date -format "yyyyMMdd.HHmmss"
echo "..Timestamp: $now"
echo ""
echo "Add new session ....."
$j= NewSession
echo $j

echo ""
echo "Add new session group....."
$j= NewSessionGroup
echo $j


