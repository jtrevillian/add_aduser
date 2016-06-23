Function MakeEDIForm {

[void]     [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

[void]     [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

import-module ActiveDirectory

$objForm = New-Object System.Windows.Forms.Form

$objForm.Text = "Check if user exists:"

$objForm.Size = New-Object System.Drawing.Size(300,175)

$objForm.StartPosition = "CenterScreen"

$objForm.KeyPreview = $True




$UPNLabel = New-Object System.Windows.Forms.Label
$UPNLabel.Location = New-Object System.Drawing.Size (25,25)
$UPNLabel.Size = New-Object System.Drawing.Size (125,15)
$UPNLabel.Text = "Enter the User's EDIPI:"
$objForm.Controls.Add($UPNLabel)

$objUPNTextBox = New-Object System.Windows.Forms.TextBox 
$objUPNTextBox.Location = New-Object System.Drawing.Size(27,45) 
$objUPNTextBox.Size = New-Object System.Drawing.Size(130,20) 
$objForm.Controls.Add($objUPNTextBox)




$CheckEDIButton = New-Object System.Windows.Forms.Button
$CheckEDIButton.Size = New-Object System.Drawing.Size (75,30)
$CheckEDIButton.Location = New-Object System.Drawing.Size (100,85)
$CheckEDIButton.Text = "Check EDI"

$objForm.Controls.Add($CheckEDIButton)

[void] $objForm.ShowDialog()

}

MakeEDIForm
