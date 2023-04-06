
####################################################################################################################

## Variables - Define before running

$location = "UKSouth"

$subid = "e8c18b6c-6da1-4409-8e95-abe76f91c3ba"
$subname = "UK-300000000067175-Waxwing-Test"

$rgname = "rg-tst-uks-image-builder"
$mi = "mi-tst-image-builder"

$galleryname = "img.tst.uks.001"
$imagedefname = "WindowsServer2019-Datacentre-x64-G2-GUI"

$identityName = "mi-tst-image-builder"
$templatename = "WindowsServer2019-Datacentre-x64-G2-GUI"
$runOutputName = "DistResults"


####################################################################################################################

## Define Template Location

$templatefilepath = ".\Azure Image Builder\_templates\template_WindowsServer2019-Datacentre-x64-G2-GUI.json"

####################################################################################################################

## Deploy via ARM Template

New-AzResourceGroupDeployment -ResourceGroupName $rgname -TemplateFile $templatefilepath

## Start Image Build and Export to Gallery

Start-AzImageBuilderTemplate -ResourceGroupName $rgname -Name $templatename

## Tidy up

Remove-AzImageBuilderTemplate -ResourceGroupName $rgname -Name $templatename
