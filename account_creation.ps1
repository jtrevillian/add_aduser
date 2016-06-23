# This form will create an account based upon the information provided in the fields.
# After clicking "Create" it will prompt for a password in the original powershell window     (should still be open in the background.
# Once the account is created it will be set to "Smart Card Required" using the upn field followed by "@company"
# This can be changed by changing "SmartCardLogonRequired" to $false.  Note if you leave it enabled and then uncheck it manually you will have to reset their password

# Set up the form         =========================================================    ==

Function MakeNewForm {

	$objForm.Close()
	$objForm.Dispose()
	MakeForm

}

Function NewUsersHDrive {

# Assign the Drive letter and Home Drive for
# the user in Active Directory

    #$AccountName = 'aaaa.aaaa'
    #$UPN = '1234567890@mil'
    #$HomeDrive=’Z:’

$UserRoot= '\\3usaa7swan100\users\'
$HomeDirectory=$UserRoot+$script:legacy

# SET-ADUSER $AccountName –HomeDrive $HomeDrive –HomeDirectory $HomeDirectory 

# Create the folder on the root of the common Users Share

NEW-ITEM –path $HomeDirectory -type directory 
$Domain=’swa.ds.army.mil’
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
$UnlockAccountButton = New-Object     System.Windows.Forms.Button
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

$objUPNTextBox = New-Object System.Windows.Forms.TextBox 
$objUPNTextBox.Location = New-Object System.Drawing.Size(290,85) 
$objUPNTextBox.Size = New-Object System.Drawing.Size(250,20) 
$objForm.Controls.Add($objUPNTextBox)

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

$CreateAccountButton = New-Object     System.Windows.Forms.Button

$CreateAccountButton.Size = New-Object System.Drawing.Size (100,30)

$CreateAccountButton.Location = New-Object System.Drawing.Size (20,340)

$CreateAccountButton.Text = "Create Account"

$objForm.Controls.Add($CreateAccountButton)

$CreateAccountButton.Add_Click(
{

$userfirst=$objFirstNameTextBox.Text
$userlast=$objTextBox.Text
$usermiddle = $objMiddleTextBox.Text
$UPN = $objUPNTextBox.Text
$Title = $objTitle.Text
$script:legacy = $objLegacy.Text
$email = $objEmailTextBox.Text
$phoneNumber = $objPhoneTextBox.Text
$office = $objOfficeTextBox.Text
$name = $userlast +", " + $userfirst + " " + $usermiddle
$displayname = $userlast +", " + $userfirst + " " + $usermiddle + " " + $Title
$principalName = $UPN + "@mil"
$expireDateDefault = $objExpire.SelectionStart
$expireDate = $expireDateDefault.ToShortDateString()
$securepw = $objPasswordTextBox.Text | ConvertTo-SecureString -AsPlainText -Force

New-ADUser -SamAccountName $script:legacy -GivenName $userfirst -Surname $userlast -Initials $usermiddle -Name $name -DisplayName $displayname -Description $displayname -Path 'OU=Users,OU=3USAMCP,OU=Organizations,OU=SAFB,OU=-USA,DC=swa,DC=ds,DC=army,DC=mil' -SmartcardLogonRequired $true -AccountPassword $securepw -UserPrincipalName  $principalName -Enabled $true -EmailAddress $email -AccountExpirationDate $expireDate -HomeDrive "H:" -HomeDirectory "\\3usaa7swan100\users\$legacy" -PasswordNeverExpires $true -Office $office -OfficePhone $phoneNumber

NewUsersHDrive

MakeNewForm

}
)

# Activate the form       =========================================================



$objForm.Add_Shown({$objForm.Activate()})

[void] $objForm.ShowDialog()
}

MakeForm