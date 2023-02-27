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

Function NewSessionGroup(){
    $xml= "<Title>A new test prosession group (davel)</Title>" `
    +"<Type>Individual</Type>" `
    +"<Programmes/>" `
    +"<Projects>1</Projects>" `
    +"<BookingMode>Session</BookingMode>" `
    +"<RegisterGroupings/>" `
    +"<RestrictedRecord>0</RestrictedRecord>" `
    +"<AllowSessionTypes>Session|Event</AllowSessionTypes>" `
    +"<Created>2022-06-07 14:48:29</Created>" `
    +"<CreatedBy>yussuf.mrabty</CreatedBy>" `
    +"<Updated>2022-06-22 14:19:09</Updated>" `
    +"<UpdatedBy>dave.lobban</UpdatedBy>" `
    +"<Archived>0000-00-00 00:00:00</Archived>" `
    +"<ArchivedBy/>" `
    +"<Description>45min bookable slots for young people to get 1-2-1 support advice and tutoring in music and music production.</Description>" `
    +"<LeadStaff>22</LeadStaff>" `
    +"<OtherStaff>702|838|578|670</OtherStaff>" `
    +"<VenueID>1</VenueID>" `
    +"<StartDate>2022-06-09</StartDate>" `
    +"<EndDate>2022-07-21</EndDate>" `
    +"<PlannedSessions>0</PlannedSessions>" `
    +"<AgeGroupFrom>8</AgeGroupFrom>" `
    +"<AgeGroupTo>21</AgeGroupTo>" `
    +"<NumberOfPlaces>0</NumberOfPlaces>" `
    +"<ParticipantQuestionnaireID>5|22|11|7|18|12|6|3|14|10</ParticipantQuestionnaireID>" `
    +"<SessionQuestionnaireID>5|22|7|18|12|6|3|14|10</SessionQuestionnaireID>" `
    +"<Cost>2.00</Cost>" `
    +"<BookingFee/>" `
    +"<SessionGroupID>72</SessionGroupID>" `
    +"<registerCount>13</registerCount>" `
    +"<reservationsPending>0</reservationsPending>" `
    +"<TypeName>sessiongroup</TypeName>" 

    echo $projXml
    $j= AddSessionGroup $projXml
    echo $j > "$outputDir\$now.newSessionGroup.txt"
    return $j
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


$head= GetHeaders
echo $head
$now = Get-Date -format "yyyyMMdd.HHmmss"
echo "..Timestamp: $now"


echo ""
echo "Add new session group....."
$j= NewSessionGroup
echo $j


