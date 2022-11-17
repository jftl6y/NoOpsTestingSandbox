param (
    $bicepFilePath = "./",
    $outDir = "C:\test\bicepCompiled"
)

$bicepFiles = get-childItem $bicepFilePath -Filter *.bicep -Recurse
foreach ($file in $bicepFiles)
{
    $outputFile = $file.FullName.Replace(".bicep", ".json").Replace($file.DirectoryName, $outDir)
    $fileFullName = $file.FullName
    write-host "Compiling $fileFullName"
    bicep build $file.FullName --outfile $outputFile
    if (test-path $outputFile)
    {
        write-host "Compiled $fileFullName to $outputFile"
    }
    else
    {
        write-host "Failed to compile $fileFullName"
        $errList += "$fileFullName`r`n"
    }    
}
$errorFilePath = $outDir + "\bicepCompileErrors.txt"
out-file -filepath $errorFilePath -inputobject $errList