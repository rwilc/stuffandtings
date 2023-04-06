
## Variables - Define before running

$location = "UKSouth"

$subid = "e8c18b6c-6da1-4409-8e95-abe76f91c3ba"
$subname = "UK-300000000067175-Waxwing-Test"

$rgname = "rg-tst-uks-image-builder"
$mi = "mi-tst-image-builder"

$galleryname = "img.tst.uks.002"
$imagedefname = "WindowsServer2019-Datacentre-x64-G2-GUI-002"


####################################################################################################################

## Connect to Azure

Connect-AzAccount

Set-AzContext -Subscription $subid

####################################################################################################################

## Set identity Vars

$identitynameresourceid = (Get-AzUserAssignedIdentity -ResourceGroupName $rgname -Name $identityName).Id
$identitynameprincipalid = (Get-AzUserAssignedIdentity -ResourceGroupName $rgname -Name $identityName).PrincipalId

####################################################################################################################


## Create Image Gallery

New-AzGallery -GalleryName $galleryname -ResourceGroupName $rgname -Location $location

## Define Definition details

$galleryparams = @{
    GalleryName = $galleryname
    ResourceGroupName = $rgname
    Location = $location
    Name = $imageDefName
    OsState = 'generalized'
    OsType = 'Windows'
    Publisher = 'CGI'
    Offer = 'Windows'
    Sku = '2019-datacenter-gensecond'
    HyperVGeneration = "V2"
    Description = 'CGI Created Definition for Server 2019 x64 GEN 2 Images'
    MinimumMemory = '4'
    MinimumVCPU = '1'
    Architecture = 'x64'
  }

  New-AzGalleryImageDefinition @galleryparams


####################################################################################################################
