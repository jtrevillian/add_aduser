Function MakeEDIForm {

[void]     [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void]     [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

import-module ActiveDirectory

$checkForm = New-Object System.Windows.Forms.Form
$checkForm.Text = "Check if user exists:"
$checkForm.Size = New-Object System.Drawing.Size(300,175)
$checkForm.StartPosition = "CenterScreen"
$checkForm.KeyPreview = $True

$UPNLabel = New-Object System.Windows.Forms.Label
$UPNLabel.Location = New-Object System.Drawing.Size (25,25)
$UPNLabel.Size = New-Object System.Drawing.Size (125,15)
$UPNLabel.Text = "Enter the User's EDIPI:"
$checkForm.Controls.Add($UPNLabel)

$objUPNTextBox = New-Object System.Windows.Forms.TextBox 
$objUPNTextBox.Location = New-Object System.Drawing.Size(27,45) 
$objUPNTextBox.Size = New-Object System.Drawing.Size(130,20) 
$checkForm.Controls.Add($objUPNTextBox)

$CheckEDIButton = New-Object System.Windows.Forms.Button
$CheckEDIButton.Size = New-Object System.Drawing.Size (75,30)
$CheckEDIButton.Location = New-Object System.Drawing.Size (100,85)
$CheckEDIButton.Text = "Check EDI"
$checkForm.Controls.Add($CheckEDIButton)

$CheckEDIButton.Add_Click(
{

$UPN = $objUPNTextBox.Text
$script:UPN = $UPN + '@mil'
$UPNCheck = get-aduser -filter "userprincipalname -like '$script:UPN'" | select -ExpandProperty userprincipalname

if ($UPNCheck -eq $null)
{
$checkForm.Close()
MakeNewForm
}

else 
    {
       $checkForm.Close()
       EDIexists
    }
}
)

$checkForm.Add_Shown({$checkForm.Activate()})
[void] $checkForm.ShowDialog()

}

Function EDIexists
{
$distinguishedName = get-aduser -Filter "userprincipalname -like '$script:upn'" | select -ExpandProperty distinguishedname

$errorForm = New-Object System.Windows.Forms.Form
$errorForm.Text = "Check if user exists:"
$errorForm.Size = New-Object System.Drawing.Size(500,175)
$errorForm.StartPosition = "CenterScreen"
$errorForm.KeyPreview = $True

$UPNLabel = New-Object System.Windows.Forms.Label
$UPNLabel.Location = New-Object System.Drawing.Size (25,25)
$UPNLabel.Size = New-Object System.Drawing.Size (175,15)
$UPNLabel.Text = "EDPI: $script:UPN"
$errorForm.Controls.Add($UPNLabel)

$distinguishedNameLabel = New-Object System.Windows.Forms.Label 
$distinguishedNameLabel.Location = New-Object System.Drawing.Size(27,45) 
$distinguishedNameLabel.Size = New-Object System.Drawing.Size(400,50)
$distinguishedNameLabel.Text = "Distinguished Name: $distinguishedName" 
$errorForm.Controls.Add($distinguishedNameLabel)

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Size = New-Object System.Drawing.Size (75,30)
$OKButton.Location = New-Object System.Drawing.Size (100,100)
$OKButton.Text =  'OK'
$errorForm.Controls.Add($OKButton)

$OKButton.Add_Click(
{
$errorForm.Close()
MakeEDIForm
}
)

$errorForm.Add_Shown({$errorForm.Activate()})
[void] $errorForm.ShowDialog()
}

MakeEDIForm
