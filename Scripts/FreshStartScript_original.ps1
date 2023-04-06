
## Azure Image Builder Testing Script ##


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
$templatename = 'WindowsServer2019-Datacentre-x64-G2-GUI'
$runOutputName = 'DistResults'


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
    Description = 'CGI Created Definition for Server 2019 x64 GEN 2 Image - CIS L1'
    MinimumMemory = '4'
    MinimumVCPU = '1'
    Architecture = 'x64'
  }

  New-AzGalleryImageDefinition @galleryparams


####################################################################################################################

## Create Image

$SrcObjParams = @{
    PlatformImageSource = $true
    Publisher = 'MicrosoftWindowsServer'
    Offer = 'windowsserver'
    Sku = '2019-datacenter-gensecond'
    Version = 'latest'
  }

  $srcplatform = New-AzImageBuilderTemplateSourceObject @SrcObjParams

######

  $disObjParams = @{
    SharedImageDistributor = $true
    ArtifactTag = @{tag='dis-share'}
    GalleryImageId = "/subscriptions/$subID/resourceGroups/$rgname/providers/Microsoft.Compute/galleries/$galleryname/images/$imagedefname"
    ReplicationRegion = $location
    RunOutputName = $runOutputName
    ExcludeFromLatest = $false
  }

  $disSharedImg = New-AzImageBuilderTemplateDistributorObject @disObjParams

######

## Custom 1 ##

$ImgCustomParams01 = @{
  PowerShellCustomizer = $true
  Name = 'runprovisioningscript'
  RunElevated = $true
  SourceUri = 'https://raw.githubusercontent.com/rwilc/stuffandtings/main/provision_server2019_dc_image.ps1'
}

  $imagecustom01 = New-AzImageBuilderTemplateCustomizerObject @ImgCustomParams01

###

  $ImgTemplateParams = @{
    ImageTemplateName = $templatename
    ResourceGroupName = $rgname
    Source = $srcPlatform
    Distribute = $disSharedImg
    Customize = $imagecustom01
    Location = $location
    UserAssignedIdentityId = $identityNameResourceId
    VMProfileVmsize = "Standard_B2s"
  }

  New-AzImageBuilderTemplate @ImgTemplateParams

######

Start-AzImageBuilderTemplate -ResourceGroupName $rgname -Name $templatename