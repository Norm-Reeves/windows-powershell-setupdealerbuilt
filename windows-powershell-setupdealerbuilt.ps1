<# 
.DESCRIPTION
Powershell Script - Creates DealerBuilt RDP Shorcuts at the specified file directory for the specified username.
.AUTHOR
Casey Craven <casey.craven@normreeves.com>
#>

## Global Declarations
using namespace System.Management.Automation.Host
using namespace Syncfusion.Windows.Forms.Tools
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName System.Data
[Windows.Forms.Application]::EnableVisualStyles() # Enable Visual Styles

## Create C:\Temp folder and download image to temp for use in GUI
if (!(Test-Path -Path 'C:\Temp')){
	New-Item -ItemType Directory -Force -Path c:\Temp
}
## Downloads Images - from Azure Blob storage if not already in temp folder.
if (!(Test-Path 'C:\Temp\NR_Tech_Logo.png' -PathType Leaf)){
	Invoke-WebRequest -Uri 'https://stnormreevespublic001.blob.core.windows.net/intune/NR_Tech_Logo.png' -Outfile c:\Temp\NR_Tech_Logo.png
}
	
if (!(Test-Path 'c:\Temp\Folder_Icon.png' -PathType Leaf)){
	Invoke-WebRequest -Uri 'https://stnormreevespublic001.blob.core.windows.net/intune/Folder_Icon.png' -Outfile c:\Temp\Folder_Icon.png
}
## END - Download Images
## Create Form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = 'Create DealerBuilt Icons'
$Form.Size = New-Object System.Drawing.Size(700,500)
$Form.AutoSize = $True
$Form.StartPosition = 'CenterScreen'
$Form.ShowInTaskbar = $True
$Form.Refresh()
$Form.MaximizeBox = $False
$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$Form.KeyPreview = $True
$Form.Topmost = $true
$Form.ControlBox = $True
$icon = "C:\temp\Perm\NR.ico" 
$Form.Icon = $Icon
$Form.Add_Shown({$DealerBuiltUserNameTextBox.Select()})
$Form.Font = New-Object System.Drawing.Font("Cambria",10,[System.Drawing.FontStyle]::Regular)
## Add an Image/Logo
$image = [System.Drawing.Image]::FromFile("C:\Temp\NR_Tech_Logo.png")
$pictureBox = new-object System.Windows.Forms.PictureBox
$pictureBox.Location = New-object System.Drawing.Size(425,10)
$pictureBox.Width =  $image.Size.Width
$pictureBox.Height =  $image.Size.Height
$pictureBox.Image = $image	
$Form.controls.add($pictureBox)
## END - Add Image/Logo

## DealerBuilt Login
## DealerBuilt Login - Label
$DealerBuiltUserName = New-Object System.Windows.Forms.Label
$DealerBuiltUserName.Location = New-Object System.Drawing.Point(15,25)
$DealerBuiltUserName.Size = New-Object System.Drawing.Size(300,25)
$DealerBuiltUserName.Visible = $True
$DealerBuiltUserName.Text = 'DealerBuilt Username:'
$DealerBuiltUserName.Font = New-Object System.Drawing.Font("Cambria",10,[System.Drawing.FontStyle]::Bold) 
$Form.Controls.Add($DealerBuiltUserName)
## Warning Message if RDP Username is click out of.
$WarningText = New-Object System.Windows.Forms.Label
$WarningText.Location = New-Object System.Drawing.Point(15,25)
$WarningText.Size = New-Object System.Drawing.Size(300,25)
$WarningText.Text = ' EX: DBC\237.John.Smith'
$WarningText.Font = New-Object System.Drawing.Font("Cambria",10,[System.Drawing.FontStyle]::Bold) 
$WarningText.ForeColor = 'Red'
$WarningText.Visible = $False
$Form.Controls.Add($WarningText)
## DealerBuilt Login- TextBox 
$DealerBuiltUserNameTextBox = New-Object System.Windows.Forms.TextBox
$DealerBuiltUserNameTextBox.Location = New-Object System.Drawing.Point(15,50)
$DealerBuiltUserNameTextBox.Size = New-Object System.Drawing.Size(250,25)
$DealerBuiltUserNameTextBox.Text = 'DBC\237.First.Last'
$DealerBuiltUserNameTextBox.ForeColor  = 'Darkgray'
$DealerBuiltUserNameTextBox.Add_GotFocus({
		$DealerBuiltUserName.Visible = $True
		$DealerBuiltUserNameTextBox.ForeColor  = 'Black'
})
$DealerBuiltUserNameTextBox.Add_LostFocus({
	if($DealerBuiltUserNameTextBox.Text -eq 'DBC\237.First.Last'){
	$DealerBuiltUserName.Visible = $False
	$DealerBuiltUserNameTextBox.Text = $Null
	$WarningText.Visible = $True
	}
})
$Form.Controls.Add($DealerBuiltUserNameTextBox)
$DealerBuiltUserNameTextBox.Add_TextChanged({})
## END - DealerBuilt Login
## Path - Where to drop RDP Files
$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
## Path - Label
$PathLabel = New-Object System.Windows.Forms.Label
$PathLabel.Location = New-Object System.Drawing.Point(15,75)
$PathLabel.Size = New-Object System.Drawing.Size(300,25)
$PathLabel.Text = 'Path to setup DealerBuilt Icons:'
$PathLabel.Font = New-Object System.Drawing.Font("Cambria",10,[System.Drawing.FontStyle]::Bold) 
$Form.Controls.Add($PathLabel)
## DealerBuilt Login- TextBox 
$PathTextBox = New-Object System.Windows.Forms.TextBox
$PathTextBox.Location = New-Object System.Drawing.Point(15,100)
$PathTextBox.Text = $DesktopPath
$PathTextBox.Size = New-Object System.Drawing.Size(250,25)
$PathTextBox.Font = ‘Microsoft Sans Serif,10’
$Form.Controls.Add($PathTextBox)
## File Browser Function
Function Get-Folder($initialDirectory="c:\users\"){
	$PathTextBox.Text = $Null
	$foldername = New-Object System.Windows.Forms.FolderBrowserDialog
	$foldername.Description = "Select a folder"
	$foldername.SelectedPath = [environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
	if($foldername.ShowDialog() -eq "OK"){
		$folder += $foldername.SelectedPath
		$PathTextBox.Text = $FolderName.SelectedPath;
	}
	return $folder
}
## END - File Browser Function
## END - Path
## Group CheckBox - Autosizes based on Array List via incremental $y (Y Coordinate)
$y = 20
$DealerBuiltGroupBox = New-Object System.Windows.Forms.GroupBox
$DealerBuiltGroupBox.Location = New-Object System.Drawing.Point(10,135)  
$DealerBuiltGroupBox.text = "Required Server Shortcuts"
$DealerBuiltGroupBox.Font = New-Object System.Drawing.Font("Cambria",10,[System.Drawing.FontStyle]::Bold)  
$Form.Controls.Add($DealerBuiltGroupBox)
$Checkboxes += New-Object System.Windows.Forms.CheckBox
## Array of DealerBuilt Servers                
$DBServers = @()
$DBServers += @{"DBServerNumber"="232"}
$DBServers += @{"DBServerNumber"="233"}
$DBServers += @{"DBServerNumber"="235"}
$DBServers += @{"DBServerNumber"="236"}
$DBServers += @{"DBServerNumber"="237"}
$DBServers += @{"DBServerNumber"="286"}
$DBServers += @{"DBServerNumber"="287"}
$DBServers += @{"DBServerNumber"="289"}
$DBServers += @{"DBServerNumber"="371"}
$DBServers += @{"DBServerNumber"="399"}
$DBServers += @{"DBServerNumber"="404"}
$Checkboxes = @()
## For Each - adds a checkbox for each referenced server in Array list $DBServers           
foreach ($DBServerNumber in $DBServers){    
	$Checkbox = New-Object System.Windows.Forms.CheckBox
	$Checkbox.Text = $DBServerNumber.DBServerNumber
	$Checkbox.Font = New-Object System.Drawing.Font("Cambria",10,[System.Drawing.FontStyle]::Regular)  
	$Checkbox.Name = $DBServerNumber.DBServerNumber
	$Checkbox.Location = New-Object System.Drawing.Size(10,$y) 
	## adds to vertical coordinates
	$y += 30                                                            
	$DealerBuiltGroupBox.Controls.Add($Checkbox) 
	$Checkboxes += $Checkbox
}
$Checkboxes.add_CheckedChanged({
	$okButton.Enabled = $True                            
	if(($Checkboxes.Checked -eq $True).Count -ge 1){
		$okButton.Enabled = $True
	}
	else{
		$okButton.Enabled = $False
	}
}) 
## END - For Each
## Sets overall size of Box arround chekbox array.  
$DealerBuiltGroupBox.size = New-Object System.Drawing.Size(250,(33*$checkboxes.Count))
$PreviousEntry = $DealerBuiltUserNameTextBox.Text
## Create-RDPShortcut : Script to Create RDP Shortcut Files  
$BadFormatRunCount = 0;
Function Create-RDPShortcut{
	if($DealerBuiltUserNameTextBox.Text -notmatch [regex]::Escape("DBC\")+"\d\d\d"+[regex]::Escape(".") -and ($BadFormatRunCount = "0") ){
		## Message Box / Notification
		$MessageBoxDialogCount = '0'
		$BadFormatRunCount +1
		$PreviousEntry = $DealerBuiltUserNameTextBox.Text
		$MessageBox = New-Object System.Windows.Forms.Form
		$MessageBox.Text = 'ERROR: Format'
		$MessageBox.Size = New-Object System.Drawing.Size(300,200)
		$MessageBox.StartPosition = 'CenterScreen'
		## MessageBox OK 
		$MessageBoxOkButton = New-Object System.Windows.Forms.Button
		$MessageBoxOkButton.Location = New-Object System.Drawing.Point(49,120)
		$MessageBoxOkButton.Size = New-Object System.Drawing.Size(100,25)
		$MessageBoxOkButton.Text = 'Re-Enter'
		$MessageBoxOkButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
		$MessageBox.AcceptButton = $MessageBoxOkButton
		$MessageBox.Controls.Add($MessageBoxOkButton)
		## MessageBox Leave Empty/Null
		$LeaveEmptyButton = New-Object System.Windows.Forms.Button
		$LeaveEmptyButton.Location = New-Object System.Drawing.Point(150,120)
		$LeaveEmptyButton.Size = New-Object System.Drawing.Size(100,25)
		$LeaveEmptyButton.Text = 'Leave Empty'
		$LeaveEmptyButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
		$MessageBox.CancelButton = $LeaveEmptyButton
		$MessageBox.Controls.Add($LeaveEmptyButton)
		## UserName Correction Label
		$label = New-Object System.Windows.Forms.Label
		$label.Location = New-Object System.Drawing.Point(10,20)
		$label.Size = New-Object System.Drawing.Size(280,40)
		$label.Text = 'Please Enter a properly formatted DealerBuilt UserName:'
		$MessageBox.Controls.Add($label)
		## UserName Correction Textbox 
		$UserNameCorrectionTextBox = New-Object System.Windows.Forms.TextBox
		$UserNameCorrectionTextBox.Location = New-Object System.Drawing.Point(10,60)
		$UserNameCorrectionTextBox.Text = $PreviousEntry
		$UserNameCorrectionTextBox.Size = New-Object System.Drawing.Size(260,20)
		$MessageBox.Controls.Add($UserNameCorrectionTextBox)
		$UsernameExample = New-Object System.Windows.Forms.Label
		$UsernameExample.Location = New-Object System.Drawing.Point(10,80)
		$UsernameExample.Text = '  Example:  DBC\237.John.Smith'
		$UsernameExample.ForeColor = 'Red'
		$UsernameExample.Font = New-Object System.Drawing.Font("Cambria",10,[System.Drawing.FontStyle]::Bold) 
		$UsernameExample.Size = New-Object System.Drawing.Size(260,20)
		$MessageBox.Controls.Add($UsernameExample)
		$MessageBox.Topmost = $true
		$MessageBoxResult = $MessageBox.ShowDialog()
		if($MessageBoxResult -eq [System.Windows.Forms.DialogResult]::OK){
			if( $UserNameCorrectionTextBox.Text -match [regex]::Escape("DBC\")+"\d\d\d"+[regex]::Escape(".")){
				$AcceptedUsername = $UserNameCorrectionTextBox.Text
				$BadFormatRunCount +1;
			}
			elseif($MessageBoxDialogCount -ne '2'){
				$MessageBox.Text = 'Try Again.'
				$MessageBoxDialogCount +1;
				$MessageBoxResult = $MessageBox.ShowDialog()
			}
			elseif($MessageBoxDialogCount -ige '2'){
				$AcceptedUsername = $Null
				$BadFormatRunCount +1
			}
		}
		if ($MessageBoxResult -eq [System.Windows.Forms.DialogResult]::Cancel){
			$AcceptedUsername = $Null
		}
	}
	else{$Acceptedusername = $DealerBuiltUserNameTextBox.Text}
	## END - Message Box / Notification

	$SelectedServers = @()
	foreach($Server in $Checkboxes){
		if ($Server.checked -eq $true){
			$SelectedServers += $Server.name
		}
	}
	$SelectedServersCount = $SelectedServers.Count
	if($SelectedServersCount -ne '0'){
		foreach($DBServer in $SelectedServers){
			$AcceptedUsername
			$DBServerNumber = $DBServer
			$shortcutName = "$DBServer.rdp"
			$path = $PathTextBox.Text
			## RDP File Template - Can be changed for various connection options ie: multiple monitor, clipboard pass through, etc.
			$template = @"
			allow desktop composition:i:0
			allow font smoothing:i:1
			alternate full address:s:RDB.DBC.DEALERBUILT.COM
			audiocapturemode:i:0
			bandwidthautodetect:i:1
			bitmapcachepersistenable:i:1
			compression:i:1
			connection type:i:7
			desktopheight:i:768
			desktopwidth:i:1024
			devicestoredirect:s:*
			disable cursor setting:i:0
			disable full window drag:i:1
			disable menu anims:i:1
			disableremoteappcapscheck:i:0
			disable themes:i:0
			disable wallpaper:i:0
			displayconnectionbar:i:1
			drivestoredirect:s:*
			enableworkspacereconnect:i:0
			full address:s:RDB.DBC.DEALERBUILT.COM
			gatewaycredentialssource:i:0
			gatewayhostname:s:rdg.connect.dealerbuilt.com
			gatewayprofileusagemethod:i:1
			gatewayusagemethod:i:1
			keyboardhook:i:1
			loadbalanceinfo:s:tsv://MS Terminal Services Plugin.1.$DBServerNumber
			networkautodetect:i:1
			prompt for credentials on client:i:1
			promptcredentialonce:i:1
			redirectclipboard:i:1
			redirectcomports:i:0
			redirectdirectx:i:1
			redirectdrives:i:1
			redirectposdevices:i:1
			redirectprinters:i:1
			redirectsmartcards:i:0
			remoteapplicationicon:s:D:\PowerShell\Active\DB.png
			screen mode id:i:2
			server port:i:3389
			session bpp:i:32
			signscope:s:Full Address,Alternate Full Address,Use Redirection Server Name,Server Port,GatewayHostname,GatewayUsageMethod,GatewayProfileUsageMethod,GatewayCredentialsSource,PromptCredentialOnce,RedirectDrives,RedirectPrinters,RedirectCOMPorts,RedirectSmartCards,RedirectClipboard,DevicesToRedirect,DrivesToRedirect,LoadBalanceInfo
			smart sizing:i:0
			usbdevicestoredirect:s:*
			use multimon:i:0
			use redirection server name:i:1
			username:s:$AcceptedUsername
			videoplaybackmode:i:1
			winposstr:s:0,3,0,0,800,600
			workspace id:s:RDB.DBC.DEALERBUILT.COM
"@#is there a way to tab this line without it breaking? - JS
			## Output template to txt-file
			$template | Out-File $path\$shortcutName
		}
	}
}
## END - Create-RDPShortcut

## Main Form Buttons
## OK Button
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(550,475)
$okButton.Size = New-Object System.Drawing.Size(125,25)
$okButton.Text = 'Create Shortcuts'
$okButton.Enabled = $False
$okButtonCursor = [System.Windows.Forms.Cursors]::Hand
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$okButton.add_click({Create-RDPShortcut})	
$Form.AcceptButton = $okButton
$Form.Controls.Add($okButton)
## END - OK Button			
## Cancel Button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(465,475)
$cancelButton.Size = New-Object System.Drawing.Size(75,25)
$cancelButton.Text = 'Cancel'
$cancelButtonCursor = [System.Windows.Forms.Cursors]::Hand
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$Form.CancelButton = $cancelButton
$Form.Controls.Add($cancelButton)
## END - Cancel Button
## OK Button
$FileBrowserButton = New-Object System.Windows.Forms.Button
$FileBrowserButton.Location = New-Object System.Drawing.Point(275,96)
$FileBrowserButtonimage = [System.Drawing.Image]::FromFile("C:\Temp\Folder_Icon.png")
$FileBrowserButton.Image = $FileBrowserButtonimage
$FileBrowserButton.Size = New-Object System.Drawing.Size(35,30)
$FileBrowserButton.add_click({Get-Folder})
$Form.Controls.Add($FileBrowserButton)
## END - OK Button				
## END - Buttons
## Show Form
$Form.Add_Shown({$Form.Activate()})
$result = $Form.ShowDialog()
## END 
if( ($Checkboxes.Checked -eq $True).Count -ge 1){
	$okButton.Enabled = $True
}
else{
	$okButton.Enabled = $False
}