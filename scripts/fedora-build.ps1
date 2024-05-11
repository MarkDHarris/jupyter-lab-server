$StartTime = $(get-date);

$USERNAME="maharris"
$IMAGENAME = "jupyterfedora:latest"
$ARCH="amd64"

docker build -t $IMAGENAME --progress=plain -f ./fedora/Dockerfile --build-arg USERNAME="$USERNAME" .

$StopTime = $(get-date);
$ElapsedTime = $StopTime - $StartTime;
$TotalTime = "{0:HH:mm:ss}" -f ([datetime]$ElapsedTime.Ticks);
Write-Host
Write-Host $TotalTime;