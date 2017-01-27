CLS 
# by Cooper
# v1

$CSV = "E:\Case01\what-to-search.csv" #neimportuje se jako csv! Jedna hodnota na jeden řádek!
$Path = "E:\Case01\logs\"
$Results = "E:\Case01\results\"
#inspiration: https://www.adminarsenal.com/admin-arsenal-blog/powershell-searching-through-files-for-matching-strings/

Get-Content -Path $CSV | Foreach-Object { 
	$Text = $_
	$PathArray = @()
	$TS = Get-Date -format yyyyMMdd@HHmmss
	
	Get-ChildItem $Path -Recurse -Include *.log, *.txt |
		Where-Object { $_.Attributes -ne "Directory"} |
			ForEach-Object {
				If (Get-Content $_.FullName | Select-String -Pattern $Text) { 
								$PathArray += $_.FullName
								$file = $_.Name
								Write-Host "Match for" $Text "in:" $file -ForegroundColor Red -BackgroundColor DarkYellow
								Select-String -Path $_.FullName -Pattern $Text -AllMatches | Foreach {$_.Line} | Add-Content $Results\$Text-$file-$TS.log
								}
							}
	Write-Host "Searched:" $Text - $TS
	Add-Content $Results\time-log.txt "$Text - $TS"
	
	$PathArray | ForEach-Object {$_}
	if ($PathArray.Count -ne 0) {
		$PathArray | % {$_} | Out-File $Results\Found-in-$Text-$TS.txt
		
		
		}
	}
Write-Host "Done" -BackgroundColor Yellow
