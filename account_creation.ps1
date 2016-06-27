#Creates the initial EDI Check Form.


# This form will create an account based upon the information provided in the fields.
# After clicking "Create" it will prompt for a password in the original powershell window     (should still be open in the background.
# Once the account is created it will be set to "Smart Card Required" using the upn field followed by "@company"
# This can be changed by changing "SmartCardLogonRequired" to $false.  Note if you leave it enabled and then uncheck it manually you will have to reset their password

# Set up the form         =========================================================    ==

Function NewCheckEDIForm {

	$objForm.Close()
	$objForm.Dispose()
	CheckEDIForm

}

Function CloseErrorForm {

    $errorForm.Close()
	$errorForm.Dispose()
	CheckEDIForm

}

Function CloseEDIFormEDIExists {

    $CheckEDIForm.Close()
    $CheckEDIForm.Dispose()
    EDIExists

}
Function CloseEDIFormMakeForm {
    
    $CheckEDIForm.Close()
    $CheckEDIForm.Dispose()
    MakeForm

}

Function NewUsersHDrive {

# Assign the Drive letter and Home Drive for
# the user in Active Directory

    #$AccountName = 'aaaa.aaaa'
    #$UPN = '1234567890@mil'
    #$HomeDrive=’Z:’

$UserRoot= '\\Server\users\'
$HomeDirectory=$UserRoot+$script:legacy

# SET-ADUSER $AccountName –HomeDrive $HomeDrive –HomeDirectory $HomeDirectory 

# Create the folder on the root of the common Users Share

NEW-ITEM –path $HomeDirectory -type directory 
$Domain=’DOMAIN’
$IdentityReference=$Domain+’\’+$script:legacy

# Set parameters for Access rule

$FileSystemAccessRights=[System.Security.AccessControl.FileSystemRights]”FullControl”
$InheritanceFlags=[System.Security.AccessControl.InheritanceFlags]”ContainerInherit, ObjectInherit”
$PropagationFlags=[System.Security.AccessControl.PropagationFlags]”None”
$AccessControl=[System.Security.AccessControl.AccessControlType]”Allow”

# Build Access Rule from parameters

$AccessRule = NEW-OBJECT System.Security.AccessControl.FileSystemAccessRule -argumentlist ($IdentityReference,$FileSystemAccessRights,$InheritanceFlags,$PropagationFlags,$AccessControl)

# Get current Access Rule from Home Folder for User


$HomeFolderACL = GET-ACL $HomeDirectory
$HomeFolderACL.AddAccessRule($AccessRule)
SET-ACL –path $HomeDirectory -AclObject $HomeFolderACL
}

Function MakeForm {


[void]     [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

[void]     [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

import-module ActiveDirectory


$objForm = New-Object System.Windows.Forms.Form

$objForm.Text = "Create Account"

$objForm.Size = New-Object System.Drawing.Size(600,420)

$objForm.StartPosition = "CenterScreen"

$objForm.KeyPreview = $True

#testing Data#


$FirstNameLabel = New-Object System.Windows.Forms.Label

$FIRSTNAME = New-Object System.Windows.Forms.TextBox
$UnlockAccountButton = New-Object System.Windows.Forms.Button
$InitialState = New-Object System.Windows.Forms.FormWindowState 

#placing fields ===============================

$LastnameLabel = New-Object System.Windows.Forms.Label
$LastnameLabel.Location = New-Object System.Drawing.Size (20,20)
$LastnameLabel.Size = New-Object System.Drawing.Size (100,15)
$LastnameLabel.Text = "Last Name"
$objForm.Controls.Add($LastnameLabel)

$objTextBox = New-Object System.Windows.Forms.TextBox 
$objTextBox.Location = New-Object System.Drawing.Size(20,40) 
$objTextBox.Size = New-Object System.Drawing.Size(250,20) 
$objForm.Controls.Add($objTextBox) 

$FirstnameLabel = New-Object System.Windows.Forms.Label
$FirstnameLabel.Location = New-Object System.Drawing.Size (20,65)
$FirstnameLabel.Size = New-Object System.Drawing.Size (100,15)
$FirstnameLabel.Text = "First Name"
$objForm.Controls.Add($FirstnameLabel)

$objFirstNameTextBox = New-Object System.Windows.Forms.TextBox 
$objFirstNameTextBox.Location = New-Object System.Drawing.Size(20,85) 
$objFirstNameTextBox.Size = New-Object System.Drawing.Size(250,20) 
$objForm.Controls.Add($objFirstNameTextBox)

$MiddleLabel = New-Object System.Windows.Forms.Label
$MiddleLabel.Location = New-Object System.Drawing.Size (20,110)
$MiddleLabel.Size = New-Object System.Drawing.Size (100,15)
$MiddleLabel.Text = "Middle Initial"
$objForm.Controls.Add($MiddleLabel)

$objMiddleTextBox = New-Object System.Windows.Forms.TextBox 
$objMiddleTextBox.Location = New-Object System.Drawing.Size(20,130) 
$objMiddleTextBox.Size = New-Object System.Drawing.Size(250,20) 
$objForm.Controls.Add($objMiddleTextBox)

$EmailLabel = New-Object System.Windows.Forms.Label
$EmailLabel.Location = New-Object System.Drawing.Size (20,155)
$EmailLabel.Size = New-Object System.Drawing.Size (100,15)
$EmailLabel.Text = "Email Address"
$objForm.Controls.Add($EmailLabel)

$objEmailTextBox = New-Object System.Windows.Forms.TextBox 
$objEmailTextBox.Location = New-Object System.Drawing.Size(20,175) 
$objEmailTextBox.Size = New-Object System.Drawing.Size(250,20) 
$objForm.Controls.Add($objEmailTextBox)

$PhoneLabel = New-Object System.Windows.Forms.Label
$PhoneLabel.Location = New-Object System.Drawing.Size (20,200)
$PhoneLabel.Size = New-Object System.Drawing.Size (100,15)
$PhoneLabel.Text = "Phone Number"
$objForm.Controls.Add($PhoneLabel)

$objPhoneTextBox = New-Object System.Windows.Forms.TextBox 
$objPhoneTextBox.Location = New-Object System.Drawing.Size(20,220) 
$objPhoneTextBox.Size = New-Object System.Drawing.Size(250,20) 
$objForm.Controls.Add($objPhoneTextBox)

$OfficeLabel = New-Object System.Windows.Forms.Label
$OfficeLabel.Location = New-Object System.Drawing.Size (20,245)
$OfficeLabel.Size = New-Object System.Drawing.Size (100,15)
$OfficeLabel.Text = "Office"
$objForm.Controls.Add($OfficeLabel)

$objOfficeTextBox = New-Object System.Windows.Forms.TextBox 
$objOfficeTextBox.Location = New-Object System.Drawing.Size(20,265) 
$objOfficeTextBox.Size = New-Object System.Drawing.Size(250,20) 
$objForm.Controls.Add($objOfficeTextBox)

$PasswordLabel = New-Object System.Windows.Forms.Label
$PasswordLabel.Location = New-Object System.Drawing.Size (20,290)
$PasswordLabel.Size = New-Object System.Drawing.Size (100,15)
$PasswordLabel.Text = "Password"
$objForm.Controls.Add($PasswordLabel)

$objPasswordTextBox = New-Object System.Windows.Forms.MaskedTextBox
$objPasswordTextBox.Location = New-Object System.Drawing.Size(20,310)
$objPasswordTextBox.PasswordChar = '*'
$objPasswordTextBox.Size = New-Object System.Drawing.Size(250,20) 
$objForm.Controls.Add($objPasswordTextBox)


$LegacyLabel = New-Object System.Windows.Forms.Label
$LegacyLabel.Location = New-Object System.Drawing.Size (290,20)
$LegacyLabel.Size = New-Object System.Drawing.Size (100,15)
$LegacyLabel.Text = "Legacy Username"
$objForm.Controls.Add($LegacyLabel)

$objLegacy = New-Object System.Windows.Forms.TextBox 
$objLegacy.Location = New-Object System.Drawing.Size(290,40) 
$objLegacy.Size = New-Object System.Drawing.Size(250,20) 
$objForm.Controls.Add($objLegacy) 

$UPNLabel = New-Object System.Windows.Forms.Label
$UPNLabel.Location = New-Object System.Drawing.Size (290,65)
$UPNLabel.Size = New-Object System.Drawing.Size (100,15)
$UPNLabel.Text = "EDIPI"
$objForm.Controls.Add($UPNLabel)

$objUPNText = New-Object System.Windows.Forms.Label 
$objUPNText.Location = New-Object System.Drawing.Size(290,85) 
$objUPNText.Size = New-Object System.Drawing.Size(250,20) 
$objUPNText.Text = "$script:UPN"
$objForm.Controls.Add($objUPNText)

$TitleLabel = New-Object System.Windows.Forms.Label
$TitleLabel.Location = New-Object System.Drawing.Size (290,110)
$TitleLabel.Size = New-Object System.Drawing.Size (250,15)
$TitleLabel.Text = "Title (ex: SFC MIL USA USARCENT)"
$objForm.Controls.Add($TitleLabel)

$objTitle = New-Object System.Windows.Forms.TextBox 
$objTitle.Location = New-Object System.Drawing.Size(290,130) 
$objTitle.Size = New-Object System.Drawing.Size(250,20) 
$objForm.Controls.Add($objTitle) 

$ExpireLabel = New-Object System.Windows.Forms.Label
$ExpireLabel.Location = New-Object System.Drawing.Size (290,155)
$ExpireLabel.Size = New-Object System.Drawing.Size (100,15)
$ExpireLabel.Text = "Expiration Date"
$objForm.Controls.Add($ExpireLabel)

$objExpire = New-Object System.Windows.Forms.MonthCalendar 
$objExpire.Location = New-Object System.Drawing.Size(290,175) 
$objExpire.Size = New-Object System.Drawing.Size(250,20) 
$objForm.Controls.Add($objExpire) 
# Button and action         ========================================================

$CreateAccountButton = New-Object System.Windows.Forms.Button

$CreateAccountButton.Size = New-Object System.Drawing.Size (100,30)

$CreateAccountButton.Location = New-Object System.Drawing.Size (20,340)

$CreateAccountButton.Text = "Create Account"

$objForm.Controls.Add($CreateAccountButton)

$CreateAccountButton.Add_Click(
{

$userfirst=$objFirstNameTextBox.Text
$userlast=$objTextBox.Text
$usermiddle = $objMiddleTextBox.Text
$Title = $objTitle.Text
$script:legacy = $objLegacy.Text
$email = $objEmailTextBox.Text
$phoneNumber = $objPhoneTextBox.Text
$office = $objOfficeTextBox.Text
$name = $userlast +", " + $userfirst + " " + $usermiddle
$displayname = $userlast +", " + $userfirst + " " + $usermiddle + " " + $Title
$principalName = $script:UPN
$expireDateDefault = $objExpire.SelectionStart
$expireDate = $expireDateDefault.ToShortDateString()
$securepw = $objPasswordTextBox.Text | ConvertTo-SecureString -AsPlainText -Force

New-ADUser -SamAccountName $script:legacy -GivenName $userfirst -Surname $userlast -Initials $usermiddle -Name $name -DisplayName $displayname -Description $displayname -Path 'WE NEED DA OU' -SmartcardLogonRequired $true -AccountPassword $securepw -UserPrincipalName  $principalName -Enabled $true -EmailAddress $email -AccountExpirationDate $expireDate -HomeDrive "H:" -HomeDirectory "\\3usaa7swan100\users\$legacy" -PasswordNeverExpires $true -Office $office -OfficePhone $phoneNumber

NewUsersHDrive

NewCheckEDIForm

}
)

# Activate the form       =========================================================



$objForm.Add_Shown({$objForm.Activate()})

[void] $objForm.ShowDialog()
}

Function CheckEDIForm {

[void]     [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void]     [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

import-module ActiveDirectory

$CheckEDIForm = New-Object System.Windows.Forms.Form
$CheckEDIForm.Text = "Check if user exists:"
$CheckEDIForm.Size = New-Object System.Drawing.Size(300,175)
$CheckEDIForm.StartPosition = "CenterScreen"
$CheckEDIForm.KeyPreview = $True

$CheckEDILabel = New-Object System.Windows.Forms.Label
$CheckEDILabel.Location = New-Object System.Drawing.Size (25,25)
$CheckEDILabel.Size = New-Object System.Drawing.Size (125,15)
$CheckEDILabel.Text = "Enter the User's EDIPI:"
$CheckEDIForm.Controls.Add($CheckEDILabel)

$CheckEDITextBox = New-Object System.Windows.Forms.TextBox 
$CheckEDITextBox.Location = New-Object System.Drawing.Size(27,45) 
$CheckEDITextBox.Size = New-Object System.Drawing.Size(130,20) 
$CheckEDIForm.Controls.Add($CheckEDITextBox)

$CheckEDIButton = New-Object System.Windows.Forms.Button
$CheckEDIButton.Size = New-Object System.Drawing.Size (75,30)
$CheckEDIButton.Location = New-Object System.Drawing.Size (100,85)
$CheckEDIButton.Text = "Check EDI"
$CheckEDIForm.Controls.Add($CheckEDIButton)

$CheckEDIButton.Add_Click(
{

$UPN = $CheckEDITextBox.Text
$script:UPN = $UPN + '@mil'
$UPNCheck = get-aduser -filter "userprincipalname -like '$script:UPN'" | select -ExpandProperty userprincipalname

if ($UPNCheck -eq $null)
    {
    CloseEDIFormMakeForm
    }

else 
    {
    CloseEDIFormEDIExists
    }
}
)

$CheckEDIForm.Add_Shown({$CheckEDIForm.Activate()})
[void] $CheckEDIForm.ShowDialog()

}

Function EDIexists
{
$distinguishedName = get-aduser -Filter "userprincipalname -like '$script:upn'" | select -ExpandProperty distinguishedname

$errorForm = New-Object System.Windows.Forms.Form
$errorForm.Text = "User already exists"
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
    CloseErrorForm
    }
)

$errorForm.Add_Shown({$errorForm.Activate()})
[void] $errorForm.ShowDialog()
}

CheckEDIForm
