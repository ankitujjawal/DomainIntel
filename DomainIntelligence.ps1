#####Auth request by storing username and password in the script#######

$Username = 'email@xxx.com'
$Password = 'password'


$SecureStringPassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecureStringPassword)


###.COM Search###
$start_time = Get-Date
$output = "C:\PS\Output\Registered_Domains\COM"

$currentDay = $(get-date).AddDays(-1).ToString("yyyy-MM-dd")
$filename = $currentDay
# This URL changes depending on the domain which is being downloaded ex .com, .biz, .gov
$fileurl = "http://bestwhois.org/domain_name_data/domain_names_new/com/$currentDay/add.com.csv"
echo $fileurl
# Get the file the is hosted today.
Invoke-WebRequest -Uri $fileurl -OutFile "$output\$filename.csv" -Credential $Credential


#input downloaded domain list, match against the selected string then export it to a new CSV
$COMresult = "C:\PS\Output\COM_SearchResult.csv"
get-content "$output\$filename.csv"| Select-String "KEYWORDtoMATCH" -SimpleMatch | select line | Export-Csv "$COMresult"



###.BIZ Search###
$output = "C:\PS\Output\Registered_Domains\BIZ"
$currentDay = $(get-date).AddDays(-1).ToString("yyyy-MM-dd")
$filename = $currentDay
# This URL changes depending on the domain which is being downloaded ex .com, .biz, .gov
$fileurl = "http://bestwhois.org/domain_name_data/domain_names_new/biz/$currentDay/add.biz.csv"
echo $fileurl
# Get the file the is hosted today.
Invoke-WebRequest -Uri $fileurl -OutFile "$output\$filename.csv" -Credential $Credential

 
 

$BIZresult = "C:\PS\Output\BIZ_SearchResult.csv"
#input downloaded domain list, match against the selected string then export it to a new CSV
get-content "$output\$filename.csv"| Select-String "KEYWORDtoMATCH" -SimpleMatch | select line | Export-Csv "$BIZresult"



###.ORG Search###
$output = "C:\PS\Output\Registered_Domains\ORG"
$currentDay = $(get-date).AddDays(-1).ToString("yyyy-MM-dd")
$filename = $currentDay
# This URL changes depending on the domain which is being downloaded ex .com, .biz, .gov
$fileurl = "http://bestwhois.org/domain_name_data/domain_names_new/org/$currentDay/add.org.csv"
echo $fileurl
# Get the file the is hosted today.
Invoke-WebRequest -Uri $fileurl -OutFile "$output\$filename.csv" -Credential $Credential


#input downloaded domain list, match against the selected string then export it to a new CSV
$ORGresult = "C:\PS\Output\ORG_SearchResult.csv"
get-content "$output\$filename.csv"| Select-String "KEYWORDtoMATCH" -SimpleMatch | select line | Export-Csv "$ORGresult"



#time taken for download task to run
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"


#####send attachment via The System.Net.Mail Method#####

#$file = "$COMresult, $BIZresult"

$emailFrom = "IT Security Team <ITSecurityTeam@XXX.com>"
$emailTo = "user@XXX.com"
$subject = "Newly Registed Domains"
$body = "Newly registered domains for today matching'COMPANYDOMAIN' please review"
$smtpServer = "smtp.COMPANYDOMAIN.internal"
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$MailMessage = new-object Net.Mail.MailMessage($emailFrom, $emailTo, $subject, $body)
$MailMessage.IsBodyHtml = $true

$MailMessage.Attachments.Add($BIZresult)
$MailMessage.Attachments.Add($COMresult)
$MailMessage.Attachments.Add($ORGresult)
$smtp.Send($MailMessage)