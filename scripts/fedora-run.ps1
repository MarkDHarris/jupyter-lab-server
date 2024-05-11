$StartTime = $(get-date);

$USERNAME="maharris"
$IMAGENAME = "jupyterfedora:latest"

docker run -it -p 8888:8888 --rm -u $USERNAME --mount "type=bind,src=${pwd}\notebooks,target=/opt/notebooks" $IMAGENAME

$StopTime = $(get-date);
$ElapsedTime = $StopTime - $StartTime;
$TotalTime = "{0:HH:mm:ss}" -f ([datetime]$ElapsedTime.Ticks);
Write-Host
Write-Host $TotalTime;