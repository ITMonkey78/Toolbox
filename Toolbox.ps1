<#
.Synopsis
Generates a visual list of useful scripts and programs making them available in one place

.DESCRIPTION
This script generates a customisable list of tools and programs for ease of access and usability.
Original idea, code and design by IntrntPirate (https://github.com/intrntpirate/Toolbox)

This version removes the unnecessary Powershell Studio code, and combines the seperate files of IntrntPirate's project into one PS file.
This drastically reduced the size of the base code from 30,000 lines of code to less than 6,000


.NOTES   
Name       : Toolbox
Version    : 1.1
DateCreated: 2017-05-30
DateUpdated: 2017-05-31


#>

#region Source: Startup.pss

#region Source: Globals.ps1

#----------------------------------------------
# region Declare Globals
#----------------------------------------------
#defining some app variables
$Global:AppShortName = "Toolbox"
$Global:AppLongName = "Powershell App Toolbox"
$Global:CurrentRunningVersion=1.1
$Global:Config_AlwaysOnTop=$false
$Global:Config_DebugMode=$false
$Global:Config_ShowNewStuff=$true
$Global:Config_SnapViewMode=$false
$Global:Config_ShowToolTip=$false
$Global:Config_UseLastKnownSizeLocation=$false
$Global:Config_EnableLogging=1
$Global:Config_NetSourceDir="C:\Toolbox\"
$Global:Config_RootLogLocation="C:\Toolbox\Logs\"
$Global:Config_RootHKCU="HKCU:\SOFTWARE\Toolbox\"
	
#endregion Declare Globals

#----------------------------------------------
#region Import Assemblies
#----------------------------------------------
[void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][reflection.assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][reflection.assembly]::Load('System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][reflection.assembly]::Load('System.DirectoryServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][reflection.assembly]::Load('System.ServiceProcess, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[System.Windows.Forms.Application]::EnableVisualStyles()

#endregion Import Assemblies

#endregion Source: Startup.pss

#region Source: MainForm.psf
function Show-MainForm
{
	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	$MainForm = New-Object 'System.Windows.Forms.Form'
	$listview1 = New-Object 'System.Windows.Forms.ListView'
	$menustrip1 = New-Object 'System.Windows.Forms.MenuStrip'
	$fileToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$configToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$helpToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$importToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$exportToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$exitToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$showConfigToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$reloadConfigToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$logToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$showToolTipsToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$tooltip = New-Object 'System.Windows.Forms.ToolTip'
	$debugModeToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$setDebugModeToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$contextmenu1 = New-Object 'System.Windows.Forms.ContextMenuStrip'
	$openToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$uninstallToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$createShortcutToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$timerBringtoFront = New-Object 'System.Windows.Forms.Timer'
	$timerShowNewStuff = New-Object 'System.Windows.Forms.Timer'
	$removeCustomToolToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$addCustomToolToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$setSnapViewToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$alwaysOnTopToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$rememberSizeLocationToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$timerAppLaunched = New-Object 'System.Windows.Forms.Timer'
	$editCustomToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$newCustomToolToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects


	#establishing some app functions
	function Log
	{
		param (
			[string]$text,
			[string]$component = "N/A",
			[int]$type,
			$date = (Get-Date)
		)
		switch ($type)
		{
			1 { $typeS = "Info" }
			2 { $typeS = "Warning" }
			3 { $typeS = "Error" }
			4 { $typeS = "Verbose" }
			default { $typeS = "N/A" }
		}
		If (!($Config_EnableLogging))
		{
			$Config_EnableLogging = "1"
		}
		If ($Config_EnableLogging -eq "1")
		{
			$count = 0
			Do
			{
				Try
				{
					$ErrorActionPreference = 'Stop'
					$toLog = "<![LOG[$($typeS + " : " + $text)]LOG]!><time=`"$(Get-Date $date -Format "HH:mm:ss.ffffff")`" date=`"$(Get-Date $date -Format "MM-dd-yyyy")`" component=`"$AppShortName : $Component`" context=`"`" type=`"$type`" thread=`"$PID`" file=`"$($env:COMPUTERNAME)`">"
					Out-File -InputObject $toLog -Append -NoClobber -Encoding Default -FilePath $Config_LogPath
					$Continue = $true
				}
				Catch
				{
					Start-Sleep -Seconds 1
				}
				Finally
				{
					$count++
				}
				
			}
			Until (($Continue -eq $true) -or ($count -eq 5))
			$Global:Log += $text
		}
	}
	function Debug-Log
	{
		param (
			[string]$text,
			[string]$component = "N/A",
			[int]$type,
			$date = (Get-Date)
		)
		switch ($type)
		{
			1 { $typeS = "Info" }
			2 { $typeS = "Warning" }
			3 { $typeS = "Error" }
			4 { $typeS = "Verbose" }
			default { $typeS = "N/A" }
		}
		If (!(Get-Variable -Name Config_DebugMode))
		{
			$Config_DebugMode = $true
		}
		If (!($Config_EnableLogging))
		{
			$Config_EnableLogging = "1"
		}
		If ($Config_DebugMode -eq $true)
		{
			If ($Config_EnableLogging -eq "1")
			{
				Do
				{
					Try
					{
						$ErrorActionPreference = 'Stop'
						$toLog = "<![LOG[$($typeS + " : " + $text)]LOG]!><time=`"$(Get-Date $date -Format "HH:mm:ss.ffffff")`" date=`"$(Get-Date $date -Format "MM-dd-yyyy")`" component=`"$AppShortName : $Component`" context=`"`" type=`"$type`" thread=`"$PID`" file=`"$($env:COMPUTERNAME)`">"
						Out-File -InputObject $toLog -Append -NoClobber -Encoding Default -FilePath $Config_LogPath
						$Continue = $true
					}
					Catch
					{
						Start-Sleep -Seconds 1
					}
					Finally
					{
						$count++
					}
				}
				Until (($Continue -eq $true) -or ($count -eq 5))
				$Global:Log += $text
			}
		}
	}
	function BringTo-Focus
	{
		param ([int]$processID)
		add-type -AssemblyName microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate($processID)
	}
	function RunAsAdmin-Check
	{
		(New-Object System.Security.Principal.WindowsPrincipal(([System.Security.Principal.WindowsIdentity]::GetCurrent()))).IsInRole(([System.Security.Principal.WindowsBuiltInRole]::Administrator))
	}
	function Build-Config
	{
		param ($Config2Load)
		Log -text "Building config: $Config2Load" -component "MainForm.psf_Load-Config" -type 1
		If (!(Test-Path "$Config_RootHKCU"))
		{
			$Error.Clear()
			New-Item "$Config_RootHKCU"
			If ($Error) { Debug-Log -text "$Error" -component "MainForm.psf_Build-Config" -type 4 }
		}
		If (!(Test-Path "$Config_RootHKCU$Config2Load\"))
		{
			$Error.Clear()
			New-Item "$Config_RootHKCU$Config2Load\"
			If ($Error) { Debug-Log -text "$Error" -component "MainForm.psf_Build-Config" -type 4 }
		}
		If (!($LoadedConfigTable))
		{
			$Global:LoadedConfigTable = New-Object System.Data.DataTable
			$Global:LoadedConfigTable.Columns.Add((New-Object System.Data.DataColumn "Config", ([string])))
			$Global:LoadedConfigTable.Columns.Add((New-Object System.Data.DataColumn "Attribute", ([string])))
			$Global:LoadedConfigTable.Columns.Add((New-Object System.Data.DataColumn "Value", ([string])))
			$Global:LoadedConfigTable.Columns.Add((New-Object System.Data.DataColumn "User Customized", ([string])))
		}
		Get-Variable -Scope Global -Name "Config_*" | ForEach-Object {
			$Obj = $_.Name.Replace("Config_","")
			If (($LoadedConfigTable | Where-Object { $_."Attribute" -eq $obj }))
			{
				$eci = $true
			}
			Else
			{
				$eci = $false
			}
			
			If (((Get-ItemProperty "$Config_RootHKCU$Config2Load\")."$Obj"))
			{
				Log -text "Config item `"$Obj`" is user personalized." -component "MainForm.psf_Build-Config" -type 1
				$Val = (Get-ItemProperty "$Config_RootHKCU$Config2Load\")."$Obj"
				$ciuc = $true
			}
			Else
			{
				$Val = $_.Value
				$ciuc = $false
			}
			If ($Val -eq "true") { $Val = $true }
			elseif ($Val -eq "false") { $Val = $false }
			
			If (!(Get-Variable -Scope Global -Name "Config_$Obj"))
			{
				New-Variable -Scope Global -Name "Config_$Obj" -Value $Val
			}
			Else
			{
				Set-Variable -Scope Global -Name "Config_$Obj" -Value $Val
			}
			If ($eci -eq $true)
			{
				($Global:LoadedConfigTable | Where-Object { $_.Attribute -eq $obj }).'Config' = $Config2Load
				($Global:LoadedConfigTable | Where-Object { $_.Attribute -eq $obj }).'Value' = $Val
				If ($ciuc -eq $true)
				{
					($Global:LoadedConfigTable | Where-Object { $_.Attribute -eq $obj }).'User Customized' = "True"
				}
				elseif ($ciuc -eq $false)
				{
					($Global:LoadedConfigTable | Where-Object { $_.Attribute -eq $obj }).'User Customized' = "False"
				}
			}
			elseif ($eci -eq $false)
			{
				$row = $Global:LoadedConfigTable.NewRow()
				$row."Config" = $Config2Load
				$row."Attribute" = $obj
				$row."Value" = $Val
				If ($ciuc -eq $true)
				{
					$row."User Customized" = "True"
				}
				elseif ($ciuc -eq $false)
				{
					$row."User Customized" = "False"
				}
				$Global:LoadedConfigTable.Rows.Add($row)
			}
		}
	}
	function Update-LoadedConfigTable
	{
		Debug-Log -text "Updating Loaded Config Table..." -component "MainForm.psf_Update-LoadedConfigTable" -type 4
		foreach ($row in ($LoadedConfigTable))
		{
			Debug-Log -text "Processing setting for config $($row.Config), setting $($row.Attribute)..." -component "MainForm.psf_Update-LoadedConfigTable" -type 4
			If (!($row.Value -eq "$((Get-Variable -Scope Global -Name "Config_$($row.Attribute)").Value)"))
			{
				Debug-Log -text "Updating entry..." -component "MainForm.psf_Update-LoadedConfigTable" -type 4
				($LoadedConfigTable.Rows | Where-Object { $_.Config -eq "$($row.Config)" -and $_.Attribute -eq "$($row.Attribute)" }).value = "$((Get-Variable -Scope Global -Name "Config_$($row.Attribute)").Value)"
			}
		}
		Debug-Log -text "Finished updating Loaded Config Table." -component "MainForm.psf_Update-LoadedConfigTable" -type 4
	}
	Function Get-FileName($initialDirectory)
	{
		[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
		$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
		$OpenFileDialog.DereferenceLinks = $false
		$OpenFileDialog.initialDirectory = $initialDirectory
		$OpenFileDialog.filter = "CSV files (*.csv)| *.csv|All files (*.*)| *.*"
		$OpenFileDialog.ShowDialog() | Out-Null
		$OpenFileDialog.filename
	}
	function MainForm-Startup
	{
		param (
			[bool]$RunAdminCheck,
			[bool]$silent = $false,
			[bool]$OverRideArch = $false
		)
		$script:currentuser = $env:username
		$Global:Config_LogPath = "$Config_RootLogLocation" + "$currentuser.log"
		If (!(Test-Path $Config_RootLogLocation))
		{
			Log -text "Creating the root log location..." -component "MainForm.psf_MainForm-Startup" -type 1
			$Error.Clear()
			New-Item -Path $Config_RootLogLocation -ItemType directory -Force
			If ($Error)
			{
				Log -text "An error occured while attempting to create the root log location." -component "MainForm.psf_MainForm-Startup" -type 3
				Log -text "$Error" -component "MainForm.psf_MainForm-Startup" -type 3
				Log -text "" -component "MainForm.psf_MainForm-Startup" -type 3
			}
		}
		$Global:Log = @()
		Log -text "$AppLongName starting..." -component "MainForm.psf_MainForm-Startup" -type 1
		Log -text "User: $currentuser" -component "MainForm.psf_MainForm-Startup" -type 1
		$Global:CurrentExecutable = (Get-WmiObject Win32_Process | Where-Object { $_.handle -eq $pid }).ExecutablePath
		Log -text "Executable Path: $CurrentExecutable" -component "MainForm.psf_MainForm-Startup" -type 1
		$Global:CurrentRunningPath = (Get-Item $CurrentExecutable).directory.fullname
		Log -text "Running Path: $CurrentRunningPath" -component "MainForm.psf_MainForm-Startup" -type 1
		$Global:CurrentPSVersion = (Get-Item $CurrentExecutable).VersionInfo.ProductVersion
		Log -text "Running Version: $CurrentPSVersion" -component "MainForm.psf_MainForm-Startup" -type 1
		$Global:RootDirectory = (Get-Item $CurrentExecutable).Directory.Parent.FullName
		Log -text "Root Directory: $RootDirectory" -component "MainForm.psf_MainForm-Startup" -type 1
		Log -text "" -component "MainForm.psf_MainForm-Startup" -type 1
		Log -text "RunAdminCheck: $RunAdminCheck" -component "MainForm.psf_MainForm-Startup" -type 1
		Log -text "Silent: $silent" -component "MainForm.psf_MainForm-Startup" -type 1
		Log -text "OverRideArch: $OverRideArch" -component "MainForm.psf_MainForm-Startup" -type 1
		Log -text "UpdateCheckVer: $CurrentRunningVersion" -component "MainForm.psf_MainForm-Startup" -type 1
		Check-ForUpdate
		Check-LastRanVersion
		Build-Config -Config2Load "$AppShortName"
	
		If ($RunAdminCheck -eq $true)
		{
			Log -text "This app requires admin rights to run. Performing admin rights detection..." -component "MainForm.psf_MainForm-Startup" -type 1
			If (RunAsAdmin-Check -eq $true)
			{
				Log -text "Admin rights detected." -component "MainForm.psf_MainForm-Startup" -type 1
				return, $true
			}
			else
			{
				Log -text "Tool is not running as an admin." -component "MainForm.psf_MainForm-Startup" -type 3
				If (!($silent -eq $true))
				{
					Message-Box -text "You're not running $AppLongName as an Administrator. You need to re-launch it as an Administrator." -title "Whoa there..."
				}
				return, $false
			}
		}
		Else
		{
			return, $true
		}
	}
	function Get-LockedConfigItems
	{
		return, @('EnableLogging', 'CoreFunctions', 'AboutInfoImg', 'ProdVersion', 'OptionalVersion', 'UniUpdateProdVersion', 'UniUpdateNetRoot', 'RootHKCU', 'NetSourceDir')
	}
	function Message-Box
	{
		param (
			$text,
			$title,
			$boxtype = "0"
		)
		BringTo-Focus -processID $pid
		[System.Windows.Forms.MessageBox]::Show("$text", "$title", $boxtype)
	}
	function Check-ForUpdate
	{
		$match = Select-String "$Config_NetSourceDir$AppShortName\Toolbox.ps1" -pattern '$Global:CurrentRunningVersion=' -SimpleMatch
		$CurrentSourceVersion = $Match.line.Split("=")[1]

		If ($CurrentSourceVersion -gt $CurrentRunningVersion)
        	{
            		Message-Box -title "Version Check" -text "New version available. Updating script"
            		Copy-Item  "$Config_NetSourceDir$AppShortName\Toolbox.ps1" -Destination $PSScriptRoot -force
			#reload the script and exit the currently running version
			Invoke-Expression -Command $PSCommandPath
			[Environment]::Exit(1)
        	}
	}
	function Check-LastRanVersion
	{
		If (((Get-ItemProperty "$Config_RootHKCU$AppShortName\").LastRanVer))
		{
			$Global:LRV = ((Get-ItemProperty "$Config_RootHKCU$AppShortName\").LastRanVer)
			If ($CurrentRunningVersion -gt $LRV)
			{
				$Global:ShowVersionUpdates = $true
			}
			Else
			{
				$Global:ShowVersionUpdates = $false
			}
			$Error.Clear()
			Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name LastRanVer -Value "$CurrentRunningVersion"
			If ($Error)
			{
				Log -text "An error occured while attempting to update the LastRanVer attribute for the tool in the registry." -component "MainForm.psf_Check-LastRanVersion" -type 3
				Log -text "$Error" -component "MainForm.psf_Check-LastRanVersion" -type 3
				Log -text "" -component "MainForm.psf_Check-LastRanVersion" -type 3
				Message-Box -title "ERROR" -text "An error occured. See log for details."
			}
			Else
			{
				Debug-Log -text "Successfully updated the LastRanVer attribute." -component "MainForm.psf_Check-LastRanVersion" -type 4
			}
		}
		Else
		{
			$Error.Clear()
			New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name LastRanVer -PropertyType String -Value "$CurrentRunningVersion"
			If ($Error)
			{
				Log -text "An error occured while attempting to create the LastRanVer attribute for the tool in the registry." -component "MainForm.psf_Check-LastRanVersion" -type 3
				Log -text "$Error" -component "MainForm.psf_Check-LastRanVersion" -type 3
				Log -text "" -component "MainForm.psf_Check-LastRanVersion" -type 3
				Message-Box -title "ERROR" -text "An error occured. See log for details."
			}
			Else
			{
				Debug-Log -text "Successfully created the LastRanVer attribute" -component "MainForm.psf_Check-LastRanVersion" -type 4
			}
		}
	}
	function Toggle-DebugMode
	{
		If ($Config_DebugMode -eq $true)
		{
			If (((Get-ItemProperty "$Config_RootHKCU$AppShortName\").DebugMode))
			{
				$Error.Clear()
				Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name DebugMode -Value "False"
				If ($Error)
				{
					Log -text "An error occured while trying to disable Debug Mode." -component "MainForm.psf_Toggle-DebugMode" -type 3
					Log -text "$Error" -component "MainForm.psf_Toggle-DebugMode" -type 3
					Log -text "" -component "MainForm.psf_Toggle-DebugMode" -type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to disable Debug Mode.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					return, $false
				}
				Else
				{
					Show-MessageBox_psf -title "" -text "Debug Mode Disabled" -autoclose 5 -boxtype 1 -image 2 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					$Global:Config_DebugMode = $false
					return, $true
				}
			}
			Else
			{
				$Error.Clear()
				New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name DebugMode -PropertyType String -Value "False"
				If ($Error)
				{
					Log -text "An error occured while trying to disable Debug Mode." -component "MainForm.psf_Toggle-DebugMode" -type 3
					Log -text "$Error" -component "MainForm.psf_Toggle-DebugMode" -type 3
					Log -text "" -component "MainForm.psf_Toggle-DebugMode" -type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to disable Debug Mode.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					return, $false
				}
				Else
				{
					Show-MessageBox_psf -title "" -text "Debug Mode Disabled" -autoclose 5 -boxtype 1 -image 2 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					$Global:Config_DebugMode = $false
					return, $true
				}
			}
		}
		elseif ($Config_DebugMode -eq $false)
		{
			If (((Get-ItemProperty "$Config_RootHKCU$AppShortName\").DebugMode))
			{
				$Error.Clear()
				Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name DebugMode -Value "True"
				If ($Error)
				{
					Log -text "An error occured while trying to enable Debug Mode." -component "MainForm.psf_Toggle-DebugMode" -type 3
					Log -text "$Error" -component "MainForm.psf_Toggle-DebugMode" -type 3
					Log -text "" -component "MainForm.psf_Toggle-DebugMode" -type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to enable Debug Mode.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					return, $false
				}
				Else
				{
					Show-MessageBox_psf -title "" -text "Debug Mode Enabled" -autoclose 5 -boxtype 1 -image 2 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					$Global:Config_DebugMode = $true
					return, $true
				}
			}
			Else
			{
				$Error.Clear()
				New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name DebugMode -PropertyType String -Value "True"
				If ($Error)
				{
					Log -text "An error occured while trying to enable Debug Mode." -component "MainForm.psf_Toggle-DebugMode" -type 3
					Log -text "$Error" -component "MainForm.psf_Toggle-DebugMode" -type 3
					Log -text "" -component "MainForm.psf_Toggle-DebugMode" -type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to enable Debug Mode.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					return, $false
				}
				Else
				{
					Show-MessageBox_psf -title "" -text "Debug Mode Enabled" -autoclose 5 -boxtype 1 -image 2 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					$Global:Config_DebugMode = $true
					return, $true
				}
			}
		}
	}
	function Toggle-ToolTips
	{
		If ($Config_ShowToolTip -eq $false)
		{
			#enable, set reg key to 0
			If (((Get-ItemProperty "$Config_RootHKCU$AppShortName\").ShowToolTip))
			{
				$Error.Clear()
				Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name ShowToolTip -Value "True"
				If ($Error)
				{
					Log -text "An error occured while trying to enable Tool Tips." -component "MainForm.psf_Toggle-ToolTips" -type 3
					Log -text "$Error" -component "MainForm.psf_Toggle-ToolTips" -type 3
					Log -text "" -component "MainForm.psf_Toggle-ToolTips" -type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to enable Tool Tips.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					return, $false
				}
				Else
				{
					Show-MessageBox_psf -title "" -text "Tool Tips Enabled" -autoclose 5 -boxtype 1 -image 2 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					$Global:Config_ShowTooltip = $true
					return, $true
				}
			}
			Else
			{
				$Error.Clear()
				New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name ShowToolTip -PropertyType String -Value "True"
				If ($Error)
				{
					Log -text "An error occured while trying to enable Tool Tips." -component "MainForm.psf_Toggle-ToolTips" -type 3
					Log -text "$Error" -component "MainForm.psf_Toggle-ToolTips" -type 3
					Log -text "" -component "MainForm.psf_Toggle-ToolTips" -type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to enable Tool Tips.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					return, $false
				}
				Else
				{
					Show-MessageBox_psf -title "" -text "Tool Tips Enabled" -autoclose 5 -boxtype 1 -image 2 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					$Global:Config_ShowTooltip = $true
					return, $true
				}
			}
		}
		elseif ($Config_ShowTooltip -eq $true)
		{
			#disable, set reg key to 1	
			If (((Get-ItemProperty "$Config_RootHKCU$AppShortName\").ShowToolTip))
			{
				$Error.Clear()
				Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name ShowToolTip -Value "False"
				If ($Error)
				{
					Log -text "An error occured while trying to disable Tool Tips." -component "MainForm.psf_Toggle-ToolTips" -type 3
					Log -text "$Error" -component "MainForm.psf_Toggle-ToolTips" -type 3
					Log -text "" -component "MainForm.psf_Toggle-ToolTips" -type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to disable Tool Tips.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					return, $false
				}
				Else
				{
					Show-MessageBox_psf -title "" -text "Tool Tips Disabled" -autoclose 5 -boxtype 1 -image 2 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					$Global:Config_ShowTooltip = $false
					return, $true
				}
			}
			Else
			{
				$Error.Clear()
				New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name ShowToolTip -PropertyType String -Value "False"
				If ($Error)
				{
					Log -text "An error occured while trying to disable Tool Tips." -component "MainForm.psf_Toggle-ToolTips" -type 3
					Log -text "$Error" -component "MainForm.psf_Toggle-ToolTips" -type 3
					Log -text "" -component "MainForm.psf_Toggle-ToolTips" -type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to disable Tool Tips.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					return, $false
				}
				Else
				{
					Show-MessageBox_psf -title "" -text "Tool Tips Disabled" -autoclose 5 -boxtype 1 -image 2 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					$Global:Config_ShowTooltip = $false
					return, $true
				}
			}
		}
	}
	function Check-ScreenLocation
	{
		param (
			[int]$x,
			[int]$y,
			[int]$formHeight,
			[int]$formWidth
		)
		Debug-Log -text "Checking Screen Location..." -component "MainForm.psf_Check-ScreenLocation" -type 4
		If ($x -lt 0)
		{
			Debug-Log -text "The location point for X is less than 0. Setting X to 0..." -component "MainForm.psf_Check-ScreenLocation" -type 4
			$x = 0
		}
		If ($y -lt 0)
		{
			Debug-Log -text "The location point for Y is less than 0. Setting Y to 0..." -component "MainForm.psf_Check-ScreenLocation" -type 4
			$y = 0
		}
		Debug-Log -text "Gathering screen statistics..." -component "MainForm.psf_Check-ScreenLocation" -type 4
		$AllScreens = [System.Windows.Forms.Screen]::AllScreens
		Debug-Log -text "Processing screens..." -component "MainForm.psf_Check-ScreenLocation" -type 4
		foreach ($Screen in $AllScreens)
		{
			Debug-Log -text "Processing screen: $($Screen.DeviceName)" -component "MainForm.psf_Check-ScreenLocation" -type 4
			$WL = $Screen.WorkingArea.X #Width Low Range
			$WH = $Screen.WorkingArea.X + $Screen.WorkingArea.Width #Width High Range
			$HL = $Screen.WorkingArea.Y #Heigh Low Range
			$HH = $Screen.WorkingArea.Y + $Screen.WorkingArea.Height #Heigh High Range
			If ((($x -ge $WL) -and ($x -le $WH)) -and (($y -ge $HL) -and ($y -le $HH)))
			{
				Debug-Log -text "The current location is primarily on $($Screen.DeviceName)." -component "MainForm.psf_Check-ScreenLocation" -type 4
				$WorkingScreen = $Screen
			}
			Else
			{
				Debug-Log -text "It does not appear that the location is on this screen." -component "MainForm.psf_Check-ScreenLocation" -type 4
			}
		}
		If (!($WorkingScreen))
		{
			Log -text "The location could not be found on a screen! Returning likely bad location points anyways..." -component "MainForm.psf_Check-ScreenLocation" -type 1
			$obj = New-Object PSObject
			Add-Member -InputObject $obj -MemberType NoteProperty -Name X -Value $x
			Add-Member -InputObject $obj -MemberType NoteProperty -Name Y -Value $y
			return, $obj
		}
		Else
		{
			Debug-Log -text "Checking to make sure that the form isn't getting cut off..." -component "MainForm.psf_Check-ScreenLocation" -type 4
			$xx = $x + $formWidth
			$ScreenMaxX = $WorkingScreen.WorkingArea.X + $WorkingScreen.WorkingArea.Width
			If ($xx -le $ScreenMaxX)
			{
				Debug-Log -text "The X axis appears to not be getting cut off." -component "MainForm.psf_Check-ScreenLocation" -type 4
			}
			Else
			{
				Debug-Log -text "The X axis appears to be getting cut off. Attempting to adjust..." -component "MainForm.psf_Check-ScreenLocation" -type 4
				$x = $x - ($xx - $ScreenMaxX)
			}
			$yy = $y + $formHeight
			$ScreenMaxY = $WorkingScreen.WorkingArea.Y + $WorkingScreen.WorkingArea.Height
			If ($yy -le $ScreenMaxY)
			{
				Debug-Log -text "The Y axis appears to not be getting cut off." -component "MainForm.psf_Check-ScreenLocation" -type 4
			}
			Else
			{
				Debug-Log -text "The Y axis appears to be getting cut off. Attempting to adjust..." -component "MainForm.psf_Check-ScreenLocation" -type 4
				$y = $y - ($yy - $ScreenMaxY)
			}
			$obj = New-Object PSObject
			Add-Member -InputObject $obj -MemberType NoteProperty -Name X -Value $x
			Add-Member -InputObject $obj -MemberType NoteProperty -Name Y -Value $y
			return, $obj
		}
	}
	function Initial-Load
	{
		Debug-Log -text "Running Initial-Load..." -Component "MainForm.psf_Initial-Load" -Type 4
		If ($Config_DebugMode -eq $true)
		{
			$setDebugModeToolStripMenuItem.Text = "Disable"
		}
		Else
		{
			$setDebugModeToolStripMenuItem.Text = "Enable"
		}
		If ($Config_ShowToolTip -eq $true)
		{
			$showToolTipsToolStripMenuItem.Text = "Hide Tool Tips"
			$listview1.ShowItemToolTips = $true
		}
		Else
		{
			$showToolTipsToolStripMenuItem.Text = "Show Tool Tips"
			$listview1.ShowItemToolTips = $false
		}
		Load-Apps
		Populate-ListView
		Set-SnapViewMode
		Toggle-AlwaysOnTop
		Toggle-RememberSizeLocation
		If ($Config_UseLastKnownSizeLocation -eq $true)
		{
			If (((Get-ItemProperty -Path "$Config_RootHKCU$AppShortName\").LastKnownLocation) -and ($Config_UseLastKnownSizeLocation -eq $true))
			{
				Debug-Log -text "Last known location record exists and is set to be used. Using last known location..." -Component "MainForm.psf_Initial-Load" -Type 4
				$Location = (Get-ItemProperty -Path "$Config_RootHKCU$AppShortName\").LastKnownLocation
				$FoundLocation = $true
			}
			If (((Get-ItemProperty -Path "$Config_RootHKCU$AppShortName\").LastKnownSize) -and ($Config_UseLastKnownSizeLocation -eq $true))
			{
				Debug-Log -text "Last known size record exists and is set to be used. Using last known location..." -Component "MainForm.psf_Initial-Load" -Type 4
				$Size = (Get-ItemProperty -Path "$Config_RootHKCU$AppShortName\").LastKnownSize
				$FoundSize = $true
			}
			If (($FoundLocation -eq $true) -and ($FoundSize -eq $true))
			{
				Debug-Log -text "Found both an existing location and size. Checking to ensure the location is valid..." -Component "MainForm.psf_Initial-Load" -Type 4
				If (([System.Windows.Forms.Screen]::AllScreens).WorkingArea.IntersectsWith(([System.Drawing.Rectangle]::new([int]$Location.Split('_')[0], [int]$Location.Split('_')[1], [int]$Size.Split('_')[1], [int]$Size.Split('_')[0]))))
				{
					Debug-Log -text "All screen working area check identified that the saved form location/size is within the boundary of the screens on the system. Restoring last known location and size..." -Component "MainForm.psf_Initial-Load" -Type 4
					$MainForm.Location = (New-Object System.Drawing.Size([int]$Location.Split('_')[0], [int]$Location.Split('_')[1]))
					$MainForm.Size = (New-Object System.Drawing.Size([int]$Size.Split('_')[1], [int]$Size.Split('_')[0]))
				}
				Else
				{
					Log -text "A screen working area check determined that the form is off screen. Not restoring the last known location and size." -Component "MainForm.psf_Initial-Load" -Type 1
				}
			}
			Else
			{
				Debug-Log -text "Failed to locate an existing location or size." -Component "MainForm.psf_Initial-Load" -Type 3
			}
		}

		$Global:Original_Size="$($MainForm.Size.Height)_$($MainForm.Size.Width)"

	}
	function Load-Apps
	{
		Debug-Log -text "Creating EXE Table..." -Component "MainForm.psf_Load-Apps" -Type 4
		$Script:EXETable = New-Object System.Data.DataTable
		$Script:EXETable.Columns.Add((New-Object System.Data.DataColumn "Name", ([string])))
		$Script:EXETable.Columns.Add((New-Object System.Data.DataColumn "LocalPath", ([string])))
		$Script:EXETable.Columns.Add((New-Object System.Data.DataColumn "SourcePath", ([string])))
		$Script:EXETable.Columns.Add((New-Object System.Data.DataColumn "Description", ([string])))
		$Script:EXETable.Columns.Add((New-Object System.Data.DataColumn "AutoInstall", ([bool])))
		$Script:EXETable.Columns.Add((New-Object System.Data.DataColumn "IsInstalled", ([bool])))
		$Script:EXETable.Columns.Add((New-Object System.Data.DataColumn "ImageIndex", ([int])))
		$Script:EXETable.Columns.Add((New-Object System.Data.DataColumn "Local", ([bool])))
		$Script:EXETable.Columns.Add((New-Object System.Data.DataColumn "CustomAdd", ([bool])))
		$Script:EXETable.Columns.Add((New-Object System.Data.DataColumn "CustomAddRegPath", ([string])))
		$Script:EXETable.Columns.Add((New-Object System.Data.DataColumn "CustomAddArgs", ([string])))
		$Script:EXETable.Columns.Add((New-Object System.Data.DataColumn "IconPath", ([string])))
		$Script:EXETable.Columns.Add((New-Object System.Data.DataColumn "AppN", ([string])))
		$Script:EXETable.Columns.Add((New-Object System.Data.DataColumn "ArchSupp", ([string])))
		Debug-Log -text "Creating ImageList..." -Component "MainForm.psf_Load-Apps" -Type 4
		$ImageIndexNum = 0
		$Script:ImageList = New-Object System.Windows.Forms.ImageList
		$System_Drawing_Size = New-Object System.Drawing.Size
		$System_Drawing_Size.Width = 32
		$System_Drawing_Size.Height = 32
		$Script:ImageList.ImageSize = $System_Drawing_Size
		Debug-Log -text "Checking to see if there are any custom tools to add..." -Component "MainForm.psf_Load-Apps" -Type 4
		If ((Test-Path -Path "$Config_RootHKCU$AppShortName\CustomAdd\"))
		{
			Debug-Log -text "Processing custom tools..." -Component "MainForm.psf_Load-Apps" -Type 4
			foreach ($CustomAdd in (Get-ChildItem -Path "$Config_RootHKCU$AppShortName\CustomAdd\"))
			{
				Debug-Log -text "Processing Custom Add tool `"$($CustomAdd.Name)`"" -Component "MainForm.psf_Load-Apps" -Type 4
				$Error.Clear()
				$Properties = Get-ItemProperty -Path $CustomAdd.Name.Replace('HKEY_CURRENT_USER', 'HKCU:')
				If ($Error)
				{
					Log -text "An error occured while attempting to obtain the properties of the custom tool." -Component "MainForm.psf_Load-Apps" -Type 3
					Log -text "$Error" -Component "MainForm.psf_Load-Apps" -Type 3
					Log -text "" -Component "MainForm.psf_Load-Apps" -Type 3
					Show-MessageBox_psf -title "ERROR" -text "An error was encountered while processing the custom tool: $($CustomAdd.Name).`n`nIt will not be added. See log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
				}
				Else
				{
					Debug-Log -text "Successfully obtained the properties. Processing add..." -Component "MainForm.psf_Load-Apps" -Type 4
					$row = $EXETable.NewRow()
					$row."CustomAddRegPath" = $CustomAdd.Name.Replace('HKEY_CURRENT_USER', 'HKCU:')
					$row."Name" = $Properties.Name
					$row."Description" = $Properties.Description
					$row."LocalPath" = $Properties.LocalPath
					$row."AutoInstall" = $false
					$row."IsInstalled" = $true
					$row."CustomAdd" = $true
					If (($Properties.Args))
					{
						$row."CustomAddArgs" = $Properties.Args
					}
					Debug-Log -text "Extracting icon image..." -Component "MainForm.psf_Load-Apps" -Type 4
					$filename = (Get-ItemProperty -Path $($row."LocalPath")).BaseName
					Debug-Log -text "FileName: $filename" -Component "MainForm.psf_Load-Apps" -Type 4
					If (($Properties.IconPath))
					{
						Debug-Log -text "Custom icon path provided." -Component "MainForm.psf_Load-Apps" -Type 4
						$Error.Clear()
						$ImageList.Images.Add("$filename", ([Drawing.Icon]::ExtractAssociatedIcon("$($Properties.IconPath)").ToBitmap()))
						If ($Error)
						{
							Log -text "An error occured while attempting to extract the icon and add it to the ImageList." -Component "MainForm.psf_Load-Apps" -Type 3
							Log -text "$Error" -Component "MainForm.psf_Load-Apps" -Type 3
							Log -text "" -Component "MainForm.psf_Load-Apps" -Type 3
						}
						Else
						{
							$row."ImageIndex" = $ImageIndexNum
							$ImageIndexNum++
						}
						$row."IconPath" = "$($Properties.IconPath)"
					}
					Else
					{
						$Error.Clear()
						$ImageList.Images.Add("$filename", ([Drawing.Icon]::ExtractAssociatedIcon("$($row."LocalPath")").ToBitmap()))
						If ($Error)
						{
							Log -text "An error occured while attempting to extract the icon and add it to the ImageList." -Component "MainForm.psf_Load-Apps" -Type 3
							Log -text "$Error" -Component "MainForm.psf_Load-Apps" -Type 3
							Log -text "" -Component "MainForm.psf_Load-Apps" -Type 3
						}
						Else
						{
							$row."ImageIndex" = $ImageIndexNum
							$ImageIndexNum++
						}
						$row."IconPath" = "$($row."LocalPath")"
					}
					Debug-Log -text "Finished with adding custom tool." -Component "MainForm.psf_Load-Apps" -Type 4
					$script:EXETable.Rows.Add($row)
				}
			}
		}
		Else
		{
			Debug-Log -text "No custom tools found." -Component "MainForm.psf_Load-Apps" -Type 4
		}
	}
	function Populate-ListView
	{
		$listview1.LargeImageList = $ImageList
		Debug-Log -text "Clearing listview..." -Component "MainForm.psf_Populate-ListView" -Type 4
		$listview1.Items.Clear()
		$itemNum = 0
		Debug-Log -text "Populating listview..." -Component "MainForm.psf_Populate-ListView" -Type 4
		foreach ($Tool in ($EXETable | Where-Object { $_.IsInstalled -eq $true }))
		{
			Debug-Log -text "Processing tool: $($Tool.Name)" -Component "MainForm.psf_Populate-ListView" -Type 4
			$listviewItem = New-Object System.Windows.Forms.ListViewItem
			$listviewItem.Name = $Tool.Name
			$listviewItem.Text = $Tool.Name
			$listviewItem.Tag = $Tool.LocalPath
			$listviewItem.ImageIndex = $Tool.ImageIndex
			$listviewItem.ToolTipText = $Tool.Description
			$listview1.Items.Add($listviewItem)
		}
	}
	function Launch-App
	{
		Debug-Log -text "Processing Launch-App..." -Component "MainForm.psf_Launch-App" -Type 4
		If (($EXETable | Where-Object { $_.Name -eq "$($listview1.SelectedItems[0].Name)" }).CustomAddArgs.GetType().Name -eq "DBNull")
		{
			If ((ExecutionSecurityCheck -ExecutedFile "$($listview1.SelectedItems[0].Tag)") -eq $true)
			{
				Debug-Log -text "Launching tool without Args..." -Component "MainForm.psf_Launch-App" -Type 4
				$Error.Clear()
				Start-Process -FilePath "$($listview1.SelectedItems[0].Tag)"
				If ($Error)
				{
					Log -text "An error occured while attempting to launch the process." -Component "MainForm.psf_Launch-App" -Type 3
					Log -text "$Error" -Component "MainForm.psf_Launch-App" -Type 3
					Log -text "" -Component "MainForm.psf_Launch-App" -Type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
				}
			}
			Else
			{
				Log -text "Execution Security Check failed. Not launching tool." -Component "MainForm.psf_Launch-App" -Type 3
				Show-MessageBox_psf -title "ERROR" -text "The selected tool failed the Execution Security Check and will not be launched." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
			}
		}
		Else
		{
			If ((ExecutionSecurityCheck -ExecutedFile "$($($listview1.SelectedItems[0].Tag))" -Arguments "$($(($EXETable | Where-Object { $_.Name -eq "$($listview1.SelectedItems[0].Name)" }).CustomAddArgs))") -eq $true)
			{
				Debug-Log -text "Launching tool with Args..." -Component "MainForm.psf_Launch-App" -Type 4
				$Error.Clear()
				Start-Process -FilePath "$($listview1.SelectedItems[0].Tag)" -ArgumentList "$(($EXETable | Where-Object { $_.Name -eq "$($listview1.SelectedItems[0].Name)" }).CustomAddArgs)"
				If ($Error)
				{
					Log -text "An error occured while attempting to launch the process." -Component "MainForm.psf_Launch-App" -Type 3
					Log -text "$Error" -Component "MainForm.psf_Launch-App" -Type 3
					Log -text "" -Component "MainForm.psf_Launch-App" -Type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
				}
			}
			Else
			{
				Log -text "Execution Security Check failed. Not launching tool." -Component "MainForm.psf_Launch-App" -Type 3
				Show-MessageBox_psf -title "ERROR" -text "The selected tool failed the Execution Security Check and will not be launched." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
			}
		}
	}

	Function Export-Registry {

		push-location HKCU:
		$data=@()

		#go through each pipelined path
		$path = (Get-ChildItem -Path "$Config_RootHKCU" -Recurse)
		Foreach ($item in $path) {
			$regItem=Get-Item -Path $item
			#get property names
			$properties = $regItem.Property
			if (-not ($properties))
			{
				#no item properties were found so create a default entry
				$value=$Null
				$PropertyItem=”(Default)”
				$RegType=”String”

				#create a custom object for each entry and add it the temporary array
				$data+=New-Object -TypeName PSObject -Property @{
					“Path”=$item
					“Name”=$propertyItem
					“Value”=$value
					“Type”=$regType
				}
			}

			else
			{
				#enumerate each property getting its name,value and type
				foreach ($property in $properties) {

					$value=$regItem.GetValue($property,$null,”DoNotExpandEnvironmentNames”)
					#get the registry value type
					$regType=$regItem.GetValueKind($property)
					$PropertyItem=$property

					#create a custom object for each entry and add it the temporary array
					$data+=New-Object -TypeName PSObject -Property @{
						“Path”=$item
						“Name”=$propertyItem
						“Value”=$value
						“Type”=$regType
					}
				} #foreach
			} #else
		} #close Foreach

		#make sure we got something back and export it
		if ($data)
		{
			Log -text "Creating the settings file..." -component "MainForm.psf_Export-Registry" -type 1
			$data | Export-CSV -Path "$env:SystemDrive\Users\$env:Username\Desktop\Toolbox_Settings.csv" -noTypeInformation
			Show-MessageBox_psf -title "EXPORT" -text "Toolbox_Settings.csv file exported to desktop`n`nThis file can be used to import the same settings to another server." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
		}
		pop-location

	} #end Function

	Function Import-Registry{
		push-location HKCU:
		$path = Get-FileName -initialDirectory $env:SystemDrive
		$data = Import-CSV -Path $path

		if($data){
			if (!(Test-Path 'HKCU:\SOFTWARE\Atlas\')){New-Item -Path 'HKCU:\SOFTWARE\' -Name 'Atlas'}
				$data | Foreach {
				#Write the new entries, creating new keys and overwriting any existing.
				if (!(Test-Path $_.Path)){
					New-Item -Path (Split-Path -Parent $_.Path) -Name (Split-Path -Leaf $_.Path)
				}
				New-ItemProperty -Path $_.Path -Name $_.Name -Value $_.Value -PropertyType $_.Type -Force -EA Ignore
			}
		}
		pop-location
		#reload the imported config
		Build-Config -Config2Load $AppShortName
		Initial-Load
	} #end Function

	function Set-SnapViewMode
	{
		param ([bool]$switch)
		If ($switch -eq $true)
		{
			If ($Config_SnapViewMode -eq $true)
			{
				If (((Get-ItemProperty "$Config_RootHKCU$AppShortName\").SnapViewMode))
				{
					$Error.Clear()
					Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name SnapViewMode -Value "False"
					If ($Error)
					{
						Log -text "An error occured while trying to disable SnapViewMode." -Component "MainForm.psf_Set-SnapViewMode" -Type 3
						Log -text "$Error" -Component "MainForm.psf_Set-SnapViewMode" -Type 3
						Log -text "" -Component "MainForm.psf_Set-SnapViewMode" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to disable SnapViewMode.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
					Else
					{
						$Global:Config_SnapViewMode = $false
						$setSnapViewToolStripMenuItem.Text = "Enable SnapView Mode"
					}
				}
				Else
				{
					$Error.Clear()
					New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name SnapViewMode -PropertyType String -Value "False"
					If ($Error)
					{
						Log -text "An error occured while trying to disable SnapViewMode." -Component "MainForm.psf_Set-SnapViewMode" -Type 3
						Log -text "$Error" -Component "MainForm.psf_Set-SnapViewMode" -Type 3
						Log -text "" -Component "MainForm.psf_Set-SnapViewMode" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to disable SnapViewMode.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
					Else
					{
						$Global:Config_SnapViewMode = $false
						$setSnapViewToolStripMenuItem.Text = "Enable SnapView Mode"
					}
				}
			}
			elseif ($Config_SnapViewMode -eq $false)
			{
				If (((Get-ItemProperty "$Config_RootHKCU$AppShortName\").SnapViewMode))
				{
					$Error.Clear()
					Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name SnapViewMode -Value "True"
					If ($Error)
					{
						Log -text "An error occured while trying to enable SnapViewMode." -Component "MainForm.psf_Set-SnapViewMode" -Type 3
						Log -text "$Error" -Component "MainForm.psf_Set-SnapViewMode" -Type 3
						Log -text "" -Component "MainForm.psf_Set-SnapViewMode" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to enable SnapViewMode.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
					Else
					{
						$Global:Config_SnapViewMode = $true
						$setSnapViewToolStripMenuItem.Text = "Disable SnapView Mode"
					}
				}
				Else
				{
					$Error.Clear()
					New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name SnapViewMode -PropertyType String -Value "True"
					If ($Error)
					{
						Log -text "An error occured while trying to enable SnapViewMode." -Component "MainForm.psf_Set-SnapViewMode" -Type 3
						Log -text "$Error" -Component "MainForm.psf_Set-SnapViewMode" -Type 3
						Log -text "" -Component "MainForm.psf_Set-SnapViewMode" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to enable SnapViewMode.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
					Else
					{
						$Global:Config_SnapViewMode = $true
						$setSnapViewToolStripMenuItem.Text = "Disable SnapView Mode"
					}
				}
			}
		}


		If ($Config_SnapViewMode -eq $false)
		{
			$MainForm.MinimumSize = (New-Object System.Drawing.Size(311, 155))
			$MainForm.Size = (New-Object System.Drawing.Size([int]$Original_Size.Split('_')[1], [int]$Original_Size.Split('_')[0]))
			#$listview1.Location = (New-Object System.Drawing.Size (12, 27))
			#$listview1.Size = (New-Object System.Drawing.Size (587, 234))
			$setSnapViewToolStripMenuItem.Text = "Enable SnapView Mode"
		}
		elseif ($Config_SnapViewMode -eq $true)
		{
			$MainForm.MinimumSize = (New-Object System.Drawing.Size(276, 551))
			$MainForm.Size = (New-Object System.Drawing.Size(386, 551))
			$setSnapViewToolStripMenuItem.Text = "Disable SnapView Mode"
		}
	}
	function Toggle-AlwaysOnTop
	{
		param (
			[bool]$switch
		)
		If ($switch -eq $true)
		{
			If ($Config_AlwaysOnTop -eq $true)
			{
				#disable
				If (((Get-ItemProperty "$Config_RootHKCU$AppShortName\").AlwaysOnTop))
				{
					$Error.Clear()
					Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name AlwaysOnTop -Value "False"
					If ($Error)
					{
						Log -text "An error occured while trying to disable AlwaysOnTop." -Component "MainForm.psf_Toggle-AlwaysOnTop" -Type 3
						Log -text "$Error" -Component "MainForm.psf_Toggle-AlwaysOnTop" -Type 3
						Log -text "" -Component "MainForm.psf_Toggle-AlwaysOnTop" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to disable AlwaysOnTop.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
					Else
					{
						$Global:Config_AlwaysOnTop = $false
					}
				}
				Else
				{
					$Error.Clear()
					New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name AlwaysOnTop -PropertyType String -Value "False"
					If ($Error)
					{
						Log -text "An error occured while trying to disable AlwaysOnTop." -Component "MainForm.psf_Toggle-AlwaysOnTop" -Type 3
						Log -text "$Error" -Component "MainForm.psf_Toggle-AlwaysOnTop" -Type 3
						Log -text "" -Component "MainForm.psf_Toggle-AlwaysOnTop" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to disable AlwaysOnTop.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
					Else
					{
						$Global:Config_AlwaysOnTop = $false
					}
				}
			}
			elseif ($Config_AlwaysOnTop -eq $false)
			{
				#enable	
				If (((Get-ItemProperty "$Config_RootHKCU$AppShortName\").AlwaysOnTop))
				{
					$Error.Clear()
					Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name AlwaysOnTop -Value "True"
					If ($Error)
					{
						Log -text "An error occured while trying to enable AlwaysOnTop." -Component "MainForm.psf_Toggle-AlwaysOnTop" -Type 3
						Log -text "$Error" -Component "MainForm.psf_Toggle-AlwaysOnTop" -Type 3
						Log -text "" -Component "MainForm.psf_Toggle-AlwaysOnTop" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to enable AlwaysOnTop.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
					Else
					{
						$Global:Config_AlwaysOnTop = $true
					}
				}
				Else
				{
					$Error.Clear()
					New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name AlwaysOnTop -PropertyType String -Value "True"
					If ($Error)
					{
						Log -text "An error occured while trying to enable AlwaysOnTop." -Component "MainForm.psf_Toggle-AlwaysOnTop" -Type 3
						Log -text "$Error" -Component "MainForm.psf_Toggle-AlwaysOnTop" -Type 3
						Log -text "" -Component "MainForm.psf_Toggle-AlwaysOnTop" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to enable AlwaysOnTop.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
					Else
					{
						$Global:Config_AlwaysOnTop = $true
					}
				}
			}
		}
		If ($Config_AlwaysOnTop -eq $true)
		{
			$alwaysOnTopToolStripMenuItem.Checked = $true
			$MainForm.TopMost = $true
			$listview1.TopMost = $true
		}
		elseif ($Config_AlwaysOnTop -eq $false)
		{
			$alwaysOnTopToolStripMenuItem.Checked = $false
			$MainForm.TopMost = $false
		}
	}
	function Switch-TopMost
	{
		If ($Config_AlwaysOnTop -eq $true)
		{
			If ($MainForm.TopMost -eq $true)
			{
				$MainForm.TopMost = $false
			}
			Else
			{
				$MainForm.TopMost = $true
			}
		}
	}
	function Toggle-RememberSizeLocation
	{
		param ([bool]$switch)
		If ($switch -eq $true)
		{
			If ($Config_UseLastKnownSizeLocation -eq $true)
			{
				#disable
				If (((Get-ItemProperty "$Config_RootHKCU$AppShortName\").UseLastKnownSizeLocation))
				{
					$Error.Clear()
					Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name UseLastKnownSizeLocation -Value "False"
					If ($Error)
					{
						Log -text "An error occured while trying to disable UseLastKnownSizeLocation." -Component "MainForm.psf_Toggle-RememberSizeLocation" -Type 3
						Log -text "$Error" -Component "MainForm.psf_Toggle-RememberSizeLocation" -Type 3
						Log -text "" -Component "MainForm.psf_Toggle-RememberSizeLocation" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to disable UseLastKnownSizeLocation.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
					Else
					{
						$Global:Config_UseLastKnownSizeLocation = $false
					}
				}
				Else
				{
					$Error.Clear()
					New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name UseLastKnownSizeLocation -PropertyType String -Value "False"
					If ($Error)
					{
						Log -text "An error occured while trying to disable UseLastKnownSizeLocation." -Component "MainForm.psf_Toggle-RememberSizeLocation" -Type 3
						Log -text "$Error" -Component "MainForm.psf_Toggle-RememberSizeLocation" -Type 3
						Log -text "" -Component "MainForm.psf_Toggle-RememberSizeLocation" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to disable UseLastKnownSizeLocation.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
					Else
					{
						$Global:Config_UseLastKnownSizeLocation = $false
					}
				}
			}
			elseif ($Config_UseLastKnownSizeLocation -eq $false)
			{
				#enable	
				If (((Get-ItemProperty "$Config_RootHKCU$AppShortName\").UseLastKnownSizeLocation))
				{
					$Error.Clear()
					Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name UseLastKnownSizeLocation -Value "True"
					If ($Error)
					{
						Log -text "An error occured while trying to enable UseLastKnownSizeLocation." -Component "MainForm.psf_Toggle-RememberSizeLocation" -Type 3
						Log -text "$Error" -Component "MainForm.psf_Toggle-RememberSizeLocation" -Type 3
						Log -text "" -Component "MainForm.psf_Toggle-RememberSizeLocation" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to enable UseLastKnownSizeLocation.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
					Else
					{
						$Global:Config_UseLastKnownSizeLocation = $true
					}
				}
				Else
				{
					$Error.Clear()
					New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name UseLastKnownSizeLocation -PropertyType String -Value "True"
					If ($Error)
					{
						Log -text "An error occured while trying to enable UseLastKnownSizeLocation." -Component "MainForm.psf_Toggle-RememberSizeLocation" -Type 3
						Log -text "$Error" -Component "MainForm.psf_Toggle-RememberSizeLocation" -Type 3
						Log -text "" -Component "MainForm.psf_Toggle-RememberSizeLocation" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to enable UseLastKnownSizeLocation.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
					Else
					{
						$Global:Config_UseLastKnownSizeLocation = $true
					}
				}
			}
		}
		If ($Config_UseLastKnownSizeLocation -eq $true)
		{
			$rememberSizeLocationToolStripMenuItem.Checked = $true
		}
		elseif ($Config_UseLastKnownSizeLocation -eq $false)
		{
			$rememberSizeLocationToolStripMenuItem.Checked = $false
		}
	}
	function Get-HashofString
	{
		param ($textToHash)
		$hasher = new-object System.Security.Cryptography.SHA256Managed
		$toHash = [System.Text.Encoding]::UTF8.GetBytes($textToHash)
		$hashByteArray = $hasher.ComputeHash($toHash)
		foreach ($byte in $hashByteArray)
		{
			$res += $byte.ToString()
		}
		return $res;
	}
	function Get-FileHash
	{
		param ($file)
		$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
		$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($file)))
		return, $hash
	}
	function ExecutionSecurityCheck
	{
		param (
			[string]$ExecutedFile,
			[string]$Arguments
		)
		function Check-Exe
		{
			param (
				$e,
				$a
			)
			Debug-Log -text "Checking the executable..." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Exe" -Type 4
			If ((Test-Path -Path "$Config_RootHKCU$AppShortName\Security\$ExecutedFileHash"))
			{
				Debug-Log -text "Exclusion found for file." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Exe" -Type 4
				Check-Args -e $e -a $a
			}
			Else
			{
				Debug-Log -text "No exclusion found for the file. Prompting to see if an exclusion should be created." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Exe" -Type 4
				If ((Show-MessageBox_psf -title "WARNING" -text "The following execution path and/or execution argument has failed a security check.`n`nExecution Path: $e`nExecution Argument: $a`n`nWould you like to whitelist the execution path and/or argument and continue with launching it?" -boxtype 4 -image 3 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))) -eq 'Yes')
				{
					Debug-Log -text "It was selected to continue with the execution and whitelist the execution." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Exe" -Type 4
					WhiteListExecution -e $e -a $a
				}
				Else
				{
					Log -text "It was elected to cancel the execution of this unknown execution path and/or execution argument." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Exe" -Type 1
					$script:PassExec = $false
				}
			}
		}
		function Check-Args
		{
			param (
				$e,
				$a
			)
			Debug-Log -text "Checking the arguments..." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Args" -Type 4
			If ($Arguments.Length -ge 1)
			{
				If ((Test-Path "$Config_RootHKCU$AppShortName\Security\$ExecutedFileHash\"))
				{
					Debug-Log -text "Compiling a list of excluded hashes..." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Args" -Type 4
					$AHashes = @()
					foreach ($Hash in (Get-ItemProperty -Path "$Config_RootHKCU$AppShortName\Security\$ExecutedFileHash\").AHash.ToString().Split(' '))
					{
						$AHashes += $Hash
					}
					If (!($AHashes -contains $ArgumentHash))
					{
						Debug-Log -text "The hash of the command line argument was not found whitelisted. Prompting to see if an exclusion should be created." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Args" -Type 4
						If ((Show-MessageBox_psf -title "WARNING" -text "The following execution path and/or execution argument has failed a security check.`n`nExecution Path: $e`nExecution Argument: $a`n`nWould you like to whitelist the execution path and/or argument and continue with launching it?" -boxtype 4 -image 3 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))) -eq 'Yes')
						{
							Debug-Log -text "It was selected to continue with the execution and whitelist the execution." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Args" -Type 4
							WhiteListExecution -e $e -a $a
						}
						Else
						{
							Log -text "It was elected to cancel the execution of this unknown execution path and/or execution argument." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Args" -Type 1
							$script:PassExec = $false
						}
					}
					Else
					{
						Debug-Log -text "Argument hash exclusion found." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Args" -Type 4
					}
				}
				Else
				{
					Debug-Log -text "No hash exists for the Executed File. Prompting to see if an exclusion should be created." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Args" -Type 4
					If ((Show-MessageBox_psf -title "WARNING" -text "The following execution path and/or execution argument has failed a security check.`n`nExecution Path: $e`nExecution Argument: $a`n`nWould you like to whitelist the execution path and/or argument and continue with launching it?" -boxtype 4 -image 3 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))) -eq 'Yes')
					{
						Debug-Log -text "It was selected to continue with the execution and whitelist the execution." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Args" -Type 4
						WhiteListExecution -e $e -a $a
					}
					Else
					{
						Log -text "It was elected to cancel the execution of this unknown execution path and/or execution argument." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Args" -Type 1
						$script:PassExec = $false
					}
				}
			}
			Else
			{
				Debug-Log -text "No arguments found to evaluate." -Component "MainForm.psf_ExecutionSecurityCheck_Check-Args" -Type 4
			}
		}
		function WhiteListExecution
		{
			param (
				$e,
				$a
			)
			function ExclusionError
			{
				Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to create the exclusion key.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
			}
			Debug-Log -text "Starting the process of whitelisting the current execution..." -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 4
			If (!(Test-Path "$Config_RootHKCU$AppShortName\Security\"))
			{
				Debug-Log -text "Security key doesn't exist. Creating..." -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 4
				$Error.Clear()
				New-Item -Path "$Config_RootHKCU$AppShortName\Security\" -Force
				If ($Error)
				{
					Log -text "An error occured while attempting to create the Security key." -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 3
					Log -text "$Error" -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 3
					Log -text "" -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 3
					ExclusionError
				}
				Else
				{
					Debug-Log -text "Security Key successfully created." -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 4
				}
			}
			If (!(Test-Path "$Config_RootHKCU$AppShortName\Security\$ExecutedFileHash\"))
			{
				Debug-Log -text "Key doesn't exist yet for the hash of the executed item. Creating..." -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 4
				$Error.Clear()
				New-Item -Path "$Config_RootHKCU$AppShortName\Security\$ExecutedFileHash\" -Force
				If ($Error)
				{
					Log -text "An error occured while attempting to create the execution hash key." -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 3
					Log -text "$Error" -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 3
					Log -text "" -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 3
					ExclusionError
				}
				Else
				{
					Debug-Log -text "Execution hash key successfully created." -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 4
				}
			}
			If ($a.Length -ge 1)
			{
				If (((Get-ItemProperty -Path "$Config_RootHKCU$AppShortName\Security\$ExecutedFileHash\").AHash))
				{
					Debug-Log -text "Updating the existing Argument hash array..." -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 4
					$Error.Clear()
					Set-ItemProperty -Path "$Config_RootHKCU$AppShortName\Security\$ExecutedFileHash" -Name "AHash" -Value (Get-ItemProperty -Path $Config_RootHKCU$AppShortName\Security\$ExecutedFileHash\).AHash.ToString(),$ArgumentHash -Force
					If ($Error)
					{
						Log -text "An error occured while attempting to update the existing Argument hash array." -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 3
						Log -text "$Error" -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 3
						Log -text "" -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 3
						ExclusionError
					}
					Else
					{
						Debug-Log -text "Successfully updated the Argument hash array." -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 4
					}
				}
				Else
				{
					Debug-Log -text "Creating the Argument hash array..." -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 4
					$Error.Clear()
					New-ItemProperty -Path "$Config_RootHKCU$AppShortName\Security\$ExecutedFileHash\" -Name "AHash" -Value "$ArgumentHash" -Force
					If ($Error)
					{
						Log -text "An error occured while attempting to create the Argument hash array." -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 3
						Log -text "$Error" -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 3
						Log -text "" -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 3
						ExclusionError
					}
					Else
					{
						Debug-Log -text "Successfully created the argument hash array." -Component "MainForm.psf_ExecutionSecurityCheck_WhiteListExecution" -Type 4
					}
				}
			}
		}
		Debug-Log -text "Starting Execution Security Check." -Component "MainForm.psf_ExecutionSecurityCheck" -Type 4
		Debug-Log -text "ExecutedFile: $ExecutedFile" -Component "MainForm.psf_ExecutionSecurityCheck" -Type 4
		Debug-Log -text "Argument: $Arguments" -Component "MainForm.psf_ExecutionSecurityCheck" -Type 4
		Debug-Log -text "Obtaining hash of file and arguments..." -Component "MainForm.psf_ExecutionSecurityCheck" -Type 4
		$Script:ExecutedFileHash = Get-FileHash -file $ExecutedFile
		$Script:ArgumentHash = Get-HashofString -textToHash $Arguments
		Debug-Log -text "File Hash: $ExecutedFileHash" -Component "MainForm.psf_ExecutionSecurityCheck" -Type 4
		Debug-Log -text "Argument Hash: $ArgumentHash" -Component "MainForm.psf_ExecutionSecurityCheck" -Type 4
		Log -text "Running Execution Security Check..." -Component "MainForm.psf_ExecutionSecurityCheck" -Type 1
		$Script:PassExec = $true
		Debug-Log -text "Obtaining Digital Signature status..." -Component "MainForm.psf_ExecutionSecurityCheck" -Type 4
		$Error.Clear()
		$Signature = Get-AuthenticodeSignature -FilePath $ExecutedFile
		If ($Error)
		{
			Log -text "An error occured while attempting to obtain the digital signature status." -Component "MainForm.psf_ExecutionSecurityCheck" -Type 3
			Log -text "$Error" -Component "MainForm.psf_ExecutionSecurityCheck" -Type 3
			Log -text "" -Component "MainForm.psf_ExecutionSecurityCheck" -Type 3
		}
		If (($Signature.Status -eq "UnknownError") -or ($Signature.Status -eq "NotSigned"))
		{
			Debug-Log -text "It would appear that there is no digital signature." -Component "MainForm.psf_ExecutionSecurityCheck" -Type 4
			Debug-Log -text "Checking ownership to see if it's set to TrustedInstaller..." -Component "MainForm.psf_ExecutionSecurityCheck" -Type 4
			If ((Get-Acl -Path $ExecutedFile).Owner -eq "NT SERVICE\TrustedInstaller")
			{
				Debug-Log -text "Owner is set to TrustedInstaller. Checking for command line arguments..." -Component "MainForm.psf_ExecutionSecurityCheck" -Type 4
				Check-Args -e $ExecutedFile -a $Arguments
			}
			Else
			{
				Debug-Log -text "Owner is not set to TrustedInstaller. Checking to see if file is excluded..." -Component "MainForm.psf_ExecutionSecurityCheck" -Type 4
				Check-Exe -e $ExecutedFile -a $Arguments
			}
		}
		elseif ($Signature.Status -eq "Valid")
		{
			Debug-Log -text "Digital signature is valid. Checking for command line arguments..." -Component "MainForm.psf_ExecutionSecurityCheck" -Type 4
			Check-Args -e $ExecutedFile -a $Arguments
		}
		else
		{
			Log -text "The digital signature that was used to sign the file is no longer valid. Failing execution." -Component "MainForm.psf_ExecutionSecurityCheck" -Type 3
			$Script:PassExec = $false
		}
		return, $PassExec
	}

	$ErrorActionPreference = 'SilentlyContinue'

	$MainForm_Load={
		If ((MainForm-Startup -RunAdminCheck $false) -eq $true)
		{
			$MainForm.Text = "$AppLongName Public v$CurrentRunningVersion"
			Initial-Load
			$timerBringtoFront.Start()
			If (($Config_ShowNewStuff -eq $true) -and ($ShowVersionUpdates -eq $true))
			{
				$timerShowNewStuff.Start()	
			}
		}
		Else
		{
			$MainForm.Close()
		}
	}

	$showConfigToolStripMenuItem_Click={
		Switch-TopMost
		Show-ShowCurrentConfig_psf
		Switch-TopMost
	}
	$reloadConfigToolStripMenuItem_Click={
		Build-Config -Config2Load $AppShortName
		Initial-Load
	}
	$logToolStripMenuItem_Click={
		Switch-TopMost
		Show-Log_psf
		Switch-TopMost
	}
	$showToolTipsToolStripMenuItem_Click={
		If (Toggle-ToolTips -eq $true)
		{
			If ($Config_ShowToolTip -eq $true)
			{
				$showToolTipsToolStripMenuItem.Text = "Hide Tool Tips"
				$listview1.ShowItemToolTips = $true
			}
			Else
			{
				$showToolTipsToolStripMenuItem.Text = "Show Tool Tips"
				$listview1.ShowItemToolTips = $false
			}
		}
	}
	$setDebugModeToolStripMenuItem_Click={
		If (Toggle-DebugMode -eq $true)
		{
			If ($Config_DebugMode -eq $true)
			{
				$setDebugModeToolStripMenuItem.Text = "Disable"
			}
			Else
			{
				$setDebugModeToolStripMenuItem.Text = "Enable"
			}
		}
	}
	$listview1_DoubleClick={
		$MainForm.Cursor = 'AppStarting'
		Launch-App
		$MainForm.Cursor = 'Default'
	}
	$openToolStripMenuItem_Click={
		$MainForm.Cursor = 'AppStarting'
		Launch-App
		$MainForm.Cursor = 'Default'
	}
	$uninstallToolStripMenuItem_Click={
		If ((Message-Box -text "Are you sure you want to uninstall this tool?" -boxtype 4) -eq "YES")
		{
			Debug-Log -text "Uninstall tool: $($listview1.Items[$ListViewHitIndex].Name)" -Component "MainForm.psf_uninstallToolStripMenuItem_Click" -Type 4
			Debug-Log -text "Checking to see if the tool is currently running..." -Component "MainForm.psf_uninstallToolStripMenuItem_Click" -Type 4
			If ((Get-WmiObject Win32_Process | Where-Object { $_.Path -eq "$($listview1.Items[$ListViewHitIndex].Tag)" }).count -ge 1)
			{
				Debug-Log -text "One or more instances of the tool are running. Terminating the processes..." -Component "MainForm.psf_uninstallToolStripMenuItem_Click" -Type 4
				foreach ($process in (Get-WmiObject Win32_Process | Where-Object { $_.Path -eq "$($listview1.Items[$ListViewHitIndex].Tag)" }))
				{
					$Error.Clear()
					Stop-Process -Id $process.Handle
					If ($Error)
					{
						Log -text "Failed to terminate the process: $($process.Handle)" -Component "MainForm.psf_uninstallToolStripMenuItem_Click" -Type 3
					}
				}
			}
			Else
			{
				Debug-Log -text "Tool not found running. Proceeding with uninstall process..." -Component "MainForm.psf_uninstallToolStripMenuItem_Click" -Type 4
			}
			Debug-Log -text "Removing the tools files..." -Component "MainForm.psf_uninstallToolStripMenuItem_Click" -Type 4
			$Error.Clear()
			Remove-Item -Path "$((Get-ItemProperty -Path "$($listview1.Items[$ListViewHitIndex].Tag)").DirectoryName)" -Recurse -Force
			If ($Error)
			{
				Log -text "An error occured while attempting to delete a tools files." -Component "MainForm.psf_uninstallToolStripMenuItem_Click" -Type 3
				Log -text "$Error" -Component "MainForm.psf_uninstallToolStripMenuItem_Click" -Type 3
				Log -text "" -Component "MainForm.psf_uninstallToolStripMenuItem_Click" -Type 3
				Show-MessageBox_psf -title "ERROR" -text "An error occured.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
			}
			Else
			{
				Show-MessageBox_psf -title "" -text "Successfully uninstalled tool." -boxtype 1 -image 2 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
				Initial-Load
			}
		}
	}
	$createShortcutToolStripMenuItem_Click={
		If (!(Test-Path -Path "$env:SystemDrive\Users\$env:Username\Desktop\$($listview1.SelectedItems[0].Name).lnk"))
		{
			$TargetFile = $listview1.Items[$ListViewHitIndex].Tag
			$ShortcutFile = "$env:SystemDrive\Users\$env:Username\Desktop\$($listview1.Items[$ListViewHitIndex].Name).lnk"
			$WScriptShell = New-Object -ComObject WScript.Shell
			$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
			$Shortcut.TargetPath = $TargetFile
			$Shortcut.Save()
		}
	}
	$timerBringtoFront_Tick={
		$timerBringtoFront.Stop()
		BringTo-Focus -processid $pid
	}
	$exitToolStripMenuItem_Click={
		$MainForm.Close()
	}
	$exportToolStripMenuItem_Click={
		Export-Registry
	}
	$importToolStripMenuItem_Click={
		Import-Registry
	}
	$timerShowNewStuff_Tick={
		push-location $Config_NetSourceDir
		$timerShowNewStuff.Stop()
		Debug-Log -text "Running ShowNewStuff timer..." -Component "MainForm.psf_timerShowNewStuff_Tick" -Type 4
		If (Test-Path -Path "$Config_NetSourceDir$AppShortName\UpdateDetails")
		{
			Debug-Log -text "The UpdateDetails folder exists for this tool. Loading..." -Component "MainForm.psf_timerShowNewStuff_Tick" -Type 4
			Switch-TopMost
			Show-NewStuff
			Switch-TopMost
		}
		Else
		{
			Debug-Log -text "The UpdateDetails folder doesn't exist for this tool." -Component "MainForm.psf_timerShowNewStuff_Tick" -Type 4
		}
		pop-location
	}
	$removeCustomToolToolStripMenuItem_Click={
		If ((Show-MessageBox_psf -title "" -text "Are you sure you want to remove this custom tool?" -boxtype 4 -image 4 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))) -eq "YES")
		{
			Debug-Log -text "Removing custom tool: $($listview1.Items[$Script:ListViewHitIndex].Name)" -Component "MainForm.psf_removeCustomToolToolStripMenuItem_Click" -Type 4
			$CustomAppRegPath = $(($EXETable | Where-Object { $_.Name -eq "$($listview1.Items[$Script:ListViewHitIndex].Name)" -and $_.CustomAdd -eq $true }).CustomAddRegPath)
			Debug-Log -text "Path of custom tool that's being removed: $CustomAppRegPath" -Component "MainForm.psf_removeCustomToolToolStripMenuItem_Click" -Type 4
			$Error.Clear()
			Remove-Item -Path "$CustomAppRegPath" -Recurse -Force
			If ($Error)
			{
				Log -text "An error occured while attempting to remove the custom app." -Component "MainForm.psf_removeCustomToolToolStripMenuItem_Click" -Type 3
				Log -text "$Error" -Component "MainForm.psf_removeCustomToolToolStripMenuItem_Click" -Type 3
				Log -text "" -Component "MainForm.psf_removeCustomToolToolStripMenuItem_Click" -Type 3
				Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to remove the custom app.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
			}
			Else
			{
				Show-MessageBox_psf -title "" -text "Successfully removed custom app." -boxtype 1 -image 2 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
				Load-Apps
				Populate-ListView
			}
		}
	}
	$addCustomToolToolStripMenuItem_Click={
		Switch-TopMost
		If (($Global:ReScanApps))
		{
			Clear-Variable -Scope Global -Name ReScanApps
		}
		Show-AddCustomApp_psf
		Switch-TopMost
		If ($ReScanApps -eq $true)
		{
			Load-Apps
			Populate-ListView	
		}
	}
	$MainForm_SizeChanged={

		If ($Config_SnapViewMode -eq $false)
		{
			$Global:Original_Size="$($MainForm.Size.Height)_$($MainForm.Size.Width)"
			$listview1.Size = (New-Object System.Drawing.Size([int](($MainForm.Size.Width - 29) - 12), [int](($MainForm.Size.Height - 50) - 27)))
		}
		elseif ($Config_SnapViewMode -eq $true)
		{
			$listview1.Size = (New-Object System.Drawing.Size([int]($MainForm.Size.Width - 40), [int]($MainForm.Size.Height - 75)))
		}
	}
	$setSnapViewToolStripMenuItem_Click={
		Set-SnapViewMode -switch $true
	}
	$alwaysOnTopToolStripMenuItem_Click={
		Toggle-AlwaysOnTop -switch $true
	}
	$MainForm_FormClosing=[System.Windows.Forms.FormClosingEventHandler]{
		If ($Config_UseLastKnownSizeLocation -eq $true)
		{
			Debug-Log -text "Toolbox is closing and is configured to record its last known size and location..." -Component "MainForm.psf_MainForm_FormClosing" -Type 4
			If ($MainForm.WindowState -eq 'Minimized')
			{
				Debug-Log -text "Window is minimized. Unable to record current location." -Component "MainForm.psf_MainForm_FormClosing" -Type 4
			}
			Else
			{
				Debug-Log -text "Recording Location..." -Component "MainForm.psf_MainForm_FormClosing" -Type 4
				If (((Get-ItemProperty "$Config_RootHKCU$AppShortName\").LastKnownLocation))
				{
					$Error.Clear()
					Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name LastKnownLocation -Value "$($MainForm.Location.X)_$($MainForm.Location.Y)"
					If ($Error)
					{
						Log -text "An error occured while trying to record the last known location." -Component "MainForm.psf_MainForm_FormClosing" -Type 3
						Log -text "$Error" -Component "MainForm.psf_MainForm_FormClosing" -Type 3
						Log -text "" -Component "MainForm.psf_MainForm_FormClosing" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to record the last known location.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
				}
				Else
				{
					$Error.Clear()
					New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name LastKnownLocation -PropertyType String -Value "$($MainForm.Location.X)_$($MainForm.Location.Y)"
					If ($Error)
					{
						Log -text "An error occured while trying to record the last known location." -Component "MainForm.psf_MainForm_FormClosing" -Type 3
						Log -text "$Error" -Component "MainForm.psf_MainForm_FormClosing" -Type 3
						Log -text "" -Component "MainForm.psf_MainForm_FormClosing" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to record the last known location.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
				}
				Debug-Log -text "Recording Size..." -Component "MainForm.psf_MainForm_FormClosing" -Type 4
				If (((Get-ItemProperty "$Config_RootHKCU$AppShortName\").LastKnownSize))
				{
					$Error.Clear()
					Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name LastKnownSize -Value "$($MainForm.Size.Height)_$($MainForm.Size.Width)"
					If ($Error)
					{
						Log -text "An error occured while trying to record the last known size." -Component "MainForm.psf_MainForm_FormClosing" -Type 3
						Log -text "$Error" -Component "MainForm.psf_MainForm_FormClosing" -Type 3
						Log -text "" -Component "MainForm.psf_MainForm_FormClosing" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to record the last known size.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
				}
				Else
				{
					$Error.Clear()
					New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name LastKnownSize -PropertyType String -Value "$($MainForm.Size.Height)_$($MainForm.Size.Width)"
					If ($Error)
					{
						Log -text "An error occured while trying to record the last known size." -Component "MainForm.psf_MainForm_FormClosing" -Type 3
						Log -text "$Error" -Component "MainForm.psf_MainForm_FormClosing" -Type 3
						Log -text "" -Component "MainForm.psf_MainForm_FormClosing" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to record the last known size.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($MainForm.Location.X + ($MainForm.Size.Width / 2)) -y ($MainForm.Location.Y + ($MainForm.Size.Height / 2))
					}
				}	
			}
		}
	}
	$rememberSizeLocationToolStripMenuItem_Click={
		Toggle-RememberSizeLocation -switch $true
	}
	$timerAppLaunched_Tick={
		If ((Get-Process | Where-Object { $_.Path -eq $lp }).MainWindowTitle.Length -ge 1)
		{
			$listview1.Enabled = $true
			$pictureboxLoading.Enabled = $false
			$pictureboxLoading.Visible = $false
			$timerAppLaunched.Stop()
		}
	}
	$contextmenu1_Closed=[System.Windows.Forms.ToolStripDropDownClosedEventHandler]{
		$listview1.ContextMenuStrip = $null
	}
	$listview1_MouseDown=[System.Windows.Forms.MouseEventHandler]{
		$Script:ListViewHitIndex = $listview1.HitTest($_.X, $_.Y).Item.Index
		If (($_.Button -eq 'Right') -and ($ListViewHitIndex -ge 0))
		{
			($contextmenu1.Items | Where-Object { $_.Text -eq "Open" }).Visible = $true

			If (($EXETable | Where-Object { $_.Name -eq $listview1.Items[$ListViewHitIndex].Name }).AutoInstall -eq $true)
			{
				($contextmenu1.Items | Where-Object { $_.Text -eq "Uninstall" }).Visible = $false
				($contextmenu1.Items | Where-Object { $_.Text -eq "Remove Custom Tool" }).Visible = $false
				($contextmenu1.Items | Where-Object { $_.Text -eq "Edit" }).Visible = $false
				($contextmenu1.Items | Where-Object { $_.Text -eq "New Custom Tool" }).Visible = $false
				($contextmenu1.Items | Where-Object { $_.Text -eq "Create Shortcut" }).Visible = $true
			}
			Else
			{
				If (($EXETable | Where-Object { $_.Name -eq $listview1.Items[$ListViewHitIndex].Name }).CustomAdd -eq $false)
				{
					If (($EXETable | Where-Object { $_.Name -eq $listview1.Items[$ListViewHitIndex].Name }).Local -eq $true)
					{
						($contextmenu1.Items | Where-Object { $_.Text -eq "Uninstall" }).Visible = $false
					}
					Else
					{
						($contextmenu1.Items | Where-Object { $_.Text -eq "Uninstall" }).Visible = $true
					}
					($contextmenu1.Items | Where-Object { $_.Text -eq "Create Shortcut" }).Visible = $true
					($contextmenu1.Items | Where-Object { $_.Text -eq "Remove Custom Tool" }).Visible = $false
					($contextmenu1.Items | Where-Object { $_.Text -eq "New Custom Tool" }).Visible = $false
				}
				Else
				{
					($contextmenu1.Items | Where-Object { $_.Text -eq "Uninstall" }).Visible = $false
					($contextmenu1.Items | Where-Object { $_.Text -eq "Create Shortcut" }).Visible = $true
					($contextmenu1.Items | Where-Object { $_.Text -eq "Remove Custom Tool" }).Visible = $true
					($contextmenu1.Items | Where-Object { $_.Text -eq "Edit" }).Visible = $true
					($contextmenu1.Items | Where-Object { $_.Text -eq "New Custom Tool" }).Visible = $false
				}
			}
			$listview1.ContextMenuStrip = $contextmenu1
			$contextmenu1.Show($listview1, $_.Location)
		}
		elseif ($_.Button -eq 'Right')
		{
			($contextmenu1.Items | Where-Object { $_.Text -eq "New Custom Tool" }).Visible = $true
			($contextmenu1.Items | Where-Object { $_.Text -eq "Uninstall" }).Visible = $false
			($contextmenu1.Items | Where-Object { $_.Text -eq "Create Shortcut" }).Visible = $false
			($contextmenu1.Items | Where-Object { $_.Text -eq "Remove Custom Tool" }).Visible = $false
			($contextmenu1.Items | Where-Object { $_.Text -eq "Edit" }).Visible = $false
			($contextmenu1.Items | Where-Object { $_.Text -eq "Open" }).Visible = $false
			$listview1.ContextMenuStrip = $contextmenu1
			$contextmenu1.Show($listview1, $_.Location)
		}
	}
	$editCustomToolStripMenuItem_Click={
		Switch-TopMost
		Show-AddCustomApp_psf -function "Edit" -RegPath "$(($EXETable | Where-Object { $_.Name -eq "$($listview1.Items[$Script:ListViewHitIndex].Name)" -and $_.CustomAdd -eq $true }).CustomAddRegPath)"
		Switch-TopMost
		If ($ReScanApps -eq $true)
		{
			$MainForm.Cursor = 'WaitCursor'
			Load-Apps
			Populate-ListView
			$MainForm.Cursor = 'Default'
		}
	}
	$newCustomToolToolStripMenuItem_Click={
		Switch-TopMost
		If (($Global:ReScanApps))
		{
			Clear-Variable -Scope Global -Name ReScanApps
		}
		Show-AddCustomApp_psf
		Switch-TopMost
		If ($ReScanApps -eq $true)
		{
			Load-Apps
			Populate-ListView
		}
	}	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$MainForm.WindowState = $InitialFormWindowState
	}
	
	$Form_StoreValues_Closing=
	{
		#Store the control values
		$script:MainForm_listview1 = $listview1.SelectedItems
	}

	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$listview1.remove_DoubleClick($listview1_DoubleClick)
			$listview1.remove_MouseDown($listview1_MouseDown)
			$MainForm.remove_FormClosing($MainForm_FormClosing)
			$MainForm.remove_Load($MainForm_Load)
			$MainForm.remove_SizeChanged($MainForm_SizeChanged)
			$exitToolStripMenuItem.remove_Click($exitToolStripMenuItem_Click)
			$exportToolStripMenuItem.remove_Click($exportToolStripMenuItem_Click)
			$importToolStripMenuItem.remove_Click($importToolStripMenuItem_Click)
			$showConfigToolStripMenuItem.remove_Click($showConfigToolStripMenuItem_Click)
			$reloadConfigToolStripMenuItem.remove_Click($reloadConfigToolStripMenuItem_Click)
			$logToolStripMenuItem.remove_Click($logToolStripMenuItem_Click)
			$showToolTipsToolStripMenuItem.remove_Click($showToolTipsToolStripMenuItem_Click)
			$setDebugModeToolStripMenuItem.remove_Click($setDebugModeToolStripMenuItem_Click)
			$contextmenu1.remove_Closed($contextmenu1_Closed)
			$openToolStripMenuItem.remove_Click($openToolStripMenuItem_Click)
			$uninstallToolStripMenuItem.remove_Click($uninstallToolStripMenuItem_Click)
			$createShortcutToolStripMenuItem.remove_Click($createShortcutToolStripMenuItem_Click)
			$timerBringtoFront.remove_Tick($timerBringtoFront_Tick)
			$timerShowNewStuff.remove_Tick($timerShowNewStuff_Tick)
			$removeCustomToolToolStripMenuItem.remove_Click($removeCustomToolToolStripMenuItem_Click)
			$addCustomToolToolStripMenuItem.remove_Click($addCustomToolToolStripMenuItem_Click)
			$setSnapViewToolStripMenuItem.remove_Click($setSnapViewToolStripMenuItem_Click)
			$alwaysOnTopToolStripMenuItem.remove_Click($alwaysOnTopToolStripMenuItem_Click)
			$rememberSizeLocationToolStripMenuItem.remove_Click($rememberSizeLocationToolStripMenuItem_Click)
			$timerAppLaunched.remove_Tick($timerAppLaunched_Tick)
			$editCustomToolStripMenuItem.remove_Click($editCustomToolStripMenuItem_Click)
			$newCustomToolToolStripMenuItem.remove_Click($newCustomToolToolStripMenuItem_Click)
			$MainForm.remove_Load($Form_StateCorrection_Load)
			$MainForm.remove_Closing($Form_StoreValues_Closing)
			$MainForm.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$MainForm.SuspendLayout()
	$menustrip1.SuspendLayout()
	$contextmenu1.SuspendLayout()
	#
	# MainForm
	#
	$MainForm.Controls.Add($listview1)
	$MainForm.Controls.Add($menustrip1)
	$MainForm.AutoScaleDimensions = '6, 13'
	$MainForm.AutoScaleMode = 'Font'
	$MainForm.ClientSize = '611, 272'
	#region Binary Data
	$upIcon64= "R0lGODlhAAIAAvcAAAAAAAAAMwAAZgAAmQAAzAAA/wArAAArMwArZgArmQArzAAr/wBVAABVMwBVZgBVmQBVzABV/wCAAACAMwCAZgCAmQ
CAzACA/wCqAACqMwCqZgCqmQCqzACq/wDVAADVMwDVZgDVmQDVzADV/wD/AAD/MwD/ZgD/mQD/zAD//zMAADMAMzMAZjMAmTMAzDMA/zMr
ADMrMzMrZjMrmTMrzDMr/zNVADNVMzNVZjNVmTNVzDNV/zOAADOAMzOAZjOAmTOAzDOA/zOqADOqMzOqZjOqmTOqzDOq/zPVADPVMzPVZj
PVmTPVzDPV/zP/ADP/MzP/ZjP/mTP/zDP//2YAAGYAM2YAZmYAmWYAzGYA/2YrAGYrM2YrZmYrmWYrzGYr/2ZVAGZVM2ZVZmZVmWZVzGZV
/2aAAGaAM2aAZmaAmWaAzGaA/2aqAGaqM2aqZmaqmWaqzGaq/2bVAGbVM2bVZmbVmWbVzGbV/2b/AGb/M2b/Zmb/mWb/zGb//5kAAJkAM5
kAZpkAmZkAzJkA/5krAJkrM5krZpkrmZkrzJkr/5lVAJlVM5lVZplVmZlVzJlV/5mAAJmAM5mAZpmAmZmAzJmA/5mqAJmqM5mqZpmqmZmq
zJmq/5nVAJnVM5nVZpnVmZnVzJnV/5n/AJn/M5n/Zpn/mZn/zJn//8wAAMwAM8wAZswAmcwAzMwA/8wrAMwrM8wrZswrmcwrzMwr/8xVAM
xVM8xVZsxVmcxVzMxV/8yAAMyAM8yAZsyAmcyAzMyA/8yqAMyqM8yqZsyqmcyqzMyq/8zVAMzVM8zVZszVmczVzMzV/8z/AMz/M8z/Zsz/
mcz/zMz///8AAP8AM/8AZv8Amf8AzP8A//8rAP8rM/8rZv8rmf8rzP8r//9VAP9VM/9VZv9Vmf9VzP9V//+AAP+AM/+AZv+Amf+AzP+A//
+qAP+qM/+qZv+qmf+qzP+q///VAP/VM//VZv/Vmf/VzP/V////AP//M///Zv//mf//zP///wAAAAAAAAAAAAAAACH5BAEAAPwALAAAAAAA
AgACAAj/APcJHEiwoMGDCBMqXMiwocOHECNKnEixosWLGDNq3Mixo8ePIEOKHEmypMmTKFOqXMmypcuXMGPKnEmzps2bOHPq3Mmzp8+fQI
MKHUq0qNGjSJMqXcq0qdOnUKNKnUq1qtWrWLNq3cq1q9evYMOKHUu2rNmzaNOqXcu2rdu3cOPKnUu3rt27ePPq3ctTGUG/AwELFLyPsOG/
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
QzTAB6r4zOKBZQyowDBNjU2ohJ94Rb64nyUVoeoUXYelaCRoZXnOjkRuGlgmnBumyjICIqXWpaPaJyCCYMYFqNzdp2smz7HiJx4qEXItKq
RY6aPw6W8KKwnmYTf1XVQd6FP1TvOwx838zOKpY8sdm0mAGx65KqzGqpsejaCsqK1imjCRJliKlSRoYI1yYGtOaaM2lbRiB5MGbLLCZZQS
LCJCit71q29KY5QuovIB68YtbCIW6UgyUVp+oMVS60hmFXxoRE3eQACUhIuiK6O1qxl6/w2coijZCRyuikHtqBz1+FZZMuo0RazKPKtcBm
iNzeUK0mXCGqLBRmqkrqalHuyPCiKAQinNeGz1AMgNrIANaBmJNqQuaWVPbGWiuI5JpKeM3qsGShcHdsrCVmvBukwjaux+Fi2CGqnQDuiQ
kqQzTSt+ZizdJi3SDu2pBR7d4W2glu2wuu3PnsdDnNxHDI1ZzQ5KKAgk0CrZce0QgSURYYIwJBNZXirF1m2wdsci/ieRMqILsuAgau7KUC
pzRdEgOpX0OWvgHu0jZh9zVWreSlzF1izDaqwUacfSeofu3m54rMeqQYN7ZIQxnZ/B5WobKhzvWMehhq53dCshat9wVf8fw1qcNaUawf5t
jiaX3QqX9NXd8/au0V4rCk6s7NauzkpK2dYdVYlaXiqo8ByqQNiMrgmIMjKcPuQsshaokImuj7nl+0YvSSZs9v7ojgJsfI7H2S6r/v4rA1
+r/zaVNxLwqeGvpK4k7KqgSLJajv1spfCu+XKHHXquXUacxSmfk57v9k5vkMFtCv8oBE+jst6tlGJr+IJwx13rcYUH+LpwtMru9fqmW1bK
gRrrSKYH5iKxB+IoCjJf2/qm+9Jwq5UvRwYw+uKYBUNrDItv68ouHq5t7kJqNpWvC+7n3I7xCVaTgE7vknLxxrGtAwuw7W4skIYw7S7wM+
WwCa+k2YbVLw/76Q0TFxQ3sOA6sfP2beze8VMB8cDK8SFDo8AqMQVD8hz/6M2e8Rkj8gZvMSYDst9ZnOpGXP46HMLW7AS3sRUn8fYOqhMH
F8Y1cR6K8OcuqX/6qJGqbQ4n8iDzcQETavCI8nZwbuau8ud2MiU7MipX6p8SBMbSMcBSE6DCsQwj8komqsVWCjOHcAIbMt3+MuDa8PAA6x
hzMDLfLCGr8ujqcjEfsy1P8h0q8ClDr8JWMTrbcBTRJ9A6cxTHcQZvcTtDyvN+Y4L68BV/JPwOhB8PdN7h+DIIazJTdWShLuIiM+oHzzMj
Q6w2q7Px9CsAa7H4BjTaTjJI9idB6C4nT98rMzIyR/M3Z/TdlrN1uKVC350xD7TZ7u0wE7Mco3AgSvQuw/Nrxh2racJZxm8u23BRG3Qhsy
TfNnILmnJLQ3VUS/VUU3VVW/VVY3VWa/VWc3VXe/VXg3VYi/VYk3VZm/VZo3Vaq/Vas3Vbu/Vbw3Vcy/Vc03Vd2/Vd43Ve6/Ve83Vf+/Vf
A3ZgC/ZgE3ZhG/ZhI3ZiK/ZiM3ZjO/ZjQ3ZkS/ZkU3ZlW/ZlY3Zma/Zmc3Zne/Zng3Zoi/Zok3Zpm/Zpo3Zqq/Zqs3Zru/ZrW8N2bMv2bN
N2bdv2beN2buv2bvN2b/v2bwN3cAv3cBN3cRv3cSN3civ3cjN3czv3c0N3dEv3dFN3dVv3dWN3dmv3dnN3d3v3d4N3eIv3eJN3eZv3eaN3
eqv3erMZd3u793vDd3zL93zTd33b933jd37rt1sHBAA7"
	$iconStream=[System.IO.MemoryStream][System.Convert]::FromBase64String($upIcon64)
	$iconBmp=[System.Drawing.Bitmap][System.Drawing.Image]::FromStream($iconStream)
	$iconHandle=$iconBmp.GetHicon()
	$upIcon=[System.Drawing.Icon]::FromHandle($iconHandle)
	$MainForm.Icon = $upIcon

	#endregion
	$MainForm.MainMenuStrip = $menustrip1
	$MainForm.Name = 'MainForm'
	$MainForm.SizeGripStyle = 'Hide'
	$MainForm.StartPosition = 'CenterScreen'
	$MainForm.Text = 'Toolbox'
	$MainForm.add_FormClosing($MainForm_FormClosing)
	$MainForm.add_Load($MainForm_Load)
	$MainForm.add_SizeChanged($MainForm_SizeChanged)
	#
	# listview1
	#
	$listview1.Location = '12, 27'
	$listview1.MultiSelect = $False
	$listview1.Name = 'listview1'
	$listview1.Size = '587, 234'
	$listview1.TabIndex = 2
	$listview1.UseCompatibleStateImageBehavior = $False
	$listview1.add_DoubleClick($listview1_DoubleClick)
	$listview1.add_MouseDown($listview1_MouseDown)
	#
	# menustrip1
	#
	[void]$menustrip1.Items.Add($fileToolStripMenuItem)
	[void]$menustrip1.Items.Add($configToolStripMenuItem)
	[void]$menustrip1.Items.Add($helpToolStripMenuItem)
	$menustrip1.Location = '0, 0'
	$menustrip1.Name = 'menustrip1'
	$menustrip1.Size = '611, 24'
	$menustrip1.TabIndex = 0
	$menustrip1.Text = 'menustrip1'
	#
	# fileToolStripMenuItem
	#
	[void]$fileToolStripMenuItem.DropDownItems.Add($addCustomToolToolStripMenuItem)
	[void]$fileToolStripMenuItem.DropDownItems.Add($importToolStripMenuItem)
	[void]$fileToolStripMenuItem.DropDownItems.Add($exportToolStripMenuItem)
	[void]$fileToolStripMenuItem.DropDownItems.Add($exitToolStripMenuItem)
	$fileToolStripMenuItem.Name = 'fileToolStripMenuItem'
	$fileToolStripMenuItem.Size = '37, 20'
	$fileToolStripMenuItem.Text = 'File'
	#
	# configToolStripMenuItem
	#
	[void]$configToolStripMenuItem.DropDownItems.Add($showConfigToolStripMenuItem)
	[void]$configToolStripMenuItem.DropDownItems.Add($reloadConfigToolStripMenuItem)
	[void]$configToolStripMenuItem.DropDownItems.Add($setSnapViewToolStripMenuItem)
	[void]$configToolStripMenuItem.DropDownItems.Add($alwaysOnTopToolStripMenuItem)
	[void]$configToolStripMenuItem.DropDownItems.Add($rememberSizeLocationToolStripMenuItem)
	$configToolStripMenuItem.Name = 'configToolStripMenuItem'
	$configToolStripMenuItem.Size = '55, 20'
	$configToolStripMenuItem.Text = 'Config'
	#
	# helpToolStripMenuItem
	#
	[void]$helpToolStripMenuItem.DropDownItems.Add($logToolStripMenuItem)
	[void]$helpToolStripMenuItem.DropDownItems.Add($showToolTipsToolStripMenuItem)
	[void]$helpToolStripMenuItem.DropDownItems.Add($debugModeToolStripMenuItem)
	$helpToolStripMenuItem.Name = 'helpToolStripMenuItem'
	$helpToolStripMenuItem.Size = '44, 20'
	$helpToolStripMenuItem.Text = 'Help'
	#
	# importToolStripMenuItem
	#
	$importToolStripMenuItem.Name = 'importToolStripMenuItem'
	$importToolStripMenuItem.Size = '169, 22'
	$importToolStripMenuItem.Text = 'Import Settings'
	$importToolStripMenuItem.add_Click($importToolStripMenuItem_Click)
	#
	# exportToolStripMenuItem
	#
	$exportToolStripMenuItem.Name = 'exportToolStripMenuItem'
	$exportToolStripMenuItem.Size = '169, 22'
	$exportToolStripMenuItem.Text = 'Export Settings'
	$exportToolStripMenuItem.add_Click($exportToolStripMenuItem_Click)
	#
	# exitToolStripMenuItem
	#
	$exitToolStripMenuItem.Name = 'exitToolStripMenuItem'
	$exitToolStripMenuItem.Size = '169, 22'
	$exitToolStripMenuItem.Text = 'Exit'
	$exitToolStripMenuItem.add_Click($exitToolStripMenuItem_Click)
	#
	# showConfigToolStripMenuItem
	#
	$showConfigToolStripMenuItem.Name = 'showConfigToolStripMenuItem'
	$showConfigToolStripMenuItem.Size = '153, 22'
	$showConfigToolStripMenuItem.Text = 'Show Config'
	$showConfigToolStripMenuItem.add_Click($showConfigToolStripMenuItem_Click)
	#
	# reloadConfigToolStripMenuItem
	#
	$reloadConfigToolStripMenuItem.Name = 'reloadConfigToolStripMenuItem'
	$reloadConfigToolStripMenuItem.Size = '153, 22'
	$reloadConfigToolStripMenuItem.Text = 'Reload Config'
	$reloadConfigToolStripMenuItem.add_Click($reloadConfigToolStripMenuItem_Click)
	#
	# logToolStripMenuItem
	#
	$logToolStripMenuItem.Name = 'logToolStripMenuItem'
	$logToolStripMenuItem.Size = '128, 22'
	$logToolStripMenuItem.Text = 'Log'
	$logToolStripMenuItem.add_Click($logToolStripMenuItem_Click)
	#
	# showToolTipsToolStripMenuItem
	#
	$showToolTipsToolStripMenuItem.Name = 'showToolTipsToolStripMenuItem'
	$showToolTipsToolStripMenuItem.Size = '128, 22'
	$showToolTipsToolStripMenuItem.Text = 'Show Tips'
	$showToolTipsToolStripMenuItem.Visible = $True
	$showToolTipsToolStripMenuItem.add_Click($showToolTipsToolStripMenuItem_Click)
	#
	# debugModeToolStripMenuItem
	#
	[void]$debugModeToolStripMenuItem.DropDownItems.Add($setDebugModeToolStripMenuItem)
	$debugModeToolStripMenuItem.Name = 'debugModeToolStripMenuItem'
	$debugModeToolStripMenuItem.Size = '152, 22'
	$debugModeToolStripMenuItem.Text = 'Debug Mode'
	#
	# setDebugModeToolStripMenuItem
	#
	$setDebugModeToolStripMenuItem.Name = 'setDebugModeToolStripMenuItem'
	$setDebugModeToolStripMenuItem.Size = '155, 22'
	$setDebugModeToolStripMenuItem.Text = 'setDebugMode'
	$setDebugModeToolStripMenuItem.add_Click($setDebugModeToolStripMenuItem_Click)
	#
	# contextmenu1
	#
	[void]$contextmenu1.Items.Add($openToolStripMenuItem)
	[void]$contextmenu1.Items.Add($editCustomToolStripMenuItem)
	[void]$contextmenu1.Items.Add($createShortcutToolStripMenuItem)
	[void]$contextmenu1.Items.Add($uninstallToolStripMenuItem)
	[void]$contextmenu1.Items.Add($removeCustomToolToolStripMenuItem)
	[void]$contextmenu1.Items.Add($newCustomToolToolStripMenuItem)
	$contextmenu1.Name = 'contextmenu1'
	$contextmenu1.ShowImageMargin = $False
	$contextmenu1.Size = '164, 114'
	$contextmenu1.add_Closed($contextmenu1_Closed)
	#
	# openToolStripMenuItem
	#
	$openToolStripMenuItem.Name = 'openToolStripMenuItem'
	$openToolStripMenuItem.Size = '163, 22'
	$openToolStripMenuItem.Text = 'Open'
	$openToolStripMenuItem.add_Click($openToolStripMenuItem_Click)
	#
	# uninstallToolStripMenuItem
	#
	$uninstallToolStripMenuItem.Name = 'uninstallToolStripMenuItem'
	$uninstallToolStripMenuItem.Size = '163, 22'
	$uninstallToolStripMenuItem.Text = 'Uninstall'
	$uninstallToolStripMenuItem.add_Click($uninstallToolStripMenuItem_Click)
	#
	# createShortcutToolStripMenuItem
	#
	$createShortcutToolStripMenuItem.Name = 'createShortcutToolStripMenuItem'
	$createShortcutToolStripMenuItem.Size = '163, 22'
	$createShortcutToolStripMenuItem.Text = 'Create Shortcut'
	$createShortcutToolStripMenuItem.add_Click($createShortcutToolStripMenuItem_Click)
	#
	# timerBringtoFront
	#
	$timerBringtoFront.add_Tick($timerBringtoFront_Tick)
	#
	# timerShowNewStuff
	#
	$timerShowNewStuff.Interval = 1000
	$timerShowNewStuff.add_Tick($timerShowNewStuff_Tick)
	#
	# removeCustomToolToolStripMenuItem
	#
	$removeCustomToolToolStripMenuItem.Name = 'removeCustomToolToolStripMenuItem'
	$removeCustomToolToolStripMenuItem.Size = '163, 22'
	$removeCustomToolToolStripMenuItem.Text = 'Remove Custom Tool'
	$removeCustomToolToolStripMenuItem.add_Click($removeCustomToolToolStripMenuItem_Click)
	#
	# addCustomToolToolStripMenuItem
	#
	$addCustomToolToolStripMenuItem.Name = 'addCustomToolToolStripMenuItem'
	$addCustomToolToolStripMenuItem.Size = '169, 22'
	$addCustomToolToolStripMenuItem.Text = 'New Custom Tool'
	$addCustomToolToolStripMenuItem.add_Click($addCustomToolToolStripMenuItem_Click)
	#
	# setSnapViewToolStripMenuItem
	#
	$setSnapViewToolStripMenuItem.Name = 'setSnapViewToolStripMenuItem'
	$setSnapViewToolStripMenuItem.Size = '153, 22'
	$setSnapViewToolStripMenuItem.Text = 'setSnapView'
	$setSnapViewToolStripMenuItem.Visible = $True
	$setSnapViewToolStripMenuItem.add_Click($setSnapViewToolStripMenuItem_Click)
	#
	# alwaysOnTopToolStripMenuItem
	#
	$alwaysOnTopToolStripMenuItem.Name = 'alwaysOnTopToolStripMenuItem'
	$alwaysOnTopToolStripMenuItem.Size = '153, 22'
	$alwaysOnTopToolStripMenuItem.Text = 'Always On Top'
	$alwaysOnTopToolStripMenuItem.add_Click($alwaysOnTopToolStripMenuItem_Click)
	#
	# rememberSizeLocationToolStripMenuItem
	#
	$rememberSizeLocationToolStripMenuItem.Name = 'rememberSizeLocationToolStripMenuItem'
	$rememberSizeLocationToolStripMenuItem.Size = '206, 22'
	$rememberSizeLocationToolStripMenuItem.Text = 'Remember Size/Location'
	$rememberSizeLocationToolStripMenuItem.add_Click($rememberSizeLocationToolStripMenuItem_Click)
	#
	# timerAppLaunched
	#
	$timerAppLaunched.Interval = 1000
	$timerAppLaunched.add_Tick($timerAppLaunched_Tick)
	#
	# editCustomToolStripMenuItem
	#
	$editCustomToolStripMenuItem.Name = 'editCustomToolStripMenuItem'
	$editCustomToolStripMenuItem.Size = '163, 22'
	$editCustomToolStripMenuItem.Text = 'Edit'
	$editCustomToolStripMenuItem.add_Click($editCustomToolStripMenuItem_Click)
	#
	# newCustomToolToolStripMenuItem
	#
	$newCustomToolToolStripMenuItem.Name = 'newCustomToolToolStripMenuItem'
	$newCustomToolToolStripMenuItem.Size = '163, 22'
	$newCustomToolToolStripMenuItem.Text = 'New Custom Tool'
	$newCustomToolToolStripMenuItem.add_Click($newCustomToolToolStripMenuItem_Click)
	$contextmenu1.ResumeLayout()
	$menustrip1.ResumeLayout()
	$MainForm.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $MainForm.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$MainForm.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$MainForm.add_FormClosed($Form_Cleanup_FormClosed)
	#Store the control values when form is closing
	$MainForm.add_Closing($Form_StoreValues_Closing)
	#Show the Form
	return $MainForm.ShowDialog()

}
#endregion Source: MainForm.psf

#region Source: AddCustomApp.psf
function Show-AddCustomApp_psf
{

param (
	$function = "Add",
	$RegPath
)

	#----------------------------------------------
	#region Define SAPIEN Types
	#----------------------------------------------
	try{
		[FolderBrowserModernDialog] | Out-Null
	}
	catch
	{
		Add-Type -ReferencedAssemblies ('System.Windows.Forms') -TypeDefinition  @" 
		using System;
		using System.Windows.Forms;
		using System.Reflection;

        namespace SAPIENTypes
        {
		    public class FolderBrowserModernDialog : System.Windows.Forms.CommonDialog
            {
                private System.Windows.Forms.OpenFileDialog fileDialog;
                public FolderBrowserModernDialog()
                {
                    fileDialog = new System.Windows.Forms.OpenFileDialog();
                    fileDialog.Filter = "Folders|\n";
                    fileDialog.AddExtension = false;
                    fileDialog.CheckFileExists = false;
                    fileDialog.DereferenceLinks = true;
                    fileDialog.Multiselect = false;
                    fileDialog.Title = "Select a folder";
                }

                public string Title
                {
                    get { return fileDialog.Title; }
                    set { fileDialog.Title = value; }
                }

                public string InitialDirectory
                {
                    get { return fileDialog.InitialDirectory; }
                    set { fileDialog.InitialDirectory = value; }
                }
                
                public string SelectedPath
                {
                    get { return fileDialog.FileName; }
                    set { fileDialog.FileName = value; }
                }

                object InvokeMethod(Type type, object obj, string method, object[] parameters)
                {
                    MethodInfo methInfo = type.GetMethod(method, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
                    return methInfo.Invoke(obj, parameters);
                }

                bool ShowOriginalBrowserDialog(IntPtr hwndOwner)
                {
                    FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();
                    folderBrowserDialog.Description = this.Title;
                    folderBrowserDialog.SelectedPath = !string.IsNullOrEmpty(this.SelectedPath) ? this.SelectedPath : this.InitialDirectory;
                    folderBrowserDialog.ShowNewFolderButton = false;
                    if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
                    {
                        fileDialog.FileName = folderBrowserDialog.SelectedPath;
                        return true;
                    }
                    return false;
                }

                protected override bool RunDialog(IntPtr hwndOwner)
                {
                    if (Environment.OSVersion.Version.Major >= 6)
                    {      
                        try
                        {
                            bool flag = false;
                            System.Reflection.Assembly assembly = Assembly.Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089");
                            Type typeIFileDialog = assembly.GetType("System.Windows.Forms.FileDialogNative").GetNestedType("IFileDialog", BindingFlags.NonPublic);
                            uint num = 0;
                            object dialog = InvokeMethod(fileDialog.GetType(), fileDialog, "CreateVistaDialog", null);
                            InvokeMethod(fileDialog.GetType(), fileDialog, "OnBeforeVistaDialog", new object[] { dialog });
                            uint options = (uint)InvokeMethod(typeof(System.Windows.Forms.FileDialog), fileDialog, "GetOptions", null) | (uint)0x20;
                            InvokeMethod(typeIFileDialog, dialog, "SetOptions", new object[] { options });
                            Type vistaDialogEventsType = assembly.GetType("System.Windows.Forms.FileDialog").GetNestedType("VistaDialogEvents", BindingFlags.NonPublic);
                            object pfde = Activator.CreateInstance(vistaDialogEventsType, fileDialog);
                            object[] parameters = new object[] { pfde, num };
                            InvokeMethod(typeIFileDialog, dialog, "Advise", parameters);
                            num = (uint)parameters[1];
                            try
                            {
                                int num2 = (int)InvokeMethod(typeIFileDialog, dialog, "Show", new object[] { hwndOwner });
                                flag = 0 == num2;
                            }
                            finally
                            {
                                InvokeMethod(typeIFileDialog, dialog, "Unadvise", new object[] { num });
                                GC.KeepAlive(pfde);
                            }
                            return flag;
                        }
                        catch
                        {
                            return ShowOriginalBrowserDialog(hwndOwner);
                        }
                    }
                    else
                        return ShowOriginalBrowserDialog(hwndOwner);
                }

                public override void Reset()
                {
                    fileDialog.Reset();
                }
            }
       }
"@ -IgnoreWarnings | Out-Null
	}
	#endregion Define SAPIEN Types

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	$formAddCustomApp = New-Object 'System.Windows.Forms.Form'
	$buttonReset = New-Object 'System.Windows.Forms.Button'
	$buttonBrowseIcon = New-Object 'System.Windows.Forms.Button'
	$picturebox1 = New-Object 'System.Windows.Forms.PictureBox'
	$labelIcon = New-Object 'System.Windows.Forms.Label'
	$buttonTest = New-Object 'System.Windows.Forms.Button'
	$textboxArgs = New-Object 'System.Windows.Forms.TextBox'
	$labelArguments = New-Object 'System.Windows.Forms.Label'
	$buttonAdd = New-Object 'System.Windows.Forms.Button'
	$buttonBrowse = New-Object 'System.Windows.Forms.Button'
	$textboxExecute = New-Object 'System.Windows.Forms.TextBox'
	$labelExecute = New-Object 'System.Windows.Forms.Label'
	$textboxName = New-Object 'System.Windows.Forms.TextBox'
	$labelName = New-Object 'System.Windows.Forms.Label'
	$textboxDesc = New-Object 'System.Windows.Forms.TextBox'
	$labelDesc = New-Object 'System.Windows.Forms.Label'
	$folderbrowsermoderndialog1 = New-Object 'SAPIENTypes.FolderBrowserModernDialog'
	$folderbrowsermoderndialog2 = New-Object 'SAPIENTypes.FolderBrowserModernDialog'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	function Check
	{
		$state = $false
		If ($textboxName.Text.Length -ge 1)
		{
			$state = $true
		}
		If ((Test-Path -Path "$($textboxExecute.Text)"))
		{
			$state = $true
			If (!($Script:UseCustomIcon -eq $true))
			{
				$Error.Clear()
				$picturebox1.Image = ([Drawing.Icon]::ExtractAssociatedIcon("$($textboxExecute.Text)").ToBitmap())
				If ($Error)
				{
					Log -text "An error occured while attempting to extract the icon." -Component "AddCustomApp.psf_Check" -Type 3
					Log -text "$Error" -Component "AddCustomApp.psf_Check" -Type 3
					Log -text "" -Component "AddCustomApp.psf_Check" -Type 3
				}
			}
		}
		Else
		{
			$state = $false
		}
		$buttonAdd.Enabled = $state
		$buttonTest.Enabled = $state
	}
	Function Get-FileName($initialDirectory)
	{
		[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
		$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
		$OpenFileDialog.DereferenceLinks = $false
		$OpenFileDialog.initialDirectory = $initialDirectory
		$OpenFileDialog.filter = "All files (*.*)| *.*"
		$OpenFileDialog.ShowDialog() | Out-Null
		$OpenFileDialog.filename
	}
	$formAddCustomApp_Load={
		If ($function -eq "Add")
		{
			Check	
		}
		elseif ($function -eq "Edit")
		{
			Debug-Log -text "Loading in Edit view..." -Component "AddCustomApp.psf_formAddCustomApp_Load" -Type 4
			Debug-Log -text "Received the RegPath of: $RegPath" -Component "AddCustomApp.psf_formAddCustomApp_Load" -Type 4
			$buttonAdd.Text = "Save"
			$formAddCustomApp.Text = "Edit Custom App"
			$Script:Properties = Get-ItemProperty -Path "$RegPath"
			$textboxName.Text = "$($Properties.Name)"
			$textboxDesc.Text = "$($Properties.Description)"
			$textboxExecute.Text = "$($Properties.LocalPath)"
			If (($Properties.Args))
			{
				$textboxArgs.Text = "$($Properties.Args)"
			}
			If (($Properties.IconPath))
			{
				$Error.Clear()
				$picturebox1.Image = ([Drawing.Icon]::ExtractAssociatedIcon("$($Properties.IconPath)").ToBitmap())
				If ($Error)
				{
					Log -text "An error occured while attempting to extract the custom icon." -Component "AddCustomApp.psf_formAddCustomApp_Load" -Type 3
					Log -text "$Error" -Component "AddCustomApp.psf_formAddCustomApp_Load" -Type 3
					Log -text "" -Component "AddCustomApp.psf_formAddCustomApp_Load" -Type 3
				}
				$Script:CustomIcon = "$($Properties.IconPath)"
				$Script:UseCustomIcon = $true
				$buttonReset.Visible = $true
			}
			Else
			{
				$Script:UseCustomIcon = $false
				$Error.Clear()
				$picturebox1.Image = ([Drawing.Icon]::ExtractAssociatedIcon("$($Properties.LocalPath)").ToBitmap())
				If ($Error)
				{
					Log -text "An error occured while attempting to extract the default icon." -Component "AddCustomApp.psf_formAddCustomApp_Load" -Type 3
					Log -text "$Error" -Component "AddCustomApp.psf_formAddCustomApp_Load" -Type 3
					Log -text "" -Component "AddCustomApp.psf_formAddCustomApp_Load" -Type 3
				}
				$buttonReset.Visible = $false
			}
		}
	}
	$textboxName_TextChanged={
		Check
	}
	$textboxExecute_TextChanged={
		Check
	}
	$buttonBrowse_Click={
		$textboxExecute.Text = Get-FileName -initialDirectory $env:SystemDrive
		Check
	}
	$buttonAdd_Click={
		$formAddCustomApp.Cursor = 'WaitCursor'
		If ($function -eq "Add")
		{
			Debug-Log -text "Processing Add for $($textboxName.Text)..." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 4
			If ((Test-Path -Path "$Config_RootHKCU$AppShortName\CustomAdd\$($textboxName.Text)\"))
			{
				Debug-Log -text "A registry path already exists for the name of this new tool. Unable to add/overwrite/re-use." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 4
				Show-MessageBox_psf -title "ERROR" -text "A custom tool for the tool $($textboxName.Text) already exists. Unable to add a second one." -boxtype 1 -image 5 -x ($formAddCustomApp.Location.X + ($formAddCustomApp.Size.Width / 2)) -y ($formAddCustomApp.Location.Y + ($formAddCustomApp.Size.Height / 2))
			}
			Else
			{
				Debug-Log -text "Verifying the CustomAdd root key exists..." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 4
				$Error.Clear()
				If (!(Test-Path -Path "$Config_RootHKCU$AppShortName\CustomAdd\"))
				{
					Debug-Log -text "Creating the CustomAdd root key..." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 4
					$Error.Clear()
					New-Item -Path "$Config_RootHKCU$AppShortName" -Name "CustomAdd"
					New-ItemProperty -Path "$Config_RootHKCU$AppShortName\CustomAdd" -Name "AllowCustomEntries" -Value "1" -PropertyType "String"
				}
				If ($Error)
				{
					Log -text "An error occured while attempting to create the root registry key 'CustomAdd'." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
					Log -text "$Error" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
					Log -text "" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to add the new custom tool.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($formAddCustomApp.Location.X + ($formAddCustomApp.Size.Width / 2)) -y ($formAddCustomApp.Location.Y + ($formAddCustomApp.Size.Height / 2))
				}
				Else
				{

					# bit of jiggery-pokey to make PS1 scripts added are opened in powershell and run directly rather than opened in notepad
					if ([IO.Path]::GetExtension($textboxExecute.Text) -eq ".ps1") {
						$textboxArgs.Text = "-windowstyle hidden $($textboxExecute.Text)"
						$textboxExecute.Text = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
					}
					Debug-Log -text "Creating CustomAdd properties..." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 4
					$Error.Clear()
					New-Item -Path "$Config_RootHKCU$AppShortName\CustomAdd" -Name "$($textboxName.Text)"
					New-ItemProperty -Path "$Config_RootHKCU$AppShortName\CustomAdd\$($textboxName.Text)" -Name "Name" -Value "$($textboxName.Text)" -PropertyType "String"
					New-ItemProperty -Path "$Config_RootHKCU$AppShortName\CustomAdd\$($textboxName.Text)" -Name "LocalPath" -Value "$($textboxExecute.Text)" -PropertyType "String"
					If ($textboxDesc.Text.Length -ge 1)
					{
						New-ItemProperty -Path "$Config_RootHKCU$AppShortName\CustomAdd\$($textboxName.Text)" -Name "Description" -Value "$($textboxDesc.Text)" -PropertyType "String"
					}
					If ($textboxArgs.Text.Length -ge 1)
					{
						New-ItemProperty -Path "$Config_RootHKCU$AppShortName\CustomAdd\$($textboxName.Text)" -Name "Args" -Value "$($textboxArgs.Text)" -PropertyType "String"
					}
					If ($Script:UseCustomIcon -eq $true)
					{
						New-ItemProperty -Path "$Config_RootHKCU$AppShortName\CustomAdd\$($textboxName.Text)" -Name "IconPath" -Value "$CustomIcon" -PropertyType "String"
					}
					If ($Error)
					{
						Log -text "An error occured while attempting to add the 'Name' and 'LocalPath' items to the registry." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
						Log -text "$Error" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
						Log -text "" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured while attempting to add the new custom tool.`n`nSee log for additional details." -boxtype 1 -image 5 -x ($formAddCustomApp.Location.X + ($formAddCustomApp.Size.Width / 2)) -y ($formAddCustomApp.Location.Y + ($formAddCustomApp.Size.Height / 2))
					}
					Else
					{
						Show-MessageBox_psf -title "" -text "Successfully added tool." -boxtype 1 -image 2 -x ($formAddCustomApp.Location.X + ($formAddCustomApp.Size.Width / 2)) -y ($formAddCustomApp.Location.Y + ($formAddCustomApp.Size.Height / 2))
					}
				}
			}	
		}
		elseif ($function -eq "Edit")
		{
			Debug-Log -text "Processing Edit for $($Properties.Name)..." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 4
			If (!($Properties.Name -eq "$($textboxName.Text)"))
			{
				Debug-Log -text "Looks like the name changed. Ensuring new name isn't already in use."
				If ((Test-Path -Path "$Config_RootHKCU$AppShortName\CustomAdd\$($textboxName.Text)\"))
				{
					Debug-Log -text "The new name is already in use." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 4
					Show-MessageBox_psf -title "ERROR" -text "The name you're trying to use is already in use." -boxtype 1 -image 5 -x ($formAddCustomApp.Location.X + ($formAddCustomApp.Size.Width / 2)) -y ($formAddCustomApp.Location.Y + ($formAddCustomApp.Size.Height / 2))
				}
				Else
				{
					Debug-Log -text "Updating Name..." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 4
					$Error.Clear()
					Rename-Item -Path "$RegPath" -NewName "$($textboxName.Text)"
					If ($Error)
					{
						Log -text "An error occured while attempting to rename the key." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
						Log -text "$Error" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
						Log -text "" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
					}
					Else
					{
						Debug-Log -text "Updating the RegPath value..." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 4
						$RegPath = "$Config_RootHKCU$AppShortName\CustomAdd\$($textboxName.Text)\"
						Debug-Log -text "Renaming the Name item..." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 4
						$Error.Clear()
						Set-ItemProperty -Path "$RegPath" -Name "Name" -Value "$($textboxName.Text)"
						If ($Error)
						{
							Log -text "An error occured while attempting to update the Name item." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
							Log -text "$Error" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
							Log -text "" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
						}
					}
					
				}
			}
			Debug-Log -text "Updating LocalPath item..." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 4
			$Error.Clear()
			Set-ItemProperty -Path "$RegPath" -Name "LocalPath" -Value "$($textboxExecute.Text)"
			If ($Error)
			{
				Log -text "An error occured while attempting to update the LocalPath item." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
				Log -text "$Error" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
				Log -text "" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
			}
			Debug-Log -text "Updating Args item..." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 4
			$Error.Clear()
			If ($textboxArgs.Text.Length -ge 1)
			{
				If (($Properties.Args))
				{
					Set-ItemProperty -Path "$RegPath" -Name "Args" -Value "$($textboxArgs.Text)"
				}
				Else
				{
					New-ItemProperty -Path "$RegPath" -Name "Args" -Value "$($textboxArgs.Text)"
				}
			}
			Else
			{
				If (($Properties.Args))
				{
					Remove-ItemProperty -Path "$RegPath" -Name "Args" -Force
				}
			}
			If ($Error)
			{
				Log -text "An error occured while attempting to update the Args item." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
				Log -text "$Error" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
				Log -text "" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
			}
			Debug-Log -text "Updating Description item..." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 4
			$Error.Clear()
			If ($textboxDesc.Text.Length -ge 1)
			{
				If (($Properties.Description))
				{
					Set-ItemProperty -Path "$RegPath" -Name "Description" -Value "$($textboxDesc.Text)"
				}
				Else
				{
					New-ItemProperty -Path "$RegPath" -Name "Description" -Value "$($textboxDesc.Text)"
				}
			}
			Else
			{
				If (($Properties.Description))
				{
					Remove-ItemProperty -Path "$RegPath" -Name "Description" -Force
				}
			}
			If ($Error)
			{
				Log -text "An error occured while attempting to update the Description item." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
				Log -text "$Error" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
				Log -text "" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
			}
			Debug-Log -text "Updating IconPath item..." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 4
			$Error.Clear()
			If ($UseCustomIcon -eq $true)
			{
				If (($Properties.IconPath))
				{
					Set-ItemProperty -Path "$RegPath" -Name "IconPath" -Value "$CustomIcon"	
				}
				Else
				{
					New-ItemProperty -Path "$RegPath" -Name "IconPath" -Value "$CustomIcon"
				}
			}
			Else
			{
				If (($Properties.IconPath))
				{
					Remove-ItemProperty -Path "$RegPath" -Name "IconPath" -Force
				}
			}
			If ($Error)
			{
				Log -text "An error occured while attempting to update the IconPath item." -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
				Log -text "$Error" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
				Log -text "" -Component "AddCustomApp.psf_buttonAdd_Click" -Type 3
			}
		}
		$formAddCustomApp.Cursor = 'Default'
		$Global:ReScanApps = $true
		$formAddCustomApp.Close()
	}
	$buttonTest_Click={
		If ($textboxArgs.Text.Length -ge 1)
		{
			Start-Process -FilePath "$($textboxExecute.Text)" -ArgumentList "$($textboxArgs.Text)"	
		}
		Else
		{
			Start-Process -FilePath "$($textboxExecute.Text)"
		}
	}
	$buttonBrowseIcon_Click={
		Debug-Log -text "The custom icon Browse button was clicked." -Component "AddCustomApp.psf_buttonBrowseIcon_Click" -Type 4
		Function Get-FileName($initialDirectory)
		{
			$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
			$OpenFileDialog.DereferenceLinks = $false
			$OpenFileDialog.initialDirectory = $initialDirectory
			$OpenFileDialog.ShowDialog() | Out-Null
			$OpenFileDialog.filename
		}
		$CustomIconPath = Get-FileName -initialDirectory "C:\"
		If ((Test-Path $CustomIconPath))
		{
			Debug-Log -text "Received custom icon path: $CustomIconPath" -Component "AddCustomApp.psf_buttonBrowseIcon_Click" -Type 4
			$picturebox1.Image = ([Drawing.Icon]::ExtractAssociatedIcon("$CustomIconPath").ToBitmap())
			$Script:CustomIcon = $CustomIconPath
			$Script:UseCustomIcon = $true
			$buttonReset.Visible = $true
		}
		Else
		{
			Debug-Log -text "No path received." -Component "AddCustomApp.psf_buttonBrowseIcon_Click" -Type 4
		}
	}
	$buttonReset_Click={
		Debug-Log -text "Resetting icon back to the default icon..." -Component "AddCustomApp.psf_buttonReset_Click" -Type 4
		$Error.Clear()
		$picturebox1.Image = ([Drawing.Icon]::ExtractAssociatedIcon("$($textboxExecute.Text)").ToBitmap())
		If ($Error)
		{
			Log -text "An error occured while attempting to extract the icon." -Component "AddCustomApp.psf_buttonReset_Click" -Type 3
			Log -text "$Error" -Component "AddCustomApp.psf_buttonReset_Click" -Type 3
			Log -text "" -Component "AddCustomApp.psf_buttonReset_Click" -Type 3
		}
		$Script:UseCustomIcon = $false
		Clear-Variable -Scope Script -Name CustomIcon
		$buttonReset.Visible = $false
	}
	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formAddCustomApp.WindowState = $InitialFormWindowState
	}
	
	$Form_StoreValues_Closing=
	{
		#Store the control values
		$script:AddCustomApp_textboxArgs = $textboxArgs.Text
		$script:AddCustomApp_textboxExecute = $textboxExecute.Text
		$script:AddCustomApp_textboxName = $textboxName.Text
	}

	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$buttonReset.remove_Click($buttonReset_Click)
			$buttonBrowseIcon.remove_Click($buttonBrowseIcon_Click)
			$buttonTest.remove_Click($buttonTest_Click)
			$buttonAdd.remove_Click($buttonAdd_Click)
			$buttonBrowse.remove_Click($buttonBrowse_Click)
			$textboxExecute.remove_TextChanged($textboxExecute_TextChanged)
			$textboxName.remove_TextChanged($textboxName_TextChanged)
			$textboxDesc.remove_TextChanged($textboxDesc_TextChanged)
			$formAddCustomApp.remove_Load($formAddCustomApp_Load)
			$formAddCustomApp.remove_Load($Form_StateCorrection_Load)
			$formAddCustomApp.remove_Closing($Form_StoreValues_Closing)
			$formAddCustomApp.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$formAddCustomApp.SuspendLayout()
	#
	# formAddCustomApp
	#
	$formAddCustomApp.Controls.Add($buttonReset)
	$formAddCustomApp.Controls.Add($buttonBrowseIcon)
	$formAddCustomApp.Controls.Add($picturebox1)
	$formAddCustomApp.Controls.Add($labelIcon)
	$formAddCustomApp.Controls.Add($buttonTest)
	$formAddCustomApp.Controls.Add($textboxArgs)
	$formAddCustomApp.Controls.Add($labelArguments)
	$formAddCustomApp.Controls.Add($buttonAdd)
	$formAddCustomApp.Controls.Add($buttonBrowse)
	$formAddCustomApp.Controls.Add($textboxExecute)
	$formAddCustomApp.Controls.Add($labelExecute)
	$formAddCustomApp.Controls.Add($textboxName)
	$formAddCustomApp.Controls.Add($labelName)
	$formAddCustomApp.Controls.Add($textboxDesc)
	$formAddCustomApp.Controls.Add($labelDesc)
	$formAddCustomApp.AutoScaleDimensions = '6, 13'
	$formAddCustomApp.AutoScaleMode = 'Font'
	$formAddCustomApp.ClientSize = '377, 193'
	$formAddCustomApp.FormBorderStyle = 'FixedSingle'
	$formAddCustomApp.MaximizeBox = $False
	$formAddCustomApp.MinimizeBox = $False
	$formAddCustomApp.Name = 'formAddCustomApp'
	$formAddCustomApp.ShowIcon = $False
	$formAddCustomApp.ShowInTaskbar = $False
	$formAddCustomApp.StartPosition = 'CenterParent'
	$formAddCustomApp.Text = 'Add Custom App'
	$formAddCustomApp.add_Load($formAddCustomApp_Load)
	#
	# buttonReset
	#
	$buttonReset.Location = '205, 108'
	$buttonReset.Name = 'buttonReset'
	$buttonReset.Size = '75, 23'
	$buttonReset.TabIndex = 12
	$buttonReset.Text = 'Reset'
	$buttonReset.UseVisualStyleBackColor = $True
	$buttonReset.Visible = $False
	$buttonReset.add_Click($buttonReset_Click)
	#
	# buttonBrowseIcon
	#
	$buttonBrowseIcon.Location = '124, 108'
	$buttonBrowseIcon.Name = 'buttonBrowseIcon'
	$buttonBrowseIcon.Size = '75, 23'
	$buttonBrowseIcon.TabIndex = 11
	$buttonBrowseIcon.Text = 'Change'
	$buttonBrowseIcon.UseVisualStyleBackColor = $True
	$buttonBrowseIcon.add_Click($buttonBrowseIcon_Click)
	#
	# picturebox1
	#
	$picturebox1.Location = '83, 103'
	$picturebox1.Name = 'picturebox1'
	$picturebox1.Size = '32, 32'
	$picturebox1.TabIndex = 10
	$picturebox1.TabStop = $False
	#
	# labelIcon
	#
	$labelIcon.Location = '12, 98'
	$labelIcon.Name = 'labelIcon'
	$labelIcon.Size = '65, 23'
	$labelIcon.TabIndex = 0
	$labelIcon.Text = 'Icon:'
	$labelIcon.TextAlign = 'MiddleRight'
	#
	# buttonTest
	#
	$buttonTest.Location = '111, 157'
	$buttonTest.Name = 'buttonTest'
	$buttonTest.Size = '75, 23'
	$buttonTest.TabIndex = 8
	$buttonTest.Text = 'Test'
	$buttonTest.UseVisualStyleBackColor = $True
	$buttonTest.add_Click($buttonTest_Click)
	#
	# textboxArgs
	#
	$textboxArgs.Location = '83, 80'
	$textboxArgs.Name = 'textboxArgs'
	$textboxArgs.Size = '197, 20'
	$textboxArgs.TabIndex = 7
	#
	# labelArguments
	#
	$labelArguments.Location = '12, 78'
	$labelArguments.Name = 'labelArguments'
	$labelArguments.Size = '65, 23'
	$labelArguments.TabIndex = 0
	$labelArguments.Text = 'Arguments:'
	$labelArguments.TextAlign = 'MiddleRight'
	#
	# buttonAdd
	#
	$buttonAdd.Location = '192, 157'
	$buttonAdd.Name = 'buttonAdd'
	$buttonAdd.Size = '75, 23'
	$buttonAdd.TabIndex = 5
	$buttonAdd.Text = 'Add'
	$buttonAdd.UseVisualStyleBackColor = $True
	$buttonAdd.add_Click($buttonAdd_Click)
	#
	# buttonBrowse
	#
	$buttonBrowse.Location = '286, 56'
	$buttonBrowse.Name = 'buttonBrowse'
	$buttonBrowse.Size = '75, 23'
	$buttonBrowse.TabIndex = 4
	$buttonBrowse.Text = 'Browse'
	$buttonBrowse.UseVisualStyleBackColor = $True
	$buttonBrowse.add_Click($buttonBrowse_Click)
	#
	# textboxExecute
	#
	$textboxExecute.Location = '83, 57'
	$textboxExecute.Name = 'textboxExecute'
	$textboxExecute.ReadOnly = $True
	$textboxExecute.Size = '197, 20'
	$textboxExecute.TabIndex = 3
	$textboxExecute.add_TextChanged($textboxExecute_TextChanged)
	#
	# labelExecute
	#
	$labelExecute.Location = '12, 55'
	$labelExecute.Name = 'labelExecute'
	$labelExecute.Size = '65, 23'
	$labelExecute.TabIndex = 0
	$labelExecute.Text = 'Execute:'
	$labelExecute.TextAlign = 'MiddleRight'
	#
	# textboxName
	#
	$textboxName.Location = '83, 11'
	$textboxName.Name = 'textboxName'
	$textboxName.Size = '197, 20'
	$textboxName.TabIndex = 1
	$textboxName.add_TextChanged($textboxName_TextChanged)
	#
	# labelName
	#
	$labelName.Location = '12, 9'
	$labelName.Name = 'labelName'
	$labelName.Size = '65, 23'
	$labelName.TabIndex = 0
	$labelName.Text = 'Name:'
	$labelName.TextAlign = 'MiddleRight'
	#
	# textboxDesc
	#
	$textboxDesc.Location = '83, 34'
	$textboxDesc.Name = 'textboxDesc'
	$textboxDesc.Size = '197, 20'
	$textboxDesc.TabIndex = 2
	$textboxDesc.add_TextChanged($textboxDesc_TextChanged)
	#
	# labelDesc
	#
	$labelDesc.Location = '12, 32'
	$labelDesc.Name = 'labelDesc'
	$labelDesc.Size = '65, 23'
	$labelDesc.TabIndex = 0
	$labelDesc.Text = 'Description:'
	$labelDesc.TextAlign = 'MiddleRight'
	#
	# folderbrowsermoderndialog1
	#
	$folderbrowsermoderndialog1.InitialDirectory = 'C:\'
	$folderbrowsermoderndialog1.Title = 'Select a file'
	#
	# folderbrowsermoderndialog2
	#
	$formAddCustomApp.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formAddCustomApp.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formAddCustomApp.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formAddCustomApp.add_FormClosed($Form_Cleanup_FormClosed)
	#Store the control values when form is closing
	$formAddCustomApp.add_Closing($Form_StoreValues_Closing)
	#Show the Form
	return $formAddCustomApp.ShowDialog()

}
#endregion Source: AddCustomApp.psf

#region Source: Log.psf
function Show-Log_psf
{
	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	$formLogForCurrentSession = New-Object 'System.Windows.Forms.Form'
	$buttonClose = New-Object 'System.Windows.Forms.Button'
	$labelLogForCurrentSession = New-Object 'System.Windows.Forms.Label'
	$richtextbox1 = New-Object 'System.Windows.Forms.RichTextBox'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	$formLogForCurrentSession_Load={
		$Global:Log | ForEach-Object {
			$text = $_
			If (($text -like "*error*") -or ($text -like "*access is denied*")) {
				$richtextbox1.SelectionColor = 'Red'
				$richtextbox1.AppendText("`n$text")
			}
			elseif ($text -like "*warning*") {
				$richtextbox1.SelectionColor = 'Orange'
				$richtextbox1.AppendText("`n$text")
			}
			Else {
				$richtextbox1.SelectionColor = 'Black'
				$richtextbox1.AppendText("`n$text")
			}
			$richtextbox1.ScrollToCaret()
			[System.Windows.Forms.Application]::DoEvents()
		}
	}
	$buttonClose_Click={
		$formLogForCurrentSession.Close()
	}	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formLogForCurrentSession.WindowState = $InitialFormWindowState
	}
	
	$Form_StoreValues_Closing=
	{
		#Store the control values
		$script:Log_richtextbox1 = $richtextbox1.Text
	}

	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$buttonClose.remove_Click($buttonClose_Click)
			$formLogForCurrentSession.remove_Load($formLogForCurrentSession_Load)
			$formLogForCurrentSession.remove_Load($Form_StateCorrection_Load)
			$formLogForCurrentSession.remove_Closing($Form_StoreValues_Closing)
			$formLogForCurrentSession.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$formLogForCurrentSession.SuspendLayout()
	#
	# formLogForCurrentSession
	#
	$formLogForCurrentSession.Controls.Add($buttonClose)
	$formLogForCurrentSession.Controls.Add($labelLogForCurrentSession)
	$formLogForCurrentSession.Controls.Add($richtextbox1)
	$formLogForCurrentSession.AutoScaleDimensions = '6, 13'
	$formLogForCurrentSession.AutoScaleMode = 'Font'
	$formLogForCurrentSession.BackgroundImageLayout = 'Stretch'
	$formLogForCurrentSession.ClientSize = '579, 491'
	$formLogForCurrentSession.ControlBox = $False
	$formLogForCurrentSession.FormBorderStyle = 'FixedSingle'
	$formLogForCurrentSession.MaximumSize = '585, 520'
	$formLogForCurrentSession.MinimumSize = '585, 520'
	$formLogForCurrentSession.Name = 'formLogForCurrentSession'
	$formLogForCurrentSession.ShowIcon = $False
	$formLogForCurrentSession.ShowInTaskbar = $False
	$formLogForCurrentSession.StartPosition = 'CenterParent'
	$formLogForCurrentSession.Text = 'Log for current session'
	$formLogForCurrentSession.add_Load($formLogForCurrentSession_Load)
	#
	# buttonClose
	#
	$buttonClose.Location = '246, 452'
	$buttonClose.Name = 'buttonClose'
	$buttonClose.Size = '75, 23'
	$buttonClose.TabIndex = 2
	$buttonClose.Text = 'Close'
	$buttonClose.UseVisualStyleBackColor = $True
	$buttonClose.add_Click($buttonClose_Click)
	#
	# labelLogForCurrentSession
	#
	$labelLogForCurrentSession.BackColor = 'Transparent'
	$labelLogForCurrentSession.Location = '12, 9'
	$labelLogForCurrentSession.Name = 'labelLogForCurrentSession'
	$labelLogForCurrentSession.Size = '545, 23'
	$labelLogForCurrentSession.TabIndex = 1
	$labelLogForCurrentSession.Text = 'Log for current session'
	$labelLogForCurrentSession.TextAlign = 'MiddleCenter'
	#
	# richtextbox1
	#
	$richtextbox1.Location = '12, 43'
	$richtextbox1.Name = 'richtextbox1'
	$richtextbox1.ReadOnly = $True
	$richtextbox1.Size = '545, 403'
	$richtextbox1.TabIndex = 0
	$richtextbox1.Text = ''
	$formLogForCurrentSession.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formLogForCurrentSession.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formLogForCurrentSession.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formLogForCurrentSession.add_FormClosed($Form_Cleanup_FormClosed)
	#Store the control values when form is closing
	$formLogForCurrentSession.add_Closing($Form_StoreValues_Closing)
	#Show the Form
	return $formLogForCurrentSession.ShowDialog()

}
#endregion Source: Log.psf

#region Source: MessageBox.psf
function Show-MessageBox_psf
{

param (
	[string]$title,
	[string]$text,
	$boxtype,
	$image,
	$autoclose,
	[int]$x,
	[int]$y
)

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	$formMessageBox = New-Object 'System.Windows.Forms.Form'
	$button1 = New-Object 'System.Windows.Forms.Button'
	$button2 = New-Object 'System.Windows.Forms.Button'
	$button3 = New-Object 'System.Windows.Forms.Button'
	$panel1 = New-Object 'System.Windows.Forms.Panel'
	$picturebox1 = New-Object 'System.Windows.Forms.PictureBox'
	$label1 = New-Object 'System.Windows.Forms.Label'
	$timerAutoClose = New-Object 'System.Windows.Forms.Timer'
	$imagelist = New-Object 'System.Windows.Forms.ImageList'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	$formMessageBox_Load={
		Debug-Log -text "Loading MessageBox..." -Component "MessageBox.psf_formMessageBox_Load" -Type 4
		Debug-Log -text "Title: $Title" -Component "MessageBox.psf_formMessageBox_Load" -Type 4
		Debug-Log -text "Text: $text" -Component "MessageBox.psf_formMessageBox_Load" -Type 4
		Debug-Log -text "BoxType: $boxtype" -Component "MessageBox.psf_formMessageBox_Load" -Type 4
		Debug-Log -text "Image: $image" -Component "MessageBox.psf_formMessageBox_Load" -Type 4
		Debug-Log -text "AutoClose: $autoclose" -Component "MessageBox.psf_formMessageBox_Load" -Type 4
		Debug-Log -text "X: $x" -Component "MessageBox.psf_formMessageBox_Load" -Type 4
		Debug-Log -text "Y: $y" -Component "MessageBox.psf_formMessageBox_Load" -Type 4
		If (($x) -and ($y))
		{
			[int]$newX = ($x - ($formMessageBox.Width / 2))
			[int]$newY = ($y - ($formMessageBox.Height / 2))
			$SS = Check-ScreenLocation -x $newX -y $newY -formHeight $formMessageBox.Height -formWidth $formMessageBox.Width
			$formMessageBox.Location = (New-Object System.Drawing.Size($SS.X, $SS.Y))
		}
		$formMessageBox.Text = $title
		$label1.Text = $text
		$picturebox1.Image = $imagelist.Images[$image]
		If ($boxtype -eq 1)
		{
			$button1.Enabled = $false
			$button1.Visible = $false
			$button2.Enabled = $true
			$button2.Visible = $true
			$button2.Text = "OK"
			$button2.Location = (New-Object System.Drawing.Size (247, 124))
			$button2.DialogResult = 'OK'
			$button3.Enabled = $false
			$button3.Visible = $false
		}
		ElseIf ($boxtype -eq 4)
		{
			$button1.Enabled = $true
			$button1.Visible = $true
			$button1.Text = "Yes"
			$button1.DialogResult = 'Yes'
			$button1.Location = (New-Object System.Drawing.Size (205, 124))
			$button2.Enabled = $false
			$button2.Visible = $false
			$button3.Enabled = $true
			$button3.Visible = $true
			$button3.Text = "No"
			$button3.DialogResult = 'No'
			$button3.Location = (New-Object System.Drawing.Size (291, 124))
		}
		$panel1.SendToBack()
		If (($autoclose))
		{
			$timerAutoClose.Interval = ($autoclose * 1000)
			$timerAutoClose.Start()
		}
	}
	$button1_Click={
		$formMessageBox.Close()
	}
	$button2_Click={
		$formMessageBox.Close()
	}
	$button3_Click={
		$formMessageBox.Close()
	}
	$timerAutoClose_Tick={
		$formMessageBox.Close()
	}
	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formMessageBox.WindowState = $InitialFormWindowState
	}
	
	$Form_StoreValues_Closing=
	{
		#Store the control values
	}

	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$button1.remove_Click($button1_Click)
			$button2.remove_Click($button2_Click)
			$button3.remove_Click($button3_Click)
			$formMessageBox.remove_Load($formMessageBox_Load)
			$timerAutoClose.remove_Tick($timerAutoClose_Tick)
			$formMessageBox.remove_Load($Form_StateCorrection_Load)
			$formMessageBox.remove_Closing($Form_StoreValues_Closing)
			$formMessageBox.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$formMessageBox.SuspendLayout()
	#
	# formMessageBox
	#
	$formMessageBox.Controls.Add($button1)
	$formMessageBox.Controls.Add($button2)
	$formMessageBox.Controls.Add($button3)
	$formMessageBox.Controls.Add($panel1)
	$formMessageBox.Controls.Add($picturebox1)
	$formMessageBox.Controls.Add($label1)
	$formMessageBox.AutoScaleDimensions = '6, 13'
	$formMessageBox.AutoScaleMode = 'Font'
	$formMessageBox.BackColor = 'White'
	$formMessageBox.ClientSize = '568, 164'
	$formMessageBox.FormBorderStyle = 'FixedSingle'
	$formMessageBox.MaximizeBox = $False
	$formMessageBox.MinimizeBox = $False
	$formMessageBox.Name = 'formMessageBox'
	$formMessageBox.ShowIcon = $False
	$formMessageBox.ShowInTaskbar = $False
	$formMessageBox.StartPosition = 'CenterParent'
	$formMessageBox.TopMost = $True
	$formMessageBox.add_Load($formMessageBox_Load)
	#
	# button3
	#
	$button3.Location = '287, 129'
	$button3.Name = 'button3'
	$button3.Size = '75, 23'
	$button3.TabIndex = 3
	$button3.Text = 'button3'
	$button3.UseVisualStyleBackColor = $True
	$button3.add_Click($button3_Click)
	#
	# button1
	#
	$button1.Location = '206, 129'
	$button1.Name = 'button1'
	$button1.Size = '75, 23'
	$button1.TabIndex = 1
	$button1.Text = 'button1'
	$button1.UseVisualStyleBackColor = $True
	$button1.add_Click($button1_Click)
	#
	# button2
	#
	$button2.Location = '12, 110'
	$button2.Name = 'button2'
	$button2.Size = '75, 23'
	$button2.TabIndex = 2
	$button2.Text = 'button2'
	$button2.UseVisualStyleBackColor = $True
	$button2.add_Click($button2_Click)
	#
	# panel1
	#
	$panel1.BackColor = 'Control'
	$panel1.Location = '-5, 105'
	$panel1.Name = 'panel1'
	$panel1.Size = '577, 60'
	$panel1.TabIndex = 5
	#
	# picturebox1
	#
	$picturebox1.Location = '17, 32'
	$picturebox1.Name = 'picturebox1'
	$picturebox1.Size = '50, 50'
	$picturebox1.SizeMode = 'AutoSize'
	$picturebox1.TabIndex = 4
	$picturebox1.TabStop = $False
	#
	# label1
	#
	$label1.Location = '80, 9'
	$label1.Name = 'label1'
	$label1.Size = '477, 95'
	$label1.TabIndex = 0
	$label1.TextAlign = 'MiddleLeft'
	#
	# timerAutoClose
	#
	$timerAutoClose.add_Tick($timerAutoClose_Tick)
	#
	# imagelist
	#
	$Formatter_binaryFomatter = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
	#region Binary Data
	$System_IO_MemoryStream = New-Object System.IO.MemoryStream (,[byte[]][System.Convert]::FromBase64String('
AAEAAAD/////AQAAAAAAAAAMAgAAAFdTeXN0ZW0uV2luZG93cy5Gb3JtcywgVmVyc2lvbj00LjAu
MC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkFAQAA
ACZTeXN0ZW0uV2luZG93cy5Gb3Jtcy5JbWFnZUxpc3RTdHJlYW1lcgEAAAAERGF0YQcCAgAAAAkD
AAAADwMAAACsEgEAAk1TRnQBSQFMAgEBBwEAAVABAAFQAQABMgEAATIBAAT/ASEBAAj/AUIBTQE2
BwABNgMAASgDAAHIAwABZAMAAQEBAAEgBQABgAE4AQH/ADIABAEHAgEDAwQEBQQGAQcDBgEIAwYB
CAMHAQkDBgEIAwYBBwMFAQYDAwEEAwIBAwQCCAEwAAMtAUUDWwHKAx4B+gMAAf8DAAH/AwAB/wMA
Af8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB
/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/
AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMeAfoDWgHEAyUBN/8AHQAD
AgEDAwgBCgMPARQDFgEdAxsBJQMeASoDHgErAx0BKAMYASEDEgEYAwsBDgMEAQWQAAQBAwMBBAMG
AQgDCgENAw4EEgEYAxUBHQMZASIDGwEmAx0BKAMeASoDHgErAx4BKgMcAScDGwElAxgBIAMVARwD
EgEYAw8BEwMMAQ8DCAEKAwYBBwMDAQQEAgQBHAADKwFBAxQB/AMAAf8DAAH/AwAB/wMAAf8DAAH/
AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8D
AAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMA
Af8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8DLwH2AyAB
Lv8ADQADAgEDAw0BEQMdASgDKwFCAzYBWAM+AWoDRAF4A0cBggNJAYcDSQGIA0kBhQNGAX0DQQFx
AzoBYAMxAUwDIwEzAxMBGgMGAQd4AAQBAwMBBAMIAQoDDgESAxUBHAMdASgDJAE0AysBQQMxAU0D
NgFXAzkBXwM7AWQDPQFnAz0BaAM9AWcDOwFjAzgBXQM1AVYDMQFOAy0BRQMoATwDIwEzAx4BKgMZ
ASIDEwEaAw8BEwMKAQ0DBgEIAwMBBAQCFAADWQHBAwAB/wEBAQYBCAH/AQ4BRwFWAf8BEAFQAWAB
/wEQAVABYAH/ARABUAFgAf8BEAFQAWAB/wEQAVABYAH/ARABUAFgAf8BEAFQAWAB/wEQAVABYAH/
ARABUAFgAf8BEAFQAWAB/wEQAVABYAH/ARABUAFgAf8BEAFQAWAB/wEQAVABYAH/ARABUAFgAf8B
EAFQAWAB/wEQAVABYAH/ARABUAFgAf8BEAFQAWAB/wEQAVABYAH/ARABUAFgAf8BEAFQAWAB/wEQ
AVABYAH/ARABUAFgAf8BEAFQAWAB/wEQAVABYAH/ARABUAFgAf8BEAFQAWAB/wEQAVABYAH/ARAB
UAFgAf8BEAFQAWAB/wEQAVABYAH/ARABUAFgAf8BEAFQAWAB/wEQAVABYAH/ARABUAFgAf8BEAFQ
AWAB/wEQAVABYAH/ARABUAFgAf8BEAFQAWAB/wEQAVABYAH/ARABUAFgAf8BDgFEAVIB/wEBAgMB
/wMAAf8DVgGw/wAFAAMDAQQDEwEaAykBPgM7AWIDRwGBA1IBpANaAcIDYwHVAWsBZwFiAeEBdAFs
AVwB5wF1AWoBXQHqAXMBagFgAegBbQFoAWMB5AFnAWYBYgHcA2EBzwNZAbwDUwGnA0sBjQNAAW8D
MQFOAx0BKQMJAQtoAAQBAwQBBQMJAQwDEgEXAxsEJgE5AzIBTwM+AWsDSQGIA1IBoANWAbMDWgG/
A1oBxANZAcMDWQG+A1gBtwNVAa8DUwGmA1ABnQNNAZMDSQGGA0QBeQM+AWsDOAFcAzEBTgMrAUED
JAE0Ax0BKQMXAR8DEQEWAwwBDwMHAQkDBAEFBAIMAAMyAfcDAAH/ARUBawGAAf8BKgHUAv8BKgHU
Av8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8B
KgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHU
Av8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8B
KgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHU
Av8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BEwFeAXIB/wMAAf8DRAHx/AAEAQMQARUDKgFAAz8B
bANUAagBZAFhAVsB2AGeAXQBQAH2AecBfwEcAf8B5wF/ARwB/wHmAX8BHQH/AeYBfgEeAf8B5QF+
AR8B/wHlAX0BIAH/AeUBfQEhAf8B5AF8ASIB/wHkAXwBIwH/AeMBfAEkAf8BwgGCAUAB/QGWAXYB
WgH1AWsBaQFnAeQDXQHHA1IBpANGAX0DNAFTAxsBJgMFAQZcAAQCAwYBCAMOARIDGQEiAyUBNwM1
AVUDSwGPA1wByAFSAVMBYwHpATYBOwF8AfgBIgEvAYsB/gEaASkBqgH/ARoBLAGwAf8BGgEuAbYB
/wEbATABvAH/ASQBOgGoAf4BIQErAZYB+wE/AUUBdgH0AVYBVwFgAegDXQHUA1kBwANVAbQDUwGm
A04BlwNJAYYDQgF0AzoBYgMzAVEDKwFBAyMBMwMcAScDFAEbAw8BEwMJAQwDBgEHAwIBAwgAAzIB
9wMAAf8BFQFsAYIB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC
/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC
/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEXAXUBjQH/
AwAB/wMiAfn4AAMGAQcDHwEsAzsBYwNYAbMBhwFrAU8B8AHpAYEBGAH/AekBgQEaAf8B7QGLASoB
/wHzAZgBPAH/AfgBoQFJAf8B+wGoAVMB/wH+Aa0BWgL/AbABXgL/AbEBXwH/Af4BrgFdAf8B+wGq
AVcB/wH3AaIBTgH/AfEBlwFCAf8B6gGIATMB/wHiAXwBJgH/AeIBewEmAf8ByAGAAUUB/gGHAXkB
cAHxA2EB0QNTAaUDQwF2AywBQwMPARNUAAQBAwYBBwMPARMDGQEjAy4BRwJRAVIBoQJXAWkB6AEZ
ASIBmQH/ARsBJwGhAf8BHAEsAakB/wEdAS8BrwH/AR0BMgG1Af8BHQE1AbsB/wEeATcBwQH/AR4B
OQHHAf8BHgE7AcwB/wEfATwB0QH/AR8BPQHUAf8BHgE9AdYB/wEdATwB1gH/ARwBOgHWAf8BOQFA
AZcB+AFcAV0BYgHhA1oBxANWAbMDUgGjA0wBkQNGAX0DPQFpAzUBVgMtAUUDJAE1Ax0BKAMVARwD
DwETAwkBDAMFAQYEAgQAA1kBwQMAAf8BBQEZAR4B/wEpAc8B+QH/ASoB1AL/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB
1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB
1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB0wH+Af8BCQEtATYB/wMAAf8DXAHS9AADCgENAyoBQANOAZYBhQFsAVMB7gHqAYIB
FgH/Ae0BhwEgAf8B9QGbAT4B/wH9AawBVwL/AbABXQL/AbABXQL/AbABXQL/AbABXgL/AbEBXwL/
AbEBYAL/AbIBYAL/AbIBYQL/AbMBYgL/AbMBYwL/AbMBZAL/AbMBZQH/AfwBrwFgAf8B8gGaAUoB
/wHlAYEBLwH/AeEBegEnAf8ByQGAAUcB/gF/AXUBcAHvA10BxQNMAZADNgFYAxgBIAQCTAADAwEE
AwoBDQMfASwCUAFRAZ8BNwE6AXcB9gEaASQBmQH/ARsBKQGiAf8BHQEuAaoB/wEeATEBsgH/AR4B
NAG4Af8BHwE3Ab4B/wEfATkBwwH/AR8BPAHJAf8BHwE+Ac4B/wEgAUAB0wH/ASABQQHXAf8BIAFC
AdoB/wEgAUMB3QH/ASABQwHeAf8BHwFDAd8B/wEfAUIB3wH/AR4BQQHeAf8BHQE+AdsB/wEvAUAB
vgH9AVwBXQFlAeEDVgG2A1IBoANLAYwDQwF3AzsBYwMzAVADKgE/AyEBMAMZASMDEgEYAwwBEAMH
AQkDAwEEBAEDNAFTAwAB/wMAAf8BGAF7AZQB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC
/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wElAbsB4QH/AR8BmgG5Af8BJQG7AeAB
/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC
/wEdAZMBsQH/AwAB/wMAAf8DQAFx8AADDQERAzMBUAJdAVoBxwHsAYMBFAH/Ae0BhwEbAf8B9wGe
AUEC/wGvAVwC/wGwAV0C/wGwAV0C/wGwAV4C/wGwAV4C/wGxAV8C/wGxAWAC/wGyAWAC/wGyAWEC
/wGzAWIC/wGzAWMC/wGzAWUC/wGzAWUC/wG0AWYC/wG0AWcC/wG1AWgC/wG1AWkB/wH+AbQBaQH/
AfMBngFQAf8B5AF/AS4B/wHgAXkBKQH/AbMBiQFfAfsDZQHbA1MBogM8AWUDHAEnBAJIAAMFAQYD
PgFrAlABbQHuARoBIgGVAf8BGwEoAaAB/wEcAS0BqgH/AR0BMQGyAf8BHgE1AbkB/wEfATgBvwH/
AR8BOwHFAf8BIAE+AcsB/wEgAUABzwH/ASEBQgHTAf8BIQFEAdcB/wEhAUUB2wH/ASEBRgHeAf8B
IQFHAeEB/wEhAUcB4gH/ASEBRwHkAf8BIQFGAeUB/wEgAUYB5gH/ASABRQHlAf8BHwFDAeMB/wEe
AUEB3wH/AR0BPQHZAf8BJQFIAaUB+gJZAVwBxgNMAY4DRAF5AzsBZQM0AVMDKwFBAyMBMgMaASQD
EwEZAw0BEQMIAQoDBAEFCAIDWwHQAwAB/wEEARUBGQH/ASkBzAH1Af8BKgHUAv8BKgHUAv8BKgHU
Av8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8B
KgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BEwFiAXYB/wEAAgIB/wMAAf8BAAIC
Af8BEwFgAXQB/wEqAdQB/gH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB
1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/
ASoB0wH+Af8BCAEoATAB/wMAAf8DVwHlAwcBCewAAwwBEAM5AV0BbwFlAVkB5AHsAYQBEgH/AfMB
lAEuAf8B/gGtAVgC/wGwAV0C/wGwAV0C/wGwAV4C/wGxAV8C/wGxAWAC/wGxAWAC/wGyAWAC/wGy
AWEC/wGzAWIC/wGzAWQC/wGzAWUC/wGzAWYC/wG0AWcC/wG0AWcC/wG1AWgC/wG1AWkC/wG2AWoC
/wG2AWwC/wG3AWwC/wG3AW0B/wH9AbQBaQH/AewBkAFCAf8B4AF5ASkB/wHHAYABTgH+AXEBbwFs
AeYDVgGrAz4BaQMcAScEAkAAAw4BEgJWAVcBsgEZAR8BkQH/ARsBJgGcAf8BHAErAaUB/wEdAS8B
rwH/AR4BNAG4Af8BHgE4Ab8B/wEfATsBxQH/ASABPgHLAf8BIQFBAc8B/wEiAUMB0wH/ASIBRQHW
Af8BIgFHAdoB/wEjAUgB3QH/ASMBSQHgAf8BIwFKAeIB/wEjAUoB5QH/ASMBSgHmAf8BIwFKAecB
/wEiAUoB6AH/ASIBSQHoAf8BIQFIAegB/wEgAUYB5wH/AR8BRAHkAf8BHwFBAeAB/wEeAT4B2gH/
ARwBOAHRAf8CXwFjAdoDRAF6AzgBXQMwAUsDKAE7AyABLgMYASEDEgEXAwwBDwMHAQkDAwEEBAEE
AAMxAU0DAAH/AwAB/wEXAXIBigH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB
1AL/ASoB1AL/ARsBhwGiAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wEaAYUBoAH/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB
1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ARwBjwGsAf8DAAH/AwAB/wM/AWzsAAMIAQoDOQFd
AYUBbQFQAe4B7QGFARMB/wH4AZ8BQAL/AbABXQL/AbABXQL/AbABXgL/AbEBXwL/AbEBYAL/AbIB
YAL/AbIBYQL/AbIBYQL/AbMBYwL/AbMBZAL/AbMBZQL/AbMBZgL/AbQBZwL/AbQBaAL/AbUBaQL/
AbUBaQL/AbYBawL/AbYBbAL/AbcBbAL/AbcBbQL/AbgBbgL/AbgBbwL/AbkBcAL/AbkBcQH/AfMB
oAFWAf8B4QF6ASsB/wHcAYABOgH/AXMBbwFtAeoDVgGrAzwBZQMYASA8AAMbASUCXwFjAdoBGQEh
AZUB/wEbAScBoAH/ARwBLAGqAf8BHQExAbMB/wEeATYBvAH/AR8BOgHDAf8BIAE9AckB/wEhAUAB
zgH/ASEBQgHRAf8BIgFEAdQB/wEiAUYB1gH/ASMBSAHYAf8BIwFJAdsB/wEkAUsB3gH/ASQBTAHh
Af8BJAFNAeMB/wEkAU0B5gH/ASQBTQHnAf8BIwFNAekB/wEjAUwB6gH/ASIBTAHrAf8BIgFKAeoB
/wEhAUkB6QH/ASABRgHnAf8BHwFEAeMB/wEeAUEB3gH/AR4BPQHXAf8BHAE3Ac0B/wFVAVkBbwHp
Az0BaAMpAT4DIQEwAxoBJAMTARoDDgESAwkBCwMFAQYEAgwAA1oBxwMAAf8BAwEQARMB/wEoAcgB
8QH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/AQsBNgFBAf8DAAH/AwAB
/wMAAf8DAAH/AwAB/wEKATUBPwH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB
0gH9Af8BBwEkASsB/wMAAf8DWAHiAwYBB+gAAwMBBAMwAUoBgwFqAVIB7QHvAYcBEwH/AfoBpAFI
Av8BsAFdAv8BsAFeAv8BsQFfAv8BsQFgAv8BsgFgAv8BsgFhAv8BswFiAv8BswFjAv8BswFkAv8B
swFlAv8BswFmAv8BtAFnAv8BtAFoAv8BtQFpAv8BtQFqAv8BtgFrAv8BtgFsAv8BtwFsAv8BtwFt
Av8BuAFuAv8BuAFvAv8BuQFwAv8BuQFxAv8BugFyAv8BugFzAv8BuwF0Af8B9gGpAWAB/wHhAXwB
LQH/AdwBgAE7Af8BcQFvAWwB5gNTAaIDNgFYAw8BEzQAAyABLQJXAWkB6AEZASIBmAH/ARsBKAGj
Af8BHAEtAa0B/wEdATIBtgH/AR4BNwG+Af8BHwE7AccB/wEgAT4BzAH/ASEBQQHPAf8BIgFCAdAB
/wEiAUQB0gH/ASQBRgHUAf8BJAFIAdYB/wElAUoB2AH/ASUBSwHbAf8BJgFNAd4B/wEmAU4B4QH/
ASYBTwHkAf8BJgFPAeYB/wElAU8B6AH/ASUBTwHpAf8BJAFOAesB/wEjAU4B7AH/ASIBTQHsAf8B
IgFLAeoB/wEhAUkB6AH/ASABRgHlAf8BHwFDAeEB/wEeAT8B3AH/AR0BOwHTAf8BHAE1AccB/wFQ
AVUBdwHuAzMBUgMYASEDEwEZAw0BEQMIAQoDBQEGAwIBAxAAAysBQgMAAf8DAAH/ARUBagF/Af8B
KgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHU
Av8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BBwEiASkB/wMAAf8DAAH/AwAB
/wMAAf8DAAH/AQcBIQEnAf8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHU
Av8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BGwGKAaYB
/wMAAf8DAAH/AzwBZuwAAx4BKgFoAWIBWwHeAe8BhwEQAf8B+gGkAUkC/wGwAV4C/wGxAV8C/wGx
AWAC/wGyAWAC/wGyAWEC/wGzAWIC/wGzAWMC/wGzAWQC/wGzAWUC/wGzAWYC/wG0AWcC/wG0AWgC
/wG1AWkC/wG1AWoC/wG2AWsC/wG2AWwC/wG3AWwC/wG3AW0C/wG4AW4C/wG4AW8C/wG5AXAC/wG5
AXEC/wG6AXIC/wG6AXMC/wG7AXQC/wG7AXUC/wG8AXYC/wG8AXcB/wH3AasBYwH/AeEBewEsAf8B
xwGAAU8B/gNlAdsDTAGQAywBQwMFAQYsAAMZASICVwFrAecBGQEiAZgB/wEbASkBpAH/ARwBLgGv
Af8BHQEzAbkB/wEeATgBwQH/AR8BPAHJAf8BIAE/Ac0B/wEhAUEBzgH/ASIBQwHPAf8BIwFEAdAB
/wEjAUYB0QH/ASQBSAHSAf8BJQFKAdQB/wEmAUwB1gH/ASYBTgHZAf8BJwFPAd0B/wEnAVEB4AH/
AScBUgHiAf8BJwFRAeUB/wEmAVEB5wH/ASYBUQHpAf8BJQFQAeoB/wElAU8B6wH/ASQBTQHrAf8B
IwFMAeoB/wEhAUoB6QH/ASEBSAHnAf8BIAFFAeMB/wEfAUIB3gH/AR0BPgHXAf8BHQE4Ac0B/wEb
ATEBvgH/AVQBVQFvAeoDJAE0AwoBDQMGAQgDAwEEBAIYAANYAb0DAAH/AQIBCwEOAf8BJwHEAesB
/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wENAUQBUgH/AwAB/wMAAf8DAAH/AwAB
/wMAAf8BDQFCAVAB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEpAdEB/AH/AQcBIAEnAf8D
AAH/A1sB3gMEAQXoAAMKAQ0CVwFVAbQB7wGGAQ0B/wH5AaABPwL/AbEBXwL/AbEBYAL/AbIBYAL/
AbIBYQL/AbMBYgL/AbMBYwL/AbMBZAL/AbMBZQL/AbQBZgL/AbQBZwL/AbQBaAL/AbUBaQL/AfcB
7gL/AfsB9wL/AfsB9wL/AfsB9wL/AfsB9wL/AewB2AL/AbgBbwL/AbkBcAL/AbkBcQL/AboBcgL/
AboBcwL/AbsBdAL/AbsBdQL/AbwBdgL/AbwBdwL/Ab0BeAL/Ab0BeAL/Ab4BeQH/AfMBowFbAf8B
4AF5ASsB/wGzAYkBXwH7A10BxQNDAXYDGwEmKAADDAEPAlwBYQHWARkBIQGXAf8BGgEoAaQB/wEc
AS4BsAH/AR0BMwG7Af8BHgE4AcUB/wEgATwBywH/ASABPgHNAf8BIQFAAc0B/wEiAUIBzQH/ASIB
QwHNAf8BIwFFAc0B/wEkAUYBzQH/ASUBSAHOAf8BJgFJAdAB/wEmAUsB0gH/ASYBTAHVAf8BJwFO
AdkB/wEnAU8B3QH/AScBUAHgAf8BJwFRAeMB/wEnAVIB5QH/ASYBUgHnAf8BJgFRAegB/wElAVAB
6QH/ASQBTwHqAf8BJAFMAekB/wEjAUsB6AH/ASIBSAHnAf8BIAFGAeUB/wEfAUMB4AH/AR4BQAHa
Af8BHQE7AdEB/wEcATQBxAH/ARsBLQG1Af8CWwFiAdgDDgESBAIgAAMmATgDAAH/AwAB/wETAWEB
dAH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASEBpQHGAf8BAQEDAQQB/wMAAf8D
AAH/AwAB/wEAAgMB/wEgAaMBxAH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ARoBhQGgAf8D
AAH/AwAB/wM6AWHoAAQBAzsBYwHwAYcBCwH/AfUBlgEqAv8BsQFgAv8BsgFgAv8BsgFhAv8BswFi
Av8BswFjAv8BswFkAv8BswFlAv8BtAFmAv8BtAFnAv8BtQFoAv8BtQFpAv8BtQFqAv8BtgFrAv8B
+gH0Ev8B7gHcAv8BuQFxAv8BugFyAv8BugFzAv8BuwF0Av8BuwF1Av8BvAF2Av8BvAF3Av8BvQF4
Av8BvQF4Av8BvgF5Av8BvgF6Av8BvgF7Av8BvgF8Af8B6wGSAUkB/wHgAXkBKwH/AX8BdQFwAe8D
UwGlAzQBUwMJAQskAANTAacBGAEfAZQB/wEaAScBowH/ARwBLQGwAf8BHAEzAbwB/wEeATgBxgH/
AR8BPAHLAf8BIAE9AcwB/wEgAT4BygH/ASEBPwHKAf8BIQE+AcgB/wEhAT4BxgH/ASABPAHGAf8B
HwE7AccB/wEeATkByAH/AR4BOQHKAf8BHQE5Ac0B/wEdATkB0AH/AR0BOwHUAf8BHQE9AdgB/wEd
AT4B2wH/AR0BQAHfAf8BHgFCAeEB/wEgAUQB5AH/ASEBRwHlAf8BIgFJAecB/wEjAUsB5wH/ASMB
SwHnAf8BIwFKAecB/wEiAUkB5QH/ASEBRwHkAf8BIAFFAeEB/wEfAUEB3QH/AR0BPQHUAf8BHAE3
AcoB/wEbATEBvAH/ARkBKQGsAf8CUgFUAagEASQAA1YBsgMAAf8BAQEIAQkB/wEmAb4B5QH/ASoB
1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/AR0BlQGzAf8BBgEfASUB/wMAAf8BBgEeASUB
/wEdAZQBsgH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASkB0AH6Af8BBgEdASMB/wMAAf8D
XgHaAwMBBOgAAw4BEgFuAWUBWgHiAfIBiwESAf8B/gGvAVsC/wGyAWEC/wGzAWIC/wGzAWMC/wGz
AWQC/wGzAWUC/wG0AWYC/wG0AWcC/wG1AWgC/wG1AWkC/wG2AWoC/wG2AWsC/wG2AWwC/wG3AWwC
/wH5AfMS/wHtAdoC/wG6AXMC/wG7AXQC/wG7AXUC/wG8AXYC/wG8AXcC/wG9AXgC/wG9AXkC/wG+
AXkC/wG+AXoC/wG+AXsC/wG+AXwC/wG/AX0C/wG/AX4B/wH9AbsBeQH/AeMBfwEyAf8ByAGAAUkB
/gNhAdEDRgF9Ax0BKSAAAzUBVgEXAR0BjwH/ARkBJQGgAf8BGwEsAa8B/wEcATIBvAH/AR4BOAHG
Af8BHwE7AcwB/wEeATsBywH/AR4BOQHHAf8BHQE2AcIB/wEbATMBwAH/ARoBMQHAAf8BGQEwAcEB
/wEZATABwwH/ARkBMAHFAf8BGQExAcgB/wEZATIBywH/ARoBMwHNAf8BGgE0AdAB/wEaATUB0wH/
ARoBNwHXAf8BGgE4AdoB/wEaATkB3AH/ARoBOgHeAf8BGgE6AeAB/wEbATsB4QH/ARsBOwHiAf8B
GwE8AeMB/wEcAT4B4wH/AR0BQAHjAf8BHgFCAeIB/wEfAUMB4QH/ASABRAHgAf8BHwFCAd0B/wEe
AT4B1wH/AR0BOQHOAf8BHAEzAcIB/wEaAS0BswH/ARgBJAGiAf8DNQFWJAADIQEvAxQB/QMAAf8B
EQFYAWoB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEpAdAB
+gH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ARkBgQGbAf8DAAH/AwAB
/wM4AVvsAAJDAUIBdQHxAYgBCQH/AfkBogE/Av8BswFiAv8BswFjAv8BswFlAv8BswFlAv8BtAFm
Av8BtAFnAv8BtQFoAv8BtQFpAv8BtgFqAv8BtgFrAv8BtwFsAv8BtwFsAv8BuAFtAv8BuAFuAv8B
+AHyEv8B7AHYAv8BuwF1Av8BvAF2Av8BvAF3Av8BvQF4Av8BvQF5Av8BvgF6Av8BvgF7Av8BvgF7
Av8BvgF8Av8BvwF9Av8BvwF+Av8BwAF/Av8BwAGAAv8BwQGCAf8B8wGkAV8B/wHgAXkBKwH/AYcB
eQFwAfEDUgGkAzEBTgMGAQcYAAMJAQwCWQFlAeQBGQEiAZwB/wEaASoBrQH/ARwBMQG6Af8BHQE2
AcUB/wEdATgBygH/ARwBNgHIAf8BGwExAcIB/wEaAS4BvgH/ARkBLQG9Af8BIAE8AcUB/wExAV8B
2QH/AS0BWAHVAf8BGgEzAckB/wEZATIBywH/ARkBMwHNAf8BGQE0Ac8B/wEaATQB0QH/ARoBNQHT
Af8BGgE2AdUB/wEaATcB2AH/ARoBOAHaAf8BGgE5AdwB/wEaATkB3QH/ARoBOgHeAf8BGgE6Ad8B
/wEaAToB3wH/ASsBWAHkAf8BMgFlAegB/wElAU8B4gH/ARoBOgHeAf8BGwE6Ad0B/wEcATsB2wH/
AR0BPQHaAf8BHQE+AdgB/wEdATsB0QH/ARwBNQHGAf8BGwEvAbkB/wEaASgBqgH/AlkBaAHkAwkB
DCQAA1MBpwMAAf8BAQEFAQYB/wEkAbgB3gH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB
1AL/ASoB0wH+Af8BJwHEAesB/wEqAdQB/gH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASkB
zwH5Af8BBQEaAR8B/wMAAf8DXgHVAwIBA+gAAwYBBwFtAWYBWwHgAfMBjgEVAv8BsgFiAv8BswFl
Av8BswFmAv8BtAFmAv8BtAFnAv8BtQFoAv8BtQFpAv8BtgFqAv8BtgFsAv8BtwFsAv8BtwFtAv8B
uAFtAv8BuAFuAv8BuQFvAv8BuQFwAv8B+AHwEv8B6wHWAv8BvAF3Av8BvQF4Av8BvQF5Av8BvgF6
Av8BvgF7Av8BvgF8Av8BvgF8Av8BvwF9Av8BvwF+Av8BwAF/Av8BwAGBAv8BwQGCAv8BwQGDAv8B
wgGEAf8B/gHBAYIB/wHkAYIBNgH/AccBgAFJAf4DXwHIA0EBcAMTARoYAANEAXsBFwEfAZUB/wEZ
ASgBqQH/ARsBLwG3Af8BHAEzAcIB/wEbATQBxwH/ARoBMQHFAf8BGQEuAb8B/wEZAS0BvwH/ARkB
LgHAAf8BIQE+AccB/wFuAZAB7QH/AfIB9AH+Af8BzwHZAfsB/wE/AWsB4gH/ARsBNwHSAf8BGgE2
AdMB/wEaATYB1QH/ARoBNwHXAf8BGgE3AdcB/wEaATcB2QH/ARoBOAHaAf8BGgE4AdsB/wEaATkB
3AH/ARoBOQHdAf8BGgE5Ad0B/wEaATkB3QH/ATABXQHkAf8BtQHGAfgB/wH5AfoB/gH/AY4BqQH0
Af8BJgFOAd4B/wEaATcB2AH/ARoBNwHXAf8BGgE2AdUB/wEbATcB1AH/ARwBOAHRAf8BHAE2AcoB
/wEbATEBvgH/ARoBKwGwAf8BGQEjAZ8B/wNEAXokAAMbASYDHgH7AwAB/wEQAU8BXwH/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB
1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASQBtwHcAf8BBwEiASkB/wMAAf8BBwEmAS0B/wElAbsB4AH/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB
1AL/ASoB1AL/ASoB1AL/ASoB1AL/ARkBfAGVAf8DAAH/AwAB/wM1AVbsAAMwAUsB8gGJAQcB/wH5
AaABOwL/AbMBZgL/AbQBZwL/AbQBaAL/AbUBaAL/AbUBaQL/AbYBawL/AbYBbAL/AbcBbAL/AbcB
bQL/AbgBbgL/AbgBbwL/AbkBbwL/AbkBcQL/AboBcgL/AboBcwL/AcoBkgL/AcwBmAL/Ac4BmwL/
Ac8BnQL/AdABnwL/AcsBlAL/Ab0BeQL/Ab4BegL/Ab4BewL/Ab4BfAL/Ab8BfQL/Ab8BfgL/Ab8B
fgL/AcABgAL/AcABgQL/AcEBggL/AcEBgwL/AcIBhAL/AcIBhAL/AcMBhQL/AcMBhgH/AfEBogFd
Af8B4AF5ASsB/wFrAWkBZwHkA0sBjQMkATQUAAMHAQkCVgFtAesBGQElAaIB/wEaASsBswH/ARoB
LwG9Af8BGQEwAcMB/wEZATABxAH/ARkBLgHAAf8BGQEuAcAB/wEZAS8BwgH/AR4BOQHIAf8BbwGQ
Ae0B/wH5AfoK/wHXAd8B/AH/AT8BbAHmAf8BGwE5AdsB/wEaATkB3AH/ARoBOQHcAf8BGgE5Ad0B
/wEaATkB3QH/ARoBOQHeAf8BGgE5Ad4B/wEaATkB3QH/ARoBOQHdAf8BGgE5Ad0B/wEwAV0B5AH/
AbwBywH5Df8BkAGrAfQB/wEjAUYB2AH/ARoBNQHTAf8BGgE1AdIB/wEaATQB0QH/ARoBNAHPAf8B
GgEzAcoB/wEaATEBwAH/ARoBLAG1Af8BGQEmAaUB/wFWAVgBbwHrAwcBCSQAA1ABnQMAAf8BAQID
Af8BIwGyAdYB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC
/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEMAT8BTAH/AwAB/wMAAf8DAAH/AQ4BRgFV
Af8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8B
KgHUAv8BKgHUAv8BKgHUAv8BKQHNAfcB/wEEARcBGwH/AwAB/wNdAdEEAuwAAlIBUQGhAfMBiQEI
Af8B/gGwAV4C/wG0AWgC/wG1AWkC/wG1AWoC/wG2AWsC/wG2AWwC/wG3AWwC/wG3AW0C/wG4AW4C
/wG4AW8C/wG5AXAC/wG5AXEC/wG6AXIC/wG6AXMC/wG7AXQC/wG7AXUC/wG8AXYC/wG8AXcC/wG9
AXgC/wG9AXgC/wG9AXkC/wG+AXoC/wG+AXsC/wG+AXwC/wG/AX0C/wG/AX4C/wHAAX8C/wHAAYAC
/wHAAYEC/wHBAYIC/wHBAYMC/wHCAYQC/wHCAYQC/wHDAYUC/wHDAYYC/wHEAYcC/wHEAYgB/wH8
Ab4BgAH/AeABegEsAf8BkwF2AVoB9QNTAacDMQFMAwQBBRAAAzoBYAEXAR8BmQH/ARkBKAGsAf8B
GQErAbcB/wEZAS4BvwH/ARkBMAHEAf8BGQEvAcIB/wEZAS8BwgH/ARkBMAHEAf8BGQExAcgB/wEo
AUkB2QH/AfUB9wH+Ef8B1wHfAfwB/wE/AW4B6gH/ARwBPgHjAf8BGgE8AeMB/wEaATwB4wH/ARoB
OwHjAf8BGgE7AeIB/wEaATsB4QH/ARoBOwHgAf8BGgE6Ad8B/wEwAV0B5QH/AbwBywH5Ef8B/gP/
AUsBaAHiAf8BGQEzAc0B/wEaATMBzgH/ARoBMwHOAf8BGQEzAc4B/wEZATIBywH/ARkBLgHAAf8B
GQErAbUB/wEZAScBqQH/ARcBHwGYAf8DOgFgJAADFwEfAyoB+AMAAf8BDgFGAVQB/wEqAdQC/wEq
AdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC
/wEqAdQC/wEqAdQC/wEEARQBGAH/AwAB/wMAAf8DAAH/AQUBHAEiAf8BKgHUAv8BKgHUAv8BKgHU
Av8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8B
GAF4AZAB/wMAAf8DAAH/AzMBUOwABAEBdwFrAVUB5wH2AZMBHQL/AbUBaQL/AbUBagL/AbYBawL/
AbYBbAL/AbcBbAL/AbcBbQL/AbgBbgL/AbgBbwL/AbkBcAL/AbkBcQL/AboBcgL/AboBcwL/AbsB
dAL/AbsBdQL/AbwBdgL/AbwBdwL/Ab0BeAL/Ab0BeAL/Ab4BeQL/Ab4BegL/Ab4BewL/Ab4BfAL/
Ab8BfQL/Ab8BfgL/AcABfwL/AcABgAL/AcEBgQL/AcEBggL/AcEBgwL/AcIBhAL/AcIBhAL/AcMB
hQL/AcMBhgL/AcQBhwL/AcQBiAL/AcUBiQL/AcUBigL/AcYBiwH/AecBiwFBAf8BvwGAAUAB/QNa
Ab0DOgFhAwsBDhAAAlgBWgG9ARgBIwGiAf8BGAEoAa8B/wEZASwBuwH/ARkBLwHDAf8BGQEvAcMB
/wEZAS8BwwH/ARkBMAHGAf8BGQEyAcoB/wEZATMBzwH/AR8BPAHZAf8B3gHkAfwV/wHXAd8B/AH/
AUABbwHtAf8BHAFBAeoB/wEbAT8B6gH/ARsBPgHpAf8BGwE+AegB/wEbAT0B5wH/ARsBPQHlAf8B
MAFeAegB/wG8AcsB+RX/AfQB9QH+Af8BNAFOAdkB/wEaATEByAH/ARkBMgHKAf8BGQEyAcwB/wEZ
ATIBzAH/ARkBMgHLAf8BGQEvAcMB/wEYASoBtgH/ARgBJQGoAf8BGAEgAZsB/wJYAVoBvSgAA00B
kgMAAf8BAAIBAf8BIgGrAc0B/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdMB/gH/AQEBBAEFAf8DAAH/AwAB/wMAAf8B
AwENARAB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wEqAdQC/wEqAdQC/wEoAcwB9QH/AQQBFAEYAf8DAAH/A1wBzAQB7AADGgEkAfQBigEFAf8B
+QGfATcC/wG2AWsC/wG2AWwC/wG3AWwC/wG4AW0C/wG4AW4C/wG4AW8C/wG5AXAC/wG5AXEC/wG6
AXIC/wG6AXMC/wG7AXQC/wG7AXUC/wG8AXYC/wG8AXcC/wG9AXgC/wG/AX0C/wHFAYkC/wHFAYoC
/wHGAYoC/wHGAYsC/wHGAYwC/wHGAYwC/wHAAX8C/wHAAYAC/wHBAYEC/wHBAYIC/wHCAYMC/wHC
AYQC/wHCAYQC/wHDAYUC/wHDAYYC/wHEAYcC/wHEAYgC/wHFAYkC/wHFAYoC/wHGAYsC/wHGAYwC
/wHHAY0B/wHvAZ8BWwH/AeABeQEqAf8DYQHPA0EBcQMSARgMAAMOARIBJAEnAX0B+gEYASQBpgH/
ARgBKQG0Af8BGQEuAb8B/wEZAS8BxAH/ARkBMAHEAf8BGQExAccB/wEZATIBywH/ARkBNAHRAf8B
GgE2AdUB/wEaATgB2wH/ATkBVgHoAf8B4wHoAf0V/wHXAd8B/AH/AUEBcwHuAf8BIQFJAewB/wEf
AUYB7AH/AR4BQwHsAf8BHAFBAewB/wExAWAB7AH/AbwBywH5Ff8B9AH2Af4B/wFTAWoB5QH/ARkB
MgHKAf8BGQEwAcUB/wEZATABxQH/ARkBMQHIAf8BGQEyAcoB/wEZATEBygH/ARkBMAHFAf8BGAEr
AbkB/wEYASUBqQH/ARcBHwGaAf8CJAF9AfoDDgESJAADEgEYAzkB9AMAAf8BDAE9AUoB/wEqAdQC
/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wEnAccB7wH/AwAB/wMAAf8DAAH/AwAB/wEAAQEBAgH/ASoB0gH8Af8BKgHUAv8BKgHUAv8B
KgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BFwFzAYoB/wMA
Af8DAAH/AzABS/AAAzMBUgH0AYoBBAH/AfsBqQFNAv8BtwFsAv8BuAFtAv8BuAFuAv8BuAFvAv8B
uQFwAv8BuQFxAv8BugFyAv8BugFzAv8BuwF0Av8BuwF1Av8BvAF2Av8BvAF3Av8BvQF4Av8BvQF4
Av8BvgF5Av8B0AGgFv8B/AH5Av8BwQGBAv8BwQGCAv8BwgGDAv8BwgGEAv8BwwGEAv8BwwGFAv8B
wwGGAv8BxAGHAv8BxAGIAv8BxQGJAv8BxQGKAv8BxgGLAv8BxwGMAv8BxwGNAv8BxwGOAv8ByAGP
Af8B9QGwAXEB/wHgAXkBKgH/AWcBZgFiAdwDRgF+AxgBIQwAAzMBUQEXAR8BmgH/ARgBJgGrAf8B
GQEsAboB/wEZAS8BwgH/ARkBMAHEAf8BGQExAccB/wEZATMBzAH/ARoBNAHRAf8BGgE3AdcB/wEa
ATkB3QH/ARsBOwHjAf8BGwE9AegB/wE6AVoB7gH/AeMB6AH9Ff8B1wHfAfwB/wFEAXgB7gH/ASgB
VQHtAf8BJQFQAewB/wE1AWcB7QH/AbwBywH5Ff8B9AH2Af4B/wFTAWsB5wH/ARkBNAHQAf8BGQEy
AcoB/wEZATABxQH/ARkBLwHCAf8BGQEvAcQB/wEZATABxwH/ARkBMQHJAf8BGQEwAccB/wEZASwB
vAH/ARgBJgGtAf8BFwEfAZsB/wEWARkBiwH/AzMBUSgAA0kBhwMAAf8DAAH/ASABowHEAf8BKgHU
Av8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8B
JAG2AdsB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AScBxQHtAf8BKgHUAv8BKgHUAv8BKgHUAv8BKgHU
Av8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKAHKAfMB/wEDAREBFQH/AwAB/wNaAcf0
AANDAXYB9AGKAQQB/wH9AbEBXgL/AbgBbgL/AbkBbwL/AbkBcAL/AbkBcQL/AboBcgL/AboBcwL/
AbsBdAL/AbsBdQL/AbwBdgL/AbwBdwL/Ab0BeAL/Ab0BeAL/Ab4BeQL/Ab4BegL/Ab4BewL/Ac0B
mxr/AccBjgL/AcIBhAL/AcMBhAL/AcMBhQL/AcQBhgL/AcQBhwL/AcQBiAL/AcUBiQL/AcUBigL/
AcYBiwL/AccBjAL/AccBjQL/AcgBjgL/AcgBjwL/AcgBjwL/AckBkAH/AfoBvQGCAf8B4AF5ASkB
/wFsAWgBYwHkA0kBhQMdASgMAANJAYgBFwEiAaEB/wEYASgBsgH/ARkBLQG+Af8BGQEvAcQB/wEZ
ATEBxwH/ARkBMgHMAf8BGgE0AdEB/wEaATcB1wH/ARoBOQHdAf8BGwE8AeQB/wEbAT4B6QH/AR0B
QwHsAf8BIgFMAewB/wFAAWUB7wH/AeQB6AH9Ff8B1wHfAfsB/wFHAX0B7wH/ATwBdAHtAf8BvAHL
AfkV/wH0AfYB/gH/AVMBbAHrAf8BGgE3AdgB/wEZATUB0QH/ARkBMgHMAf8BGQEwAcYB/wEZAS8B
wQH/ARkBLgHAAf8BGQEwAcQB/wEZATABxwH/ARkBMAHHAf8BGQEtAb4B/wEYAScBrwH/ARcBIAGe
Af8BFgEaAY4B/wNJAYgoAAMOARIDRgHvAwAB/wEKATQBPwH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB
1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASEBpgHHAf8DAAH/AwAB/wMA
Af8DAAH/AwAB/wEkAbcB3AH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB
1AL/ASoB1AL/ASoB1AL/ARYBbwGFAf8DAAH/AwAB/wMtAUX0AANMAY4B9AGLAQMB/wH+AbYBagL/
AbkBcAL/AboBcQL/AboBcwL/AboBcwL/AbsBdAL/AbsBdQL/AbwBdgL/AbwBdwL/Ab0BeAL/Ab0B
eQL/Ab4BegL/Ab4BegL/Ab4BewL/Ab4BfAL/Ab8BfQL/AcMBhQL/Af0B+xb/AeYBzQL/AcMBhQL/
AcQBhgL/AcQBiAL/AcUBiQL/AcUBiQL/AcUBigL/AcYBiwL/AccBjAL/AccBjQL/AcgBjgL/AcgB
jwL/AckBkAL/AckBkAL/AckBkQL/AcoBkgH/Af0BxgGOAf8B4AF5ASkB/wF1AWsBYwHpA0oBiQMe
ASsMAAJWAVgBswEXASQBpwH/ARkBKgG2Af8BGQEuAcEB/wEZATABxgH/ARkBMgHLAf8BGgE0Ac8B
/wEaATYB1gH/ARoBOQHcAf8BGwE8AeQB/wEbAT4B6gH/AR4BRQHsAf8BJAFPAewB/wEpAVkB7QH/
AS4BYQHtAf8BRwFxAe8B/wHkAegB/RX/AdYB3gH8Af8BvAHJAfkV/wH0AfYB/gH/AVMBbgHuAf8B
GgE7AeEB/wEaATgB2wH/ARoBNgHVAf8BGQE0Ac4B/wEZATEByAH/ARkBLwHCAf8BGQEuAb8B/wEZ
AS4BwQH/ARkBMAHFAf8BGQEwAcYB/wEZAS0BvwH/ARgBKAGxAf8BFwEiAaEB/wEXARsBkAH/AlYB
WAGzLAADRgF9AwAB/wMAAf8BHgGaAbkB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEeAZUBtAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8BIQGpAcsB
/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEoAcgB8AH/
AQMBDwESAf8DAAH/A1cBwvgAA1ABmgH1AYsBAwL/AbkBcQL/AboBcwL/AbsBdAL/AbsBdQL/AbsB
dQL/AbwBdgL/AbwBdwL/Ab0BeAL/Ab0BeQL/Ab4BegL/Ab4BewL/Ab4BfAL/Ab4BfAL/Ab8BfQL/
Ab8BfgL/AcABfwL/AcABgQL/AeUByhr/AeABwQL/AcUBiQL/AcUBigL/AcYBiwL/AcYBiwL/AccB
jAL/AccBjgL/AcgBjwL/AcgBjwL/AckBkAL/AckBkQL/AcoBkgL/AcoBkgL/AcoBlAL/AcoBlQL/
AcoBlQH/AeEBegEoAf8BdAFoAV0B6gNJAYgDHgEqDAACWwFfAdMBGAEmAawB/wEZASwBugH/ARkB
LwHDAf8BGQExAckB/wEZATMBzgH/ARoBNgHUAf8BGgE4AdsB/wEaATsB4gH/ARsBPgHpAf8BHgFF
AewB/wEkAVAB7AH/ASoBWwHtAf8BMAFlAe0B/wE1AW8B7QH/AToBdwHtAf8BTgF8AfAB/wHkAegB
/Sn/AfQB9gH+Af8BVQFyAfEB/wEcAUAB6wH/ARsBPAHmAf8BGgE6Ad8B/wEaATcB2AH/ARoBNAHR
Af8BGQEyAcsB/wEZAS8BwwH/ARkBLgG/Af8BGQEtAb4B/wEZAS8BwgH/ARkBMAHFAf8BGQEuAcEB
/wEYASkBswH/ARgBIgGiAf8BFwEcAZIB/wJbAV8B0ywAAwoBDQNPAeoDAAH/AQkBLAE1Af8BKgHT
Af4B/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEaAYUB
oAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8BHwGbAboB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEVAWoBfwH/AwAB/wMAAf8DKgFA+AADUAGaAfUBiwEDAv8B
ugFzAv8BuwF1Av8BvAF2Av8BvAF3Av8BvAF3Av8BvQF4Av8BvQF5Av8BvgF6Av8BvgF7Av8BvgF8
Av8BvwF9Av8BvwF+Av8BvwF+Av8BwAGAAv8BwAGBAv8BwQGCAv8BwQGDAv8BxQGJAv8B9AHoGv8B
5QHLAv8BxwGMAv8BxwGNAv8BxwGOAv8ByAGPAv8ByAGPAv8ByQGQAv8ByQGRAv8BygGSAv8BygGT
Av8BygGUAv8BygGVAv8BygGWAv8BywGXAv8BywGXAf8B4QF6ASgB/wF0AWsBXAHnA0gBgwMbASYM
AAFXAVoBbQHnARgBKAGwAf8BGQEtAb0B/wEZATABxQH/ARkBMgHLAf8BGgE1AdEB/wEaATcB2AH/
ARoBOgHfAf8BGwE9AecB/wEdAUMB7AH/ASQBTwHsAf8BKgFbAe0B/wExAWYB7QH/ATcBcQHtAf8B
PQF8Ae0B/wFCAYUB7gH/AUcBjAHuAf8BVAGIAfAB/wHkAekB/SH/AfQB9gH+Af8BWgF6AfEB/wEm
AVIB7QH/ASABRwHsAf8BGwE/AeoB/wEbATwB5AH/ARoBOQHcAf8BGgE2AdQB/wEZATMBzQH/ARkB
MAHFAf8BGQEuAb8B/wEZAS0BvQH/ARkBLgHBAf8BGQEwAcQB/wEZAS8BwgH/ARgBKgG1Af8BGAEj
AaQB/wEXARwBkwH/AlcBagHnMAADQQFyAwAB/wMAAf8BHQGRAa4B/wEqAdQC/wEqAdQC/wEqAdQC
/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEXAXQBjAH/AwAB/wMAAf8DAAH/AwAB/wMA
Af8BHAGNAakB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEnAcUB
7QH/AQIBDAEPAf8DAAH/A1gBvfwAA0wBjgH1AYsBAgH/Af4BuQFwAv8BvAF3Av8BvQF4Av8BvQF4
Av8BvQF5Av8BvgF6Av8BvgF7Av8BvgF8Av8BvwF9Av8BvwF+Av8BwAF/Av8BwAGAAv8BwAGBAv8B
wQGCAv8BwQGDAv8BwgGEAv8BwgGEAv8BwwGFAv8ByQGSAv8B9gHtGv8B6AHPAv8ByAGPAv8ByAGP
Av8ByQGQAv8ByQGRAv8BygGSAv8BygGTAv8BygGUAv8BygGVAv8BywGWAv8BywGXAv8BywGYAv8B
zAGZAf8B/QHIAZQB/wHhAXoBJwH/AWsBZwFiAeEDRAF5AxYBHgwAAU0BUQF5AfEBGAEpAbMB/wEZ
AS4BwAH/ARkBMQHIAf8BGQEzAc4B/wEaATYB1QH/ARoBOQHcAf8BGwE8AeQB/wEcAUAB6wH/ASIB
SwHsAf8BKQFYAe0B/wEwAWUB7QH/ATcBcQHtAf8BPgF9Ae0B/wFEAYgB7gH/AUoBkgHuAf8BTgGb
Ae4B/wFSAaIB7gH/AVsBlAHwAf8B5AHoAf0Z/wH0AfYB/gH/AV8BhAHxAf8BMgFnAe0B/wEsAVwB
7QH/ASUBTwHsAf8BHgFDAewB/wEbAT0B5wH/ARoBOgHgAf8BGgE3AdgB/wEaATQBzwH/ARkBMQHI
Af8BGQEuAcAB/wEZAS0BvQH/ARkBLgHAAf8BGQEwAcQB/wEZAS8BwwH/ARgBKgG2Af8BGAEjAaUB
/wEXAR0BlAH/Ak0BcgHxMAADBgEIA1UB5AMAAf8BBwEkASwB/wEqAdIB/QH/ASoB1AL/ASoB1AL/
ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ARQBZAF4Af8DAAH/AwAB/wMAAf8DAAH/AwAB
/wEZAX4BmAH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ARQBZQF6
Af8DAAH/AwAB/wMnATr8AANDAXYB9QGMAQEB/wH9AbUBZgL/Ab0BeAL/Ab4BeQL/Ab4BegL/Ab4B
ewL/Ab4BfAL/Ab8BfQL/Ab8BfgL/AcABfwL/AcABgAL/AcEBgQL/AcEBggL/AcEBgwL/AcIBhAL/
AcIBhAL/AcMBhQL/AcMBhgL/AcQBhwL/AcQBiAL/AcoBlAL/AfQB6Rr/AeABwAL/AckBkQL/AcoB
kgL/AcoBkwL/AcoBlAL/AcoBlQL/AcsBlgL/AcsBlwL/AcsBmAL/AcwBmQL/AcwBmgL/Ac0BmwH/
AfsBwQGKAf8B4QF6AScB/wNjAdUDPgFrAw8BFAwAAUwBTwF0Ae8BGAEqAbUB/wEZAS8BwQH/ARkB
MQHKAf8BGgE0AdAB/wEaATcB2AH/ARoBOgHgAf8BGwE9AegB/wEeAUUB7AH/ASYBUwHsAf8BLQFg
Ae0B/wE1AW0B7QH/AT0BewHtAf8BRAGIAe4B/wFLAZQB7gH/AVABngHuAf8BVgGoAe8B/wFaAbEB
7wH/AWABpwHwAf8BwAHKAfoZ/wHbAeEB/AH/AU0BhAHvAf8BOQF0Ae0B/wExAWUB7QH/ASoBWAHt
Af8BIgFLAewB/wEcAT8B6gH/ARsBOwHjAf8BGgE4AdoB/wEaATUB0gH/ARkBMgHKAf8BGQEvAcIB
/wEZAS4BvgH/ARkBLgG/Af8BGQEwAcQB/wEZAS8BxAH/ARgBKgG3Af8BGAEjAaQB/wEXAR0BlAH/
AkwBbQHvNAADPQFnAwAB/wMAAf8BGwGIAaQB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC
/wEqAdQC/wEqAdQC/wERAVMBZAH/AwAB/wMAAf8DAAH/AwAB/wMAAf8BFgFwAYcB/wEqAdQC/wEq
AdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEnAcMB6gH/AQIBCgEMAf8DAAH/A1gBt/8AAQAD
MwFSAfYBjAEBAf8B/AGvAVUC/wG+AXoC/wG+AXsC/wG+AXwC/wG/AX0C/wG/AX4C/wHAAX8C/wHA
AYAC/wHBAYEC/wHBAYIC/wHCAYMC/wHCAYQC/wHCAYQC/wHDAYUC/wHDAYYC/wHEAYcC/wHEAYgC
/wHFAYkC/wHFAYoC/wHGAYsC/wHKAZMC/wHzAecW/wH9AfwC/wHRAaEC/wHKAZQC/wHKAZUC/wHL
AZYC/wHLAZcC/wHMAZgC/wHMAZkC/wHMAZoC/wHNAZsC/wHOAZsC/wHOAZwB/wH2AbUBeQH/AeIB
egEmAf8DWgHCAzYBWQMIAQoMAAFaAVsBZwHjARgBKwG3Af8BGQEvAcIB/wEZATIBzAH/ARoBNQHT
Af8BGgE4AdoB/wEbATsB4gH/ARsBPwHqAf8BIgFLAewB/wEpAVkB7QH/ATIBaAHtAf8BOQF1Ae0B
/wFBAYMB7QH/AUkBkQHuAf8BUAGeAe4B/wFXAaoB7wH/AV0BtgHvAf8BZQGsAfAB/wHBAc4B+iH/
AdcB3wH8Af8BTgGHAe8B/wE2AW8B7QH/AS0BXwHtAf8BJQFRAewB/wEeAUMB7AH/ARsBPQHmAf8B
GgE5Ad0B/wEaATYB1QH/ARkBMwHNAf8BGQEwAcUB/wEZAS4BwAH/ARkBLgG/Af8BGQEwAcQB/wEZ
AS8BwwH/ARkBKwG3Af8BGAEjAaQB/wEXARwBkwH/AVoBWwFlAeI0AAMEAQUDWwHcAwAB/wEGAR4B
JAH/ASkB0AH6Af8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BDQFDAVEB/wMA
Af8DAAH/AwAB/wMAAf8DAAH/ARMBYgF2Af8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8B
KgHUAv8BEwFhAXQB/wMAAf8DCgH+AyQBNf8AAQACGgEZASMB9gGMAQAB/wH6AaQBPQL/Ab4BfAL/
Ab8BfQL/Ab8BfgL/AcABfwL/AcABgAL/AcEBgQL/AcEBggL/AcIBgwL/AcIBhAL/AcMBhAL/AcMB
hQL/AcMBhgL/AcQBhwL/AcQBiAL/AcUBiQL/AcUBigL/AcYBiwL/AccBjAL/AccBjQL/AccBjgL/
Ac0BmQL/AfsB9hb/AecBzwL/AcsBlgL/AcsBlwL/AcwBmAL/AcwBmQL/Ac0BmgL/Ac0BmwL/Ac4B
mwL/Ac4BnAL/Ac8BnQL/Ac8BngH/AfABpAFhAf8B4gF7ASYB/wNTAaUDLAFDAwIBAwwAAlwBXwHL
ARgBKwG4Af8BGQEwAcQB/wEZATMBzQH/ARoBNgHVAf8BGgE5Ad0B/wEbAT0B5QH/AR0BQgHsAf8B
JQFPAewB/wEtAV4B7QH/ATUBbgHtAf8BPgF8Ae0B/wFGAYsB7QH/AU4BmQHuAf8BVQGnAe4B/wFc
AbUB7wH/AWYBrgHwAf8BwQHOAfop/wHXAd8B/AH/AUsBhAHvAf8BMQFmAe0B/wEoAVYB7QH/ASAB
SAHsAf8BGwE+AekB/wEaAToB4AH/ARoBNwHXAf8BGQE0Ac8B/wEZATEBxwH/ARkBLwHBAf8BGQEu
AcAB/wEZATABxQH/ARkBLwHDAf8BGQEqAbYB/wEXASIBowH/ARcBHAGRAf8CXAFfAcs4AAM4AV0D
AAH/AwAB/wEZAX8BmQH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/AQoBMwE9
Af8DAAH/AwAB/wMAAf8DAAH/AwAB/wERAVQBZQH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASoB
1AL/ASYBwAHnAf8BAgEIAQoB/wMAAf8DVQGx/wAJAAF3AWoBVwHmAfgBmAEeAv8BvwF+Av8BwAF/
Av8BwAGAAv8BwQGBAv8BwQGCAv8BwgGDAv8BwgGEAv8BwwGEAv8BwwGFAv8BxAGGAv8BxAGHAv8B
xAGIAv8BxQGJAv8BxQGKAv8BxgGLAv8BxwGMAv8BxwGNAv8ByAGOAv8ByAGPAv8ByAGPAv8ByQGQ
Av8B5AHHFv8B9QHrAv8BzAGYAv8BzAGZAv8BzQGaAv8BzQGbAv8BzgGcAv8BzgGdAv8BzwGdAv8B
zwGeAv8B0AGfAv8B0AGgAf8B6QGPAUEB/wGnAW8BRwH3A0cBggMdASkQAAJSAVQBqAEYASsBuQH/
ARkBMAHFAf8BGQEzAc4B/wEaATcB1gH/ARoBOgHfAf8BGwE9AecB/wEeAUUB7AH/AScBUwHtAf8B
LwFiAe0B/wE4AXIB7QH/AUABgQHuAf8BSQGRAe0B/wFRAaAB7gH/AVoBrwHvAf8BZAGsAfAB/wHB
Ac4B+hX/AfQB9gH+Af8B5QHpAf0V/wHXAd8B/AH/AUkBfwHvAf8BKwFcAe0B/wEhAUsB7AH/ARsB
PwHqAf8BGwE7AeIB/wEaATcB2QH/ARoBNAHQAf8BGQExAckB/wEZAS8BwgH/ARkBLgHBAf8BGQEw
AcUB/wEZAS8BwgH/ARkBKgG1Af8BFwEiAaEB/wEXARsBjwH/A1MBpzgAAwIBAwNdAdQDAAH/AQQB
GAEcAf8BKQHNAfcB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEHASIBKQH/AwAB/wMA
Af8DAAH/AwAB/wMAAf8BDgFGAVQB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wESAVwB
bwH/AwAB/wMKAf4DIQEw/wAJAAJRAVABnQH2AY0BAgH/Af4BuwF1Av8BwQGCAv8BwQGCAv8BwgGD
Av8BwgGEAv8BwwGEAv8BwwGFAv8BxAGGAv8BxAGIAv8BxQGJAv8BxQGJAv8BxQGKAv8ByQGRAv8B
xwGMAv8BxwGNAv8ByAGOAv8ByAGPAv8ByQGQAv8ByQGQAv8ByQGRAv8BygGSAv8B2wG2Fv8B+gH2
Av8BzQGaAv8BzQGbAv8BzgGcAv8BzgGdAv8BzwGeAv8BzwGfAv8B0AGfAv8B0AGgAv8B0QGhAf8B
/AHJAZcB/wHjAX0BJQH/AWIBYQFcAdkDOwFiAw0BERAAA0QBeQEYASsBuQH/ARkBMAHFAf8BGgE0
Ac8B/wEaATcB1wH/ARoBOgHgAf8BGwE+AegB/wEgAUcB7AH/ASkBVgHtAf8BMQFlAe0B/wE5AXUB
7QH/AUMBhQHuAf8BSwGVAe0B/wFUAaUB7gH/AV8BpgHwAf8BwQHOAfoV/wH0AfYB/gH/AZsBsgH2
Af8BhwGsAfQB/wHlAekB/RX/AdcB3wH8Af8BRgF6Ae4B/wEkAU8B7AH/ARwBQAHrAf8BGwE7AeMB
/wEaATgB2gH/ARoBNAHRAf8BGQEyAcoB/wEZAS8BwwH/ARkBLwHBAf8BGQEwAcUB/wEZAS4BwAH/
ARgBKQGyAf8BFwEhAZ4B/wEWARoBjAH/A0QBeTwAAzMBUgMAAf8DAAH/ARcBdgGOAf8BKgHUAv8B
KgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BAwESARUB/wMAAf8DAAH/AwAB/wMAAf8DAAH/AQsBOAFD
Af8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BJgG9AeQB/wEBAQcBCAH/AwAB/wNVAaz/AA0AAy0B
RQH2AYwBAAH/AfsBqQFIAv8BwgGDAv8BwgGEAv8BwwGEAv8BwwGFAv8BxAGHAv8BxAGIAv8BxQGJ
Av8BxQGKAv8BxQGKAv8BxgGLAv8BxwGMAv8B8wHnAv8B4AHAAv8BygGTAv8ByQGQAv8ByQGRAv8B
yQGRAv8BygGSAv8BygGUAv8BygGVAv8B5QHMFv8B+gH1Av8BzgGcAv8BzgGdAv8BzwGeAv8BzwGf
Av8B0AGgAv8B0AGgAv8B0QGhAv8B0QGjAv8B0gGkAf8B8wGrAWoB/wHjAXwBIwH/A1QBqAMqAT8D
AgEDEAADKgE/ARgBKwG4Af8BGQEwAcUB/wEZATQBzwH/ARoBNwHYAf8BGgE7AeEB/wEbAT4B6QH/
ASEBSQHsAf8BKQFYAe0B/wExAWcB7QH/AToBdwHtAf8BRAGHAe4B/wFNAZcB7QH/AVkBnQHvAf8B
wAHOAfoV/wH1AfYB/gH/Aa4BugH4Af8B6wH1Af0B/wG5AeIB+AH/AXYBqAHyAf8B5AHpAf0V/wHX
Ad8B/AH/AUIBdQHuAf8BHQFDAesB/wEbATwB5AH/ARoBOAHbAf8BGgE1AdIB/wEZATIBywH/ARkB
MAHEAf8BGQEvAcIB/wEZATABxgH/ARkBLQG+Af8BGAEnAa8B/wEXAR8BmwH/ARYBGQGJAf8DKQE+
PAAEAQNcAcsDAAH/AQQBEgEWAf8BKAHKAfMB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdMB/QH/AQEC
AwH/AwAB/wMAAf8DAAH/AwAB/wMAAf8BCAEqATIB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wER
AVgBaQH/AwAB/wMUAf0DHwEs/wANAAQCAWkBZAFcAdsB9wGTAREC/wHCAYIC/wHDAYYC/wHEAYcC
/wHEAYgC/wHFAYkC/wHFAYoC/wHGAYsC/wHGAYwC/wHHAYwC/wHHAY4C/wHIAY8C/wH3Ae8G/wH6
AfUC/wHmAcwC/wHVAaoC/wHLAZYC/wHKAZUC/wHMAZoC/wHgAcAC/wH9AfwW/wH0AegC/wHPAZ4C
/wHPAZ8C/wHQAaAC/wHQAaEC/wHRAaIC/wHRAaMC/wHSAaQC/wHSAaUB/wH+AdEBowH/AegBhwEz
Af8BhwFqAVEB8AM/AW0DFAEbFAADBgEHAUsBUAF5AfABGQEvAcQB/wEZATMBzwH/ARoBNwHYAf8B
GgE7AeEB/wEbAT4B6QH/ASABSAHsAf8BKQFXAe0B/wExAWcB7QH/AToBdwHtAf8BRAGHAe4B/wFQ
AZMB7gH/Ab8BzQH6Ff8B9QH2Af4B/wGuAboB+AH/AvwC/wHzAfoB/gH/Ab4B5AH4Af8BgAHLAfIB
/wFjAaAB8AH/AeQB6QH9Ff8B1wHfAfwB/wFAAXAB7gH/ARwBPgHkAf8BGgE4AdsB/wEaATUB0wH/
ARkBMgHLAf8BGQEwAcQB/wEZATABxAH/ARkBMAHEAf8BGQEsAbsB/wEYASYBqwH/ARcBHgGWAf8C
SQFrAfADBgEHQAADLgFHAwAB/wMAAf8BFgFtAYQB/wEqAdQC/wEqAdQC/wEqAdQC/wEpAc4B+AH/
AQEBAwEEAf8DAAH/AwAB/wMAAf8DAAH/AwAB/wEIAScBLwH/ASoB1AL/ASoB1AL/ASoB1AL/ASUB
ugHgAf8BAQEFAQYB/wMAAf8DUwGm/wAVAAM9AWgB9gGMAQAB/wH7Aa4BUgL/AcQBiAL/AcUBiQL/
AcUBigL/AcYBiwL/AcYBjAL/AccBjQL/AccBjgL/AcgBjwL/AcgBjwL/AckBkAL/AfcB7xL/Av4C
/wH7AfgC/wH+Af0e/wHnAc0C/wHQAaAC/wHQAaEC/wHRAaIC/wHRAaMC/wHSAaQC/wHSAaUC/wHT
AaYC/wHTAacB/wH1AbEBcgH/AeQBfQEhAf8DWAGzAysBQQMDAQQYAANSAaMBGQEvAcIB/wEZATMB
zQH/ARoBNwHXAf8BGgE6AeAB/wEbAT4B6QH/AR8BRwHsAf8BKAFWAe0B/wEwAWYB7QH/ATkBdQHt
Af8BQQGDAe4B/wG5AckB+RX/AfUB9gH+Af8BrQG6AfgB/wH7AfwC/wH9Af4C/wHlAfQB/AH/Aa0B
3QH3Af8BeAHIAfEB/wFhAboB7wH/AVwBlwHwAf8B5AHpAf0V/wHWAd4B/AH/AS8BWAHnAf8BGgE4
AdoB/wEaATUB0gH/ARkBMgHLAf8BGQEwAcUB/wEZATABxQH/ARkBLwHDAf8BGAErAbcB/wEYASQB
pgH/ARYBHAGRAf8DUgGjSAADWQHBAwAB/wEDAQ0BEAH/AScBxgHuAf8BKgHUAv8BKgHUAv8BKgHU
Av8BFQFqAX8B/wMAAf8DAAH/AwAB/wMAAf8BAAICAf8BGwGLAacB/wEqAdQC/wEqAdQC/wEqAdQC
/wEQAVMBZAH/AwAB/wMUAfwDHAEn/wAVAAMFAQYBaAFiAVsB3AH3AZEBDAH/Af4BwQGBAv8BxgGL
Av8BxgGMAv8BxwGNAv8BxwGOAv8ByAGPAv8ByAGPAv8ByQGQAv8ByQGRAv8BygGSAv8B9wHwNv8B
+wH3Av8B1AGoAv8B0QGiAv8B0QGjAv8B0gGkAv8B0gGlAv8B0wGmAv8B0wGnAv8B1AGnAf8B/QHO
AZ8B/wHnAYUBLAH/AYIBawFVAe4DOwFjAxEBFhwAAywBQwEZAS4BwAH/ARkBMgHMAf8BGgE2AdYB
/wEaAToB3wH/ARsBPQHnAf8BHgFFAewB/wEnAVMB7QH/AS8BYwHtAf8BNwFyAe0B/wE/AXUB7gH/
Af0B/hL/AfQB9gH+Af8BlQGwAfYB/wHdAe8B/AH/AeoB9gH9Af8B4AHyAfwB/wG+AeQB+QH/AY0B
0AHzAf8BawHBAfAB/wFdAbYB7wH/AVUBpwHuAf8BVgGLAfAB/wHkAegB/RX/AVMBbwHrAf8BGgE4
AdkB/wEaATUB0QH/ARkBMgHLAf8BGQEwAcUB/wEZATABxQH/ARkBLgHAAf8BGAEoAbIB/wEYASIB
oAH/ARYBGgGMAf8DKwFCSAADKQE9AwAB/wMAAf8BFAFlAXkB/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wEeAZUBtAH/AQwBOwFHAf8BBQEbASAB/wENAUABTAH/ASABoQHCAf8BKgHUAv8BKgHUAv8B
KgHUAv8BJAG3AdwB/wEBAQQBBQH/AwAB/wNRAaH/AB0AAzABSwH2AYwBAAH/AfkBoQEzAv8BxwGN
Av8BxwGOAv8ByAGPAv8ByAGPAv8ByQGQAv8ByQGRAv8BygGSAv8BygGTAv8BygGUAv8B9wHwMv8B
/AH6Av8B3AG4Av8B0QGjAv8B0gGkAv8B0gGlAv8B0wGmAv8B0wGnAv8B1AGnAv8B1AGoAv8B1QGp
Af8B7wGdAVEB/wHlAX4BIAH/A08BlwMgAS0EARwABAECXQFhAdEBGQExAckB/wEaATUB0wH/ARoB
OQHdAf8BGwE9AeYB/wEdAUIB7AH/ASQBUAHsAf8BLQFfAe0B/wE1AW0B7QH/AToBdwHtAf8BoQG1
AfcN/wH0AfYB/gH/AXoBpAHzAf8BjwHOAfQB/wGnAdoB9gH/Aa8B3gH3Af8BpQHZAfYB/wGKAc4B
8wH/AXABwwHwAf8BYQG6Ae8B/wFZAa4B7wH/AVEBoAHuAf8BSQGRAe0B/wFQAYAB8AH/AeQB6AH9
Df8BwgHMAfoB/wEgAUAB4gH/ARoBNwHYAf8BGgE0AdAB/wEZATIBygH/ARkBMAHGAf8BGQEwAcQB
/wEZASwBuwH/ARgBJgGsAf8BFwEfAZoB/wJdAWEB0QQBTAADWAG3AwAB/wECAQkBCwH/ASYBwQHo
Af8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8B
KgHUAv8BKgHUAv8BEAFPAV4B/wMAAf8DHgH6AxkBI/8AIQACUQFQAZ8B9gGMAQAB/wH7AbEBWAL/
AcgBjwL/AckBkAL/AckBkQL/AcoBkgL/AcoBkwL/AcoBlAL/AcoBlQL/AcsBlgL/Ad0BugL/Ae8B
3wL/Af0B+yL/Av4C/wHwAeIC/wHYAbAC/wHSAaQC/wHSAaUC/wHTAaYC/wHTAacC/wHUAacC/wHU
AagC/wHVAakC/wHVAaoB/wH1AbQBdAH/AeYBfgEeAf8CXwFcAcgDKgFAAwYBByQAAzQBVAEZATAB
xgH/ARoBNQHRAf8BGgE4AdoB/wEbATsB4wH/ARwBPwHrAf8BIQFLAewB/wEqAVkB7QH/ATIBZwHt
Af8BOQF1Ae0B/wE8AXoB7gH/AaQBuAH3Bf8B9AH2Af4B/wFuAZ0B8gH/AWQBuwHvAf8BcAHCAfEB
/wF4AcYB8QH/AXoBxgHxAf8BdQHEAfEB/wFqAcAB8AH/AWEBuQHvAf8BWgGvAe8B/wFUAaQB7gH/
AU0BmAHtAf8BRQGKAe4B/wE9AXwB7QH/AUkBdAHvAf8B4wHoAf0F/wHCAcwB+gH/ASQBRQHoAf8B
GgE6Ad4B/wEaATYB1gH/ARkBMwHOAf8BGQEyAckB/wEZATABxgH/ARkBLgHBAf8BGAEqAbYB/wEY
ASMBpQH/ARYBHAGTAf8DNAFUUAADIwEzAwoB/gMAAf8BEgFcAW4B/wEqAdQC/wEqAdQC/wEqAdQC
/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEjAbQB2AH/AQECAwH/
AwAB/wNPAZv/ACUAAwkBCwJhAV0B0QH2AY0BBAH/Af0BuQFrAv8BygGSAv8BygGTAv8BygGUAv8B
ygGVAv8BywGWAv8BywGXAv8BzAGYAv8BzAGZAv8BzQGaAv8BzwGdAv8B2QGzAv8B4wHHAv8B6gHV
Av8B7wHeAv8B8AHgAv8B7gHdAv8B6gHUAv8B4gHEAv8B1gGtAv8B0gGkAv8B0gGlAv8B0wGmAv8B
0wGnAv8B1AGnAv8B1AGoAv8B1QGpAv8B1QGrAv8B1gGrAf8B+QG/AYYB/wHoAYEBIAH/AW8BZQFb
AeQDMwFRAwsBDigABAECWgFcAcQBGQEzAc0B/wEaATcB1wH/ARoBOgHgAf8BGwE+AegB/wEfAUUB
7AH/ASYBUwHsAf8BLgFgAe0B/wE1AW4B7QH/ATwBewHtAf8BPwF/Ae4B/wFpAZQB8gH/AVgBjwHw
Af8BVQGnAe4B/wFbAbEB7gH/AV4BtwHvAf8BYQG6Ae8B/wFiAbsB7wH/AWABuQHvAf8BXQG0Ae8B
/wFZAa0B7wH/AVQBpAHuAf8BTgGZAe0B/wFHAY0B7gH/AUABgAHuAf8BOQF0Ae0B/wExAWYB7QH/
ATcBXwHuAf8BXwF6AfIB/wEiAUQB6wH/ARsBPAHjAf8BGgE5AdsB/wEaATUB1AH/ARkBMwHNAf8B
GQExAcgB/wEZATABxAH/ARkBLQG8Af8BGAEnAa4B/wEXASABngH/AlkBXAHDBAFUAANVAawDAAH/
AQEBBgEHAf8BJQG7AeEB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC
/wEqAdQC/wEqAdQC/wEPAUoBWQH/AwAB/wMiAfkDFwEf/wApAAMWAR4BcQFnAVUB5AH2AY4BBwH/
AfwBuQFtAv8BygGWAv8BywGXAv8BywGXAv8BzAGYAv8BzAGZAv8BzQGaAv8BzQGbAv8BzgGcAv8B
zgGdAv8BzwGeAv8BzwGeAv8B0AGfAv8B0AGgAv8B0QGhAv8B0QGiAv8B0gGjAv8B0gGlAv8B0wGm
Av8B0wGmAv8B0wGnAv8B1AGnAv8B1AGoAv8B1QGqAv8B1QGrAv8B1gGsAv8B1gGtAf8B+QG/AYUB
/wHpAYMBIQH/AYUBawFTAe4DOQFdAw4BEjAAAyABLQE5AUABngH4ARoBNQHTAf8BGgE5AdwB/wEb
ATwB5QH/ARwBQAHrAf8BIgFLAewB/wEpAVgB7QH/ATEBZQHtAf8BNwFxAe0B/wE9AX0B7QH/AUQB
iAHuAf8BSQGSAe4B/wFOAZsB7gH/AVIBogHuAf8BVQGnAe4B/wFXAaoB7gH/AVgBqwHuAf8BVwGp
Ae4B/wFUAaQB7gH/AVEBnwHtAf8BTAGWAe4B/wFHAY0B7gH/AUEBggHuAf8BOgF3Ae0B/wEzAWsB
7QH/AS0BXgHtAf8BJgFRAewB/wEeAUQB7AH/ARsBPgHoAf8BGgE6AeAB/wEaATcB2AH/ARoBNQHR
Af8BGQEyAcwB/wEZATABxgH/ARkBLgHAAf8BGQEqAbUB/wEYASQBpgH/ATgBOgF9AfgDHwEsWAAD
HgEqAxQB/AMAAf8BEAFTAWQB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wEqAdQC/wEjAbAB0wH/AQACAgH/AwAB/wNOAZb/ADEAAxwBJwFxAWcBVQHkAfYBjQEEAf8B
+wGyAV0C/wHMAZkC/wHMAZkC/wHNAZoC/wHNAZsC/wHOAZwC/wHOAZ0C/wHPAZ4C/wHPAZ8C/wHQ
AaAC/wHQAaAC/wHRAaEC/wHRAaMC/wHSAaQC/wHSAaUC/wHTAaYC/wHTAacC/wHUAacC/wHUAacC
/wHUAakC/wHVAaoC/wHVAasC/wHWAawC/wHWAa0C/wHWAa4B/wH2AbUBdAH/AegBggEdAf8BggFq
AVQB7QM5AV4DDQEROAACQQFCAXIBGgEzAc4B/wEaATcB1wH/ARoBOgHgAf8BGwE9AegB/wEeAUMB
7AH/ASQBTwHsAf8BKwFbAe0B/wEyAWYB7QH/ATgBcgHtAf8BPQF8Ae0B/wFCAYUB7gH/AUYBjQHu
Af8BSgGTAe4B/wFMAZcB7gH/AU4BmgHuAf8BTgGbAe4B/wFNAZkB7gH/AUsBlQHuAf8BSAGQAe4B
/wFEAYkB7gH/AT8BgAHuAf8BOgF3Ae0B/wEzAWwB7QH/AS4BYQHtAf8BKAFVAe0B/wEhAUgB7AH/
ARsBPwHqAf8BGwE8AeMB/wEaATkB3AH/ARoBNgHVAf8BGQE0Ac4B/wEZATEByQH/ARkBLwHDAf8B
GQEsAboB/wEYAScBrQH/ARcBIQGdAf8CQAFBAXFgAANRAaEDAAH/AQEBAwEEAf8BJAG1AdoB/wEq
AdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEOAUUBUwH/AwAB/wMyAfcD
FQEc/wA1AAMXAR8BYQFeAVwB0gH1AYsBAgH/AfgBowE6Af8B/gHJAZIC/wHOAZwC/wHOAZ0C/wHP
AZ4C/wHPAZ8C/wHQAaAC/wHQAaEC/wHRAaIC/wHRAaMC/wHSAaQC/wHSAaUC/wHTAaYC/wHTAacC
/wHUAacC/wHUAagC/wHVAakC/wHVAaoC/wHVAasC/wHWAawC/wHWAa0C/wHWAa4B/wH+AdEBpQH/
AfEBoAFPAf8B6QGBARkB/wFpAWMBXAHfAzEBTAMJAQs8AAQBAlMBVAGmARoBNQHSAf8BGgE4AdsB
/wEbATsB4wH/ARsBPgHqAf8BHwFGAewB/wElAVEB7AH/ASsBWwHtAf8BMQFlAe0B/wE2AW8B7QH/
AToBdwHtAf8BPgF+Ae4B/wFCAYQB7gH/AUMBiAHuAf8BRQGKAe4B/wFFAYsB7gH/AUQBiQHuAf8B
QwGGAe4B/wFAAYEB7gH/ATwBewHtAf8BNwFzAe0B/wEyAWoB7QH/AS0BYAHtAf8BKAFWAe0B/wEi
AUsB7AH/ARwBQQHrAf8BGwE9AeYB/wEaAToB3wH/ARoBNwHYAf8BGgE1AdEB/wEZATIBzAH/ARkB
MAHFAf8BGQEtAb0B/wEZASkBsgH/ARcBIwGjAf8CUwFUAaYEAWAAAxkBIgMeAfoDAAH/AQ8BSgFZ
Af8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BKgHUAv8BIgGsAc8B/wEAAgEB/wMAAf8D
TAGQ/wA9AAMJAQsDUQGeAfUBiwECAf8B9gGRAREB/wH6AbQBYAL/Ac4BnAL/AdABoAL/AdABoQL/
AdEBogL/AdEBowL/AdIBpAL/AdIBpQL/AdMBpgL/AdMBpwL/AdQBpwL/AdQBqAL/AdUBqQL/AdUB
qgL/AdYBqwL/AdYBrAL/AdYBrQL/AdYBrgL/AdUBrAH/AfcBtQFyAf8B7AGKASQB/wHqAYEBFwH/
AlcBVQG0Ax4BKwMDAQREAAMGAQgCWAFaAb0BGgE1AdUB/wEaATkB3QH/ARsBPAHkAf8BGwE/AeoB
/wEfAUYB7AH/ASUBUAHsAf8BKgFZAe0B/wEvAWIB7QH/ATMBaQHtAf8BNwFwAe0B/wE5AXUB7QH/
ATsBeAHtAf8BPAF6Ae0B/wE8AXsB7QH/ATwBeQHtAf8BOgF2Ae0B/wE3AXIB7QH/ATQBbAHtAf8B
MAFlAe0B/wEsAV0B7QH/AScBVAHtAf8BIQFKAewB/wEdAUEB7AH/ARsBPQHnAf8BGgE7AeEB/wEa
ATgB2gH/ARoBNQHTAf8BGQEzAc0B/wEZATABxwH/ARkBLgHAAf8BGAEqAbUB/wEYASUBqAH/AlgB
WgG9AwYBCGgAA04BlwMAAf8BAAICAf8BIwGuAdEB/wEqAdQC/wEqAdQC/wEqAdQC/wEqAdQC/wEq
AdQC/wENAUEBTgH/AwAB/wMyAfUDEgEY/wBFAAMvAUkBaQFkAVwB2wH0AYsBAwH/AfUBkwEYAf8B
+gGxAVoB/wH+AcsBlQL/AdIBpAL/AdIBpQL/AdMBpgL/AdMBpwL/AdQBpwL/AdQBqAL/AdUBqQL/
AdUBqgL/AdYBqwL/AdYBrAL/AdYBrQL/AdYBrgH/Af0BzwGhAf8B9gGxAWgB/wHuAY0BKAH/AesB
gwEVAf8BbAFlAVwB4gM7AWMDCgENUAADCQEMAlcBWQG8ARoBNgHWAf8BGgE5Ad4B/wEbATwB5AH/
ARsBPwHqAf8BHgFFAewB/wEjAU0B7AH/AScBVAHtAf8BKwFbAe0B/wEuAWEB7QH/ATEBZQHtAf8B
MwFpAe0B/wE0AWsB7QH/ATQBawHtAf8BMwFqAe0B/wEyAWcB7QH/ATABYwHtAf8BLAFeAe0B/wEp
AVcB7QH/ASQBUAHsAf8BHwFIAewB/wEcAUAB6wH/ARsBPQHnAf8BGgE7AeEB/wEaATgB2wH/ARoB
NgHVAf8BGQEzAc4B/wEZATEByQH/ARkBLgHBAf8BGAErAbcB/wEYASYBqwH/A1kBuwMJAQxsAAMU
ARsDLwH2AwAB/wENAUEBTgH/ASoB1AL/ASoB1AL/ASoB1AL/ASoB1AL/ASEBqAHKAf8BAAIBAf8D
AAH/A0oBi/8ATQADBQEGAj4BPQJpAWUBWgHdAfQBigEFAf8B8wGLAQgB/wH2AZsBLQH/AfgBrgFW
Af8B+wG9AXcB/wH9AcgBjwH/Af4B0QGhAv8B1AGpAv8B1QGqAf8B/gHSAaQB/wH8AcoBlAH/AfoB
vQF9Af8B9gGtAV4B/wHxAZgBNgH/Ae0BhQETAf8B7AGEARIB/wFuAWUBXQHhAkQBQwF3Aw8BEwQB
WAADBgEHAlEBUgGhARoBNgHWAf8BGgE5Ad0B/wEbATsB4wH/ARsBPgHoAf8BHAFBAesB/wEgAUcB
7AH/ASQBTQHsAf8BJgFTAewB/wEoAVcB7QH/ASoBWQHtAf8BKwFbAe0B/wErAVsB7QH/ASsBWgHt
Af8BKQFYAe0B/wEnAVQB7QH/ASQBUAHsAf8BIQFKAewB/wEdAUMB7AH/ARsBPwHqAf8BGwE9AeYB
/wEaATsB4QH/ARoBOAHbAf8BGgE2AdUB/wEZATQBzwH/ARkBMQHJAf8BGQEuAcEB/wEYASsBuAH/
ARgBJwGtAf8DUgGgAwYBB3QAA0sBjAMAAf8CAAEBAf8BIQGmAcgB/wEqAdQC/wEqAdQC/wEqAdQC
/wEMATwBSAH/AwAB/wM9AfMDEAEV/wBVAAQCAy0BRQJQAU8BmwF2AWkBWQHlAfIBiQEHAf8B8gGJ
AQgB/wHxAYgBCQH/AfEBiAEKAf8B8AGHAQsB/wHwAYcBDAH/Ae8BhgEMAf8B7wGGAQ0B/wHvAYYB
DgH/Ae4BhQEPAf8BcwFqAVkB5gJRAVABnwIxATABTAMGAQdoAAQBAz0BZwFAAUgBkwH1ARoBOAHb
Af8BGgE6AeEB/wEbATwB5QH/ARsBPgHpAf8BHAFBAesB/wEeAUUB7AH/ASEBSAHsAf8BIgFLAewB
/wEjAUwB7AH/ASMBTAHsAf8BIgFLAewB/wEhAUkB7AH/AR8BRgHsAf8BHQFCAewB/wEbAT8B6gH/
ARsBPQHnAf8BGwE8AeMB/wEaAToB3gH/ARoBOAHZAf8BGgE2AdQB/wEZATQBzgH/ARkBMQHIAf8B
GQEuAcAB/wEYASsBuAH/AUEBRgGBAfQDPQFnBAF4AAMPARQDQQHyAwAB/wELATgBRAH/ASoB1AL/
ASoB1AL/ASABpAHFAf8DAAH/AwAB/wNJAYX/AGkAAhoBGQEjAzQBVAJEAUMBdwNMAY4DUAGaA1AB
mgNMAY4CRAFDAXcDNAFUAxsBJQQBfAABGQIaASMCVgFXAbUBGgE3AdcB/wEaATkB3QH/ARoBOgHh
Af8BGwE8AeQB/wEbAT0B5wH/ARsBPgHpAf8BGwE/AeoB/wEcAUAB6gH/ARwBQAHrAf8BHAE/AeoB
/wEbAT4B6gH/ARsBPQHoAf8BGwE9AeYB/wEbATsB4wH/ARoBOgHfAf8BGgE5AdsB/wEaATcB1wH/
ARoBNAHSAf8BGQEyAcwB/wEZATABxgH/ARkBLQG+Af8BGAEqAbYB/wJWAVcBtQEZAhoBI4QAA0YB
gQMAAf8DAAH/AR8BngG+Af8BKgHUAv8BCwE4AUMB/wMAAf8DQwHwAw4BEv8A/wAaAAMsAUMCWQFc
Ab4BJAFAAcMB/gEaATgB2wH/ARoBOQHeAf8BGgE6AeAB/wEaATsB4gH/ARsBOwHjAf8BGwE7AeMB
/wEaATsB4gH/ARoBOwHhAf8BGgE6Ad8B/wEaATkB3AH/ARoBOAHaAf8BGgE3AdcB/wEaATUB0gH/
ARkBMwHOAf8BGQExAckB/wEZAS8BwwH/ASMBNgGoAf4CWQFcAb4DKwFCjAADDAEPA08B7AMAAf8B
BAEUARgB/wEMATwBSAH/AwAB/wMAAf8DRgGA/wD/ACYAAyABLQJKAUsBiwJdAWcB3AEaATYB1gH/
ARoBNwHXAf8BGgE3AdgB/wEaATcB2QH/ARoBNwHYAf8BGgE3AdcB/wEaATYB1gH/ARoBNQHTAf8B
GgE0AdAB/wEZATMBzQH/ARkBMQHIAf8BGQEvAcMB/wJdAWcB3AJKAUsBiwMgAS2YAANAAXADAAH/
AwAB/wMAAf8DAAH/A1cB5gMMAQ//AP8ALgAEAQMaASMDOAFbA0kBiAJTAVUBqgJZAVsBwAJcAV8B
ywJcAV8BywJZAVsBwAJTAVUBqgNJAYgDOAFbARkCGgEjBAGkAAM/AW4DXAHhAyoB+ANYAbcDGwEl
/wD/AP8AAwAEAQQCAwQBBQMGAQcDBgEIAwcBCQMGAQgDBQEGAwIBAwQBnAADAgEDAwkBCwMRARYD
GQEiAx4BKwMiATEDIgExAx4BKwMZASIDEQEWAwkBCwMCAQP/AP8AIgADAgEDAwgBCgMOARIDFQEc
AxsBJQMhATADLwFJAzYBVwExAjABTAMrAUEDIQEvAx0BKQMYASADEgEXAwoBDQMEAQUEAYAAAwUB
BgMTARoDKQE+AzoBYgNGAX4DTgGVA1IBqANVAbQDWQG7A1kBuwNVAbQDUgGoA04BlQNGAX4DOgFi
AykBPgMTARoDBQEG/wD/AAoABAEDBgEIAxABFQMbASYCUwFRAaIBxgFlAS8B/wHTAW4BOAH/AdwB
dwFCAf8B3QF7AUYB/wHfAYABSwH/AeABhQFPAf8B4QGKAVMB/wHjAY4BWAH/AeQBkwFcAf8B5gGY
AWAB/wHZAYIBRwH/AdEBbwEyAf8CQAE/AW4DHwEsAxQBGwMJAQwDAgEDbAAEAQMJAQsDIwEzAz4B
agNPAZkDWgHEA2YB4AN7AfQDpAH+A78B/wPCAf8DwwH/A8MB/wPAAf8DvAH/A6AB/gN6AfQDZgHg
A1oBxANPAZkDPgFqAyMBMwMJAQsEAWAAGAEoAiwBUACIAVAABAEDBgEIAxMBGgNKAYkByAFkASwB
/wHXAWsBMAH/AdgBbQEzAf8B2gFwATAB/wHbAXIBMQH/AdwBdQE0Af8B3gF4ATYB/wHfAXsBOAH/
AeEBfgE6Af8B4gGBATwB/wHjAYMBPgH/AeUBhwFAAf8B5wGKAUIB/wHoAY0BRQH/AeoBlgFTAf8B
6wGnAW4B/wHrAacBbQH/AdUBcgEzAf8DKwFCAxkBIwMLAQ4DAgEDYAADBgEHAyMBMwNDAXcDWAG3
A2kB5QKkAaUB/gPJAf8DzQH/A80B/wPMAf8DywH/A8oB/wPJAf8DxwH/A8cB/wPGAf8DxAH/A8QB
/wPCAf8DvgH/Ap0BngH+A2kB5QNYAbcDQwF3AyMBMwMGAQdcAAQBAwQBBQMEAQUDAgEDAwIBAwMC
AQMDAgQDBAQEBQEGAwQBBQMDAQQDAgEDAwIBAwMCAQMDAgEDBwIBAwMCAQMDAgEDAwIBAwgCEAFA
AAQCAwsBDgMYBCEBLwMmATgDJwE6AycBOgMnAToDJwE6AycBOgMnAToDJwE6AycBOgMnAToDJwE6
AycBOgMnAToDJwE6AycBOgMnAToDJwE6AycBOgMnAToDJwE6AycBOgMnAToDJwE6AycBOgMnAToD
JwE6AycBOgMnAToDJwE6AycBOgMnAToDJwE6AycBOgMmATkDIwEyAxoBJAMMARADAgEDPAADAwEE
Aw8BFAJQAU8BmwHNAWMBKQH/AdUBZgEoAf8B1gFpASoB/wHXAWsBLAH/AdkBbgEuAf8B2gFwATAB
/wHbAXMBMgH/Ad0BdgE0Af8B3gF5ATYB/wHgAXwBOAH/AeEBfwE7Af8B4wGCAT0B/wHkAYQBPwH/
AeUBhwFBAf8B5wGKAUMB/wHoAY0BRQH/AeoBkQFIAf8B7AGUAUoB/wHtAZcBTAH/Ae8BogFcAf8B
8AG2AXwB/wHaAX0BPQH/AykBPQMWAR4DBwEJBAFQAAQBAxQBGwM7AWUDVgG1A3EB7wPGAf8D0QH/
A9EB/wPQAf8DzwH/A8wB/wPHAf8DvwH/A7gB/wO1Af8DtAH/A7QB/wO5Af8DvwH/A8MB/wPEAf8D
wwH/A8EB/wPAAf8DuQH/A3AB7wNWAbUDOwFlAxQBGwQBUAAEAQMuAUcBcwJyAe0CbAFrAeUDSQGF
AxABFQMGAQgDDwETA0QBeANjAdUDbAHlA0EBcAMIAQoDBQEGAwUBBgMFAQYDGAEgAyQBNQMYASAD
DQERAwcBCQMFAQYDAwEEBAIQATwAAwkBCwMpAT0DTgGUA1sBygFeAV8BZQHiAVoBawFtAesBWAFp
AWwB7QFYAWoBbAHtAVgBagFsAe0BVgFeAWoB7QFUAV4BagHtAVIBWAFqAe0CUAFeAe0CUAFeAe0C
UAFeAe0CUAFeAe0CUAFeAe0CUAFeAe0CTAFSAe0CTAFWAe0CUAFeAe0CUAFeAe0CUAFeAe0BTQFQ
AVwB7QFMAU8BUwHtAkwBXgHtAU8BUAFeAe0BUAFSAWkB7QFSAVYBagHtAVQBXAFqAe0CUAFfAe0B
VAFaAWoB7QFQAVIBYQHtAk0BYwHtAlABXgHtAlABXgHtAlABXgHtAlABXgHtAlMBYQHrAlkBYAHj
AlwBXQHMA00BkgMoATsDCAEKMAAEAQMHAQkDHQEoAcIBXwEqAf8B0wFiASUB/wHUAWQBJwH/AdUB
ZwEpAf8B1gFpASoB/wHYAWwBLQH/AdkBbgEuAf8B2gFxATAB/wHcAXQBMgH/Ad0BdwE1Af8B3gF6
ATcB/wHgAX0BOQH/AeEBfwE7Af8B4wGCAT0B/wHkAYUBPwH/AeYBiQFCAf8B6AGLAUQB/wHpAY4B
RgH/AesBkgFJAf8B7AGVAUsB/wHuAZkBTgH/AfABnAFQAf8B8QGeAVIB/wHzAakBYAH/AfQBvwGD
Af8BggFoAVEB8AMgAS4DDQERBAJIAAMDAQQDJAE1A0wBkANlAeIDxQH/A9QB/wPUAf8D0wH/A84B
/wO8Af8CmAGuAf8CZQGtAf8CQAGyAf8CKAG5Af8CGgHAAf8CEgHEAf8CEgHFAf8CGQHCAf8CJgG8
Af8CPQGzAf8CXgGqAf8CjQGlAf8DrgH/A74B/wPBAf8DwQH/A78B/wO3Af8DZQHiA0wBkAMkATUD
AwEESAAIAQMyAU8B/AH6AfkB/wHsAekB5wH/AbEBrgGtAf8DYAHOAxQBGwNXAbUBvwG+Ab0B/wHu
AesB6gH/AecB4wHgAf8DWAG4AwoBDQMJAQsDCQELAyMBMwFxAWoBWAHrAY4BeQE0Af4BcgFlAVAB
8QFfAlsB2ANYAbgDTQGTAz4BawMaASQDAwEEAwIBAwQCBAE4AAMJAQsDPQFnAVkBWgFpAekBRgF8
AbIB/wE9AWcBsAH/AV8BqAHRAf8BZAGxAdQB/wFhAaoB0QH/AWEBqQHQAf8BYAGnAdAB/wFcAZ4B
zAH/AUABawG2Af8BRAFyAbkB/wESARUBjgH/Ag8BiwH/Ag8BiwH/ASABLgGaAf8BGAEfAZAB/wEH
AQsBKwH/AgABJAH/AgMBLgH/Ag0BjgH/Ag0BggH/AQsBDwFbAf8BAgEDAXMB/wIEAasB/wIDAZUB
/wECAQMBUAH/AQgBCgGkAf8BJgE+Aa4B/wE3AV0BuwH/AVEBjAHBAf8BVQGUAcQB/wE4AWABvgH/
AT0BZgGsAf8BEAESAYUB/wIOAYUB/wIOAYcB/wIPAYkB/wIPAYsB/wIPAYoB/wIOAYQB/wIKAW8B
/wJcAV4B1wMzAVEDBwEJKAAEAQMLAQ4BWQJXAbwB0AFdAScB/wHRAV8BJAH/AdMBYgEmAf8B1AFk
AScB/wHVAWcBKQH/AdYBagErAf8B2AFsAS0B/wHZAW8BLwH/AdoBcQExAf8B3AF0ATIB/wHdAXcB
NQH/Ad8BegE3Af8B4AF9ATkB/wHiAYABOwH/AeMBgwE9Af8B5QGGAUAB/wHmAYkBQgH/AegBjAFE
Af8B6QGPAUYB/wHrAZMBSQH/Ae0BlgFMAf8B7wGZAU4B/wHwAZ0BUAH/AfIBoAFTAf8B9AGkAVYB
/wH1AacBWAH/AfcBwwGFAf8B6QGeAV4B/wMoATwDEgEYAwMBBEAAAwYBBwMuAUgDVgGwA5IB+APU
Af8D1wH/A9YB/wPOAf8CqgG0Af8CWwGsAf8CHgG5Af8CAQHFAf8CAAHGAf8CAAHIAf8CAAHJAf8C
AAHKAf8CAAHLAf8CAAHMAf8CAAHNAf8CAAHOAf8CAAHPAf8CAAHRAf8CAQHRAf8CGwHCAf8CUgGq
Af8CmAGjAf8DugH/A8EB/wO/Af8DvQH/A44B+ANWAbADLgFIAwYBB0QACAEEAgNMAY8B+QH3AfUB
/wHeAdsB2QH/AZ4BmwGZAf8DIAEtA2EBzwHkAeEB4AH/AegB5AHhAf8CawFqAeEDHQEpAwsBDgMM
AQ8DHQEoAWMBYgFcAd8BpAFvAScB/wGwAXkBLgH/AasBdAEpAf8BqwF0ASkB/wGrAXQBKQH/AaoB
cwEpAf8BpgFxASgB/wNOAZUDBgEIAwQBBQMCAQMEAjQABAEDKgFAAVYBZQF1AfEBTgGGAcAB/wFR
AYoBxAH/AVgBlwHKAf8BYgGrAdIB/wFmAbQB1gH/AWIBqwHTAf8BYgGqAdIB/wFiAasB0wH/AWAB
pgHRAf8BJgE5AaAB/wEnATsBoQH/ARUBGwGSAf8CDwGNAf8CDwGNAf8BKAE9AaIB/wEyAU8BpwH/
AQkBEAEvAf8CAAEZAf8BCwEPAUMB/wESARYBkQH/AQ4BDwF5Af8CAgEvAf8CAQFAAf8CAwGYAf8C
BAG3Af8CBAG3Af8CBAG3Af8CBAG2Af8BBgEIAbcB/wFVAZQBxAH/AUwBggHDAf8BSwGCAcUB/wFZ
AZoBxwH/ARoBJQGZAf8CDgGIAf8CDgGIAf8CDwGMAf8CDwGNAf8CDwGNAf8CDwGNAf8CDwGMAf8C
DAF7Af8CXgFfAdUDIwEzBAEgAAQBAwwBEAGgAVsBKwH8Ac8BWwEoAf8B0AFdASIB/wHRAWABJAH/
AdMBYgEmAf8B1AFlAScB/wHVAWcBKQH/AdYBagErAf8B2AFsAS0B/wHZAW8BLwH/AdoBcQExAf8B
3AF0ATMB/wHdAXcBNQH/Ad8BewE3Af8B4AF9ATkB/wHiAYABOwH/AeMBgwE+Af8B5QGGAUAB/wHn
AYoBQgH/AegBjQFFAf8B6gGQAUcB/wHsAZQBSgH/Ae0BlwFMAf8B7wGaAU4B/wHxAZ4BUQH/AfIB
oQFUAf8B9AGkAVYB/wH2AagBWAH/AfgBrAFbAf8B+gGzAWQB/wH6AcwBjgH/AjwBOwFkAxUBHAME
AQU4AAMGAQcDMgFPAloBWwHEA64B/gPZAf8D2QH/A9UB/wKyAbgB/wJSAawB/wIKAbwB/wIAAcAB
/wIAAcIB/wIAAcMB/wIAAcQB/wIAAcUB/wIAAcYB/wIAAccB/wIAAcgB/wIAAckB/wIAAcsB/wIA
AcwB/wIAAc0B/wIAAc4B/wIAAc8B/wIAAdAB/wIAAdEB/wIJAcwB/wJIAawB/wKcAaMB/wO9Af8D
vwH/A78B/wKgAaEB/gJbAVwBxAMyAU8DBgEHQAAMAQMFAQYDYQHPAb4BvQG8Af8BcAFvAW4B7QMI
AQoDUAGbAdIB0QHQAf8BvgG8AbcB/QMqAUADCQQMAQ8DFgEeAWECXQHPAZsBaAEmAf8BpgFxASkB
/wGyAXsBLwH/Aa0BdQEpAf8BrAF1ASkB/wGsAXUBKQH/AawBdAEpAf8BqwF0ASkB/wNQAZoDBgEI
AwUBBgMDAQQEAjQAAwYBBwNQAZoBUAGKAcAB/wFTAY0BxgH/AVgBlwHKAf8BWwGcAcwB/wFmAbIB
1QH/AWgBtAHWAf8BYwGrAdIB/wFjAaoB0gH/AWIBqQHRAf8BYQGmAdAB/wFQAYcBwwH/AUgBeAG8
Af8BMgFQAasB/wERARIBjwH/AhABjgH/ATUBVAGtAf8BOgFdAbEB/wE7AWQBjwH/AQ0BFQFAAf8B
VwGTAcYB/wFMAX8BvwH/AR8BLwGUAf8BAgEDASoB/wIAAR0B/wICAV4B/wIEAbYB/wIEAbgB/wIE
AbgB/wIEAbgB/wIEAbgB/wERARsBugH/AT4BaQHCAf8BSgF/AcUB/wFdAaEByQH/ASgBQgG3Af8B
HAEmAZQB/wElATUBmwH/ASUBNwGeAf8CEAGOAf8CDwGOAf8CDwGNAf8CDwGOAf8CDQGSAf8CCQFv
Af8DRAF7AwYBCBwABAEDDAEPAbYBWgErAf8BzgFZASoB/wHPAVsBIAH/AdABXQEiAf8B0QFgASQB
/wHTAWIBJgH/AdQBZQEnAf8B1QFnASkB/wHXAWoBKwH/AdgBbAEtAf8B2wF1ATcx/wHuAZcBTQH/
Ae8BmwFPAf8B8QGeAVEB/wHzAaIBVAH/AfQBpQFXAf8B9gGpAVkB/wH4AawBXAH/AfoBsAFfAf8B
/AG0AWIB/wH+AdMBlAH/A0QBeAMVARwDAwEEMAADAwEEAzABSgNdBMoB/wPcAf8D2wH/A80B/wJ+
AawB/wIUAbUB/wIAAbsB/wIAAbwB/wIAAb4B/wIAAb8B/wIAAcAB/wIAAcEB/wIAAcIB/wIAAcMB
/wIAAcQB/wIAAcUB/wIAAccB/wIAAcgB/wIAAckB/wIAAcoB/wIAAcsB/wIAAcwB/wIAAc0B/wIA
Ac4B/wIAAdAB/wIAAdEB/wISAcYB/wJrAZ8B/wOzAf8DvwH/A78B/wK4AbkB/wNdAcoDMAFKAwMB
BEAADAEDRgF+AZsCmgH/A18B0AQCAzkBXwGyArAB/wNfAcgDBQEGAwcBCQMPARQCWQFXAbwBkwFk
ASQB/wGdAWoBJgH/AagBcwEsAf8BtAF8ATAB/wGuAXYBKgH/Aa4BdgEpAf8BrQF1ASkB/wGtAXUB
KQH/Aa0BdQEpAf8CUQFQAZ0DBgEHAwUBBgMDAQQEAgQBMAADCAEKAlcBWQG5AUsBfgG+Af8BWAGW
AcoB/wFdAZ8BzQH/AVMBnwG+Af0DYgHXA10BxQNcAcQDXAHEA1wBxANcAcQDXAHEA1wBxANcAcQD
XAHEAloBXAHEA1wBxANcAcQDXAHEAloBXAHEA1wBxANcAcQDXAHEAloBXAHEAloBXAHEAloBXAHE
AloBXAHEAloBXAHEAloBXAHEAloBXAHEAloBXAHEAloBXAHEAloBXAHEAVoCXAHEA1wBxANcAcQD
XAHEA1wBxANcAcQDXQHFAl4BZQHdAhgBkwH/Ag8BjQH/Ag8BjQH/Ag0BfwH/A1MBqQMLAQ4cAAMJ
AQwBngFPATQB+gHNAVsBKwH/Ac4BWQEfAf8BzwFbASAB/wHQAV0BIgH/AdEBYAEkAf8B0wFiASYB
/wHUAWUBJwH/AdUBZwEpAf8B1gFqASsB/wHYAWwBLQH/AdsBdQE3Mf8B7QGXAUwB/wHvAZsBTwH/
AfEBngFRAf8B8wGiAVQB/wH0AaUBVwH/AfYBqAFZAf8B+AGsAVwB/wH6AbABXgH/AfwBtAFhAf8B
/QG3AWMB/wH+AdMBlQH/AjwBOwFkAxIBGAQCKAAEAQMmATkDWgHCA8wB/wPeAf8D3AH/AsUBxgH/
AlIBqgH/AgIBtgH/AgABuAH/AgABuQH/AgABugH/AgABuwH/AgABvAH/AgABvQH/AgABvgH/AgAB
wAH/AgABwQH/AgABwgH/AgABwwH/AgABxAH/AgABxQH/AgABxgH/AgABxwH/AgAByQH/AgABygH/
AgABywH/AgABzAH/AgABzQH/AgABzgH/AgABzwH/AgEB0AH/AkUBqgH/AqgBqQH/A78B/wO/Af8D
uAH/A1oBwgMmATkEAUQABAEDQgFzAZkCmAH/A3IB8QQCAy4BRwGhAaABnwH/A1IBpAMCBAMBBAM/
AWwBlQFlASUB/wGVAWUBJQH/AZ0BagEmAf8BqAFyASsB/wG1AX0BMQH/AbABdwEqAf8BsAF2ASoB
/wGvAXYBKgH/Aa8BdgEqAf8BrgF2ASoB/wJRAVABnwMDAQQDAwEEAwIBAwQCBAEwAAMGAQcCVQFW
Aa4BHwEsAZoB/wFdAZ8BzQH/AV8BowHPAf8BQAGHAawB/QNCAXUDDgESAwYBCAMGAQgDBgEIAwYB
CAMGAQgDBgEIAwYBCAMGAQgDBgEIAwYBCAMGAQgDBgEIAwYBCAMGBAgBCgMMAQ8DDAEPAwkBCwMG
AQgDBgEIAwYBCAMGAQgDBgEIAwYBCAMGAQgDBgEIAwYBCAMGAQgDBgEIAwYBCAMGAQgDBgEIAwkB
CwM2AVcCGAGAAf4CDwGNAf8CDwGNAf8CDgGDAf8DVQGsAwsBDhgAAwYBBwFiAl0B1AHMAVwBLgH/
Ac0BVwEdAf8BzgFZAR8B/wHPAVsBIAH/AdABXQEiAf8B0QFgASQB/wHTAWIBJgH/AdQBZAEnAf8B
1QFnASkB/wHWAWoBKwH/AdgBbAEtAf8B2wF1ATcx/wHtAZcBTAH/Ae8BmgFOAf8B8AGdAVEB/wHy
AaEBVAH/AfQBpAFWAf8B9gGoAVgB/wH3AasBWwH/AfkBrgFdAf8B+gGxAV8B/wH7AbMBYQH/AfwB
tAFhAf8B+gHMAY8B/wMoATwDDQERBAEkAAMYASADUgGoArIBswH+A98B/wPfAf8CwwHFAf8COwGq
Af8CAAGzAf8CAAG0Af8CAAG1Af8CAAG2Af8CAAG3Af8CAAG4Af8CAAG6Af8CAAG7Af8CAAG8Af8C
AAG9Af8CAAG+Af8CAAG/Af8CAAHAAf8CAAHBAf8CAAHDAf8CAAHEAf8CAAHFAf8CAAHGAf8CAAHH
Af8CAAHIAf8CAAHJAf8CAAHKAf8CAAHMAf8CAAHNAf8CAAHOAf8CAAHPAf8CMQGyAf8CowGnAf8D
vwH/A78B/wOhAf4DUgGoAxgBIEgAA0cBggGgAp8B/wGSAZEBkAH/AxEBFgM2AVkBnAGbAZoB/wNR
AZ4HAgEDAkQBQwF3AZYBZgElAf8BlgFlASUB/wGdAWkBJgH/AacBcgErAf8BtwF+ATMB/wGyAXgB
KwH/AbIBeAEqAf8BsQF3ASoB/wGxAXcBKgH/AbABdwEqAf8DUgGjCAIMATAABAIDRAF6AhABjQH/
AUEBbQG7Af8BYAGnAdEB/wFXAZkBwwH/Al8BYwHVAyIBMQQCMAADDQERAy0BRgNEAXkDRAF4Ay8B
SQMRARYEATAAAxMBGQNZAcECDgGIAf8CDwGNAf8CDwGNAf8CDQF9Af8DSQGHAwYBBxQABAIDLwFJ
AcsBXwEyAf8BzAFVARwB/wHNAVcBHQH/Ac4BWQEfAf8BzwFbASAB/wHQAV0BIgH/AdEBXwEjAf8B
0wFiASYB/wHUAWQBJwH/AdUBZwEpAf8B1gFqASsB/wHYAWwBLQH/AdkBbgEuAf8B2gFxATEB/wHc
AXQBMgH/Ad0BdwE1Gf8B6AGMAUQB/wHpAY8BRgH/AesBkwFJAf8B7QGWAUsB/wHuAZkBTgH/AfAB
nQFQAf8B8gGgAVMB/wHzAaMBVQH/AfUBpgFXAf8B9gGpAVkB/wH4AawBWwH/AfkBrgFdAf8B+gGw
AV4B/wH6AbABXgH/AfkBsgFkAf8B5gGbAV0B/wMgAS4DBwEJIAADCAEKA0QBeQOSAfkD4QH/A+EB
/wLIAckB/wI6AagB/wIAAa8B/wIAAbAB/wIAAbEB/wIAAbIB/wIAAbQB/wIAAbUB/wIAAbYB/wIA
AbcB/wIAAbgB/wIAAbkB/wIJAb0B/wIeAcMB/wIFAb4B/wIAAb4B/wIAAb8B/wIAAcAB/wIAAcEB
/wIAAcIB/wIAAcMB/wIAAcQB/wIAAcYB/wIAAccB/wIAAcgB/wIAAckB/wIAAcoB/wIAAcsB/wIA
AcwB/wIAAc0B/wIwAbIB/wKnAagB/wO/Af8DvwH/A44B+QNEAXkDCAEKRAADUgGgAakCqAH/AZgC
lwH/AxoBJANSAqACngH/A1QBqAgBA0MBdgGWAWYBJQH/AZYBZQElAf8BnAFpASYB/wGnAXEBKgH/
AbgBgAE1Af8BsgF5ASsB/wGyAXgBKwH/AbIBeAErAf8BsgF4ASsB/wGyAXgBKwH/A1MBpxABOAAD
GQEiAlIBagHtARQBGQGSAf8BWQGZAcsB/wFgAaYB0AH/AUQBfAGmAf8DTAGOAw8BEywAAwsBDgNF
AXwBTQFYAW8B8wE8AW4BqgH/ATIBWwGIAf8CSgFiAe4DRAF7Aw8BFCwAAwUBBgM/AW0BJwE4AYAB
/gIPAY0B/wIPAY0B/wIPAYwB/wJHAWUB8QMlATYEARQAAwwBDwHCAV4BMQH/AcsBVAEbAf8BzAFV
ARwB/wHNAVcBHQH/Ac4BWQEeAf8BzwFbASAB/wHQAV0BIgH/AdEBXwEjAf8B0wFiASUB/wHUAWQB
JwH/AdUBZwEpAf8B1gFpASoB/wHXAWsBLAH/AdkBbgEuAf8B2gFxATAB/wHbAXMBMgH/Ad0BdgE0
Gf8B5wGLAUMB/wHpAY4BRgH/AesBkQFIAf8B7AGUAUoB/wHuAZgBTQH/Ae8BmwFPAf8B8QGeAVEB
/wHyAaEBVAH/AfQBpAFWAf8B9QGnAVgB/wH2AakBWQH/AfcBqwFbAf8B+AGsAVsB/wH4AawBWwH/
AfcBqwFbAf8B9gHDAYUB/wGBAWgBUQHwAxYBHgMCAQMYAAQBAykBPQNmAeED3wH/A+IB/wPUAf8C
UAGnAf8CAAGrAf8CAAGsAf8CAAGtAf8CAAGvAf8CAAGwAf8CAAGxAf8CAAGyAf8CAAGzAf8CAAG0
Af8CAAG1Af8CWgHHAf8C5gHuAf8D9AH/AuUB8QH/An0B2gH/AgYBvgH/AgABvQH/AgABvgH/AgAB
vwH/AgABwQH/AgABwgH/AgABwwH/AgABxAH/AgABxQH/AgABxgH/AgABxwH/AgAByAH/AgAByQH/
AgABywH/AgABzAH/AkEBqQH/A7EB/wO/Af8DvgH/A2YB4QMpAT0EAUAAA10BxQGuAawBqwH/AZYB
lQGUAf8DIwEyAXoCeQH2AaQBowGiAf8DWQG5CAEDQwF2AZYBZgElAf8BlQFlASUB/wGbAWgBJQH/
AagBcgEqAf8B1wGbAUcB/wHcAaIBUQH/AdcBnwFQAf8B0gGbAU4B/wHLAZQBSQH/AcQBjQFCAf8C
VQFTAapIAAMDAQQDRQF8AhcBkgH/ATIBUQGrAf8BXgGhAc8B/wFSAY4BwgH/AVoBXQFsAewDMAFK
AwQBBSQABAEDKAE8AjQBRQH1AQgBDgEnAf8BSQF/AaAB/wFLAYIBqQH/AQMBBgE2Af8CTAFUAe0D
KwFBBAIkAAQBAx4BKgFgAWUBaAHhASIBMwGbAf8CDwGNAf8CDwGNAf8CDgGBAf8DTAGRAwkBCxQA
AwMBBAFuAVwBWgHnAcoBXgEwAf8BywFTARoB/wHMAVUBGwH/Ac0BVgEdAf8BzgFZAR4B/wHPAVoB
IAH/AdABXAEhAf8B0QFfASMB/wHSAWEBJQH/AdMBZAEmAf8B1QFmASgB/wHWAWkBKgH/AdcBawEs
Af8B2AFtAS4B/wHaAXABMAH/AdsBcwEyAf8B3QF2ATQZ/wHnAYoBQwH/AegBjQFFAf8B6gGQAUcB
/wHrAZMBSQH/Ae0BlgFMAf8B7wGZAU4B/wHwAZwBUAH/AfEBnwFSAf8B8wGiAVQB/wH0AaQBVgH/
AfUBpgFXAf8B9QGnAVgB/wH2AagBWQH/AfYBqAFZAf8B9gGoAVgB/wH1AaYBVwH/AfQBvwGDAf8D
KQE9AwsBDhgAAwwBEANSAaED0gH/A+UB/wPgAf8CfQGsAf8CAQGnAf8CAAGpAf8CAAGqAf8CAAGr
Af8CAAGsAf8CAAGtAf8CAAGuAf8CAAGvAf8CAAGwAf8CAAGyAf8CEAG0Af8C1wHbAf8D8gH/A/IB
/wPyAf8D8gH/ArMB5QH/AgkBvQH/AgABvAH/AgABvQH/AgABvgH/AgABvwH/AgABwAH/AgABwQH/
AgABwgH/AgABxAH/AgABxQH/AgABxgH/AgABxwH/AgAByAH/AgAByQH/AgEBygH/AmUBngH/A7sB
/wO/Af8DuQH/A1IBoQMMARBAAAF1AnQB7AGqAakBqAH/AYsCigH/A0cBggGdAZwBmwH/AaMBoQGf
Af8DXwHJCAADRAF4AZYBZQElAf8BlAFlASUB/wGaAWcBJQH/AZcBYwEiAf8BjgFcAR4B/wGRAV4B
HwH/AZoBZQEiAf8BpQFtASYB/wGyAXkBLgH/AcUBiwE7Af8DUQGeTAADDwETAl0BYQHUARIBFAGR
Af8BVAGOAcYB/wFWAZIByAH/AUcBfgGwAf8DVgGzAxgBICQABAIBQAJBAXEBKAFFAYcB/wEDAQQB
TAH/ARIBHgE/Af8BWwGfAcQB/wEQARoBigH/AgIBPwH/Az8BbQMDAQQkAAMKAQ0DTgGYAVwBpwHJ
Af8BIQExAZwB/wIPAY0B/wIPAYsB/wJbAWEB3gMbASUEARQAAw0BEQHJAWUBOgH/AcoBUQEZAf8B
ywFTARoB/wHMAVQBGwH/Ac0BVgEcAf8BzgFYAR4B/wHPAVoBIAH/AdABXAEhAf8B0QFeASMB/wHS
AWEBJQH/AdMBYwEmAf8B1QFmASgB/wHWAWgBKgH/AdcBagEsAf8B2AFtAS0B/wHZAW8BLwH/AdsB
cgExAf8B3AF1ATQZ/wHmAYkBQgH/AegBjAFEAf8B6QGPAUYB/wHrAZIBSQH/AewBlAFKAf8B7gGY
AU0B/wHvAZoBTgH/AfABnQFQAf8B8QGfAVIB/wHyAaEBVAH/AfMBowFVAf8B9AGkAVYB/wH0AaQB
VgH/AfQBpAFWAf8B9AGkAVYB/wHzAaMBVQH/AfIBqAFgAf8B1gF5ATwB/wMZASMDAgEDEAAEAQMr
AUEDdgHwA+YB/wPlAf8CuAHBAf8CEAGiAf8CAAGlAf8CAAGmAf8CAAGnAf8CAAGoAf8CAAGpAf8C
AAGqAf8CAAGsAf8CAAGtAf8CAAGuAf8CAAGvAf8CHwGwAf8D2gH/A/IB/wPyAf8D8gH/AsoB4AH/
An8BuQH/ApQB1QH/AgEBuQH/AgABugH/AgABuwH/AgABvAH/AgABvgH/AgABvwH/AgABwAH/AgAB
wQH/AgABwgH/AgABwwH/AgABxAH/AgABxQH/AgABxwH/AgAByAH/Ag0BwAH/ApUBoAH/A8AB/wO/
Af8DcwHwAysBQQQBOAADKAE7AaUBpAGjAf8BoAGfAZ4B/wF7AXoBeQH/A14B0gGbAZoBmQH/AZ8B
nAGbAf8DXwHJCAADRAF4AZYBZQElAf8BkwFiASMB/wGNAV0BIAH/AaIBbQEoAf8BpAFyATAB/wGR
AWEBIgH/AYsBXQEgAf8BhAFXAR4B/wGFAVkBIgH/AmIBXgHXAysBQUwABAEDMgFPAioBjgH9ASkB
QAGkAf8BWAGWAcoB/wFVAZIBxgH/AU0BbQF9AfoDPQFoAwgBCiAABAEDPwFtAVYBkgHHAf8BEgEd
AVIB/wENARYBWgH/AV4BpAHJAf8BGAEoAUwB/wIBAUMB/wM9AWgDAgEDIAADAgEDAi0BLgFGAVoB
cwGFAfUBZAGvAdMB/wErAUMBpQH/Ag8BjQH/AhYBgAH+AzwBZgMEAQUUAAMDAQQBmAFdASgB+wHJ
AV0BLQH/AcoBUQEZAf8BywFSARoB/wHMAVQBGwH/AcwBVgEcAf8BzQFYAR4B/wHOAVoBHwH/Ac8B
XAEhAf8B0AFeASIB/wHSAWEBJAH/AdMBYwEmAf8B1AFlAScB/wHVAWcBKQH/AdcBagErAf8B2AFs
AS0B/wHZAW8BLwH/AdoBcQExAf8B3AF0ATMZ/wHlAYcBQQH/AecBigFDAf8B6AGNAUUB/wHqAZAB
RwH/AesBkwFJAf8B7AGVAUsB/wHuAZgBTQH/Ae8BmgFOAf8B8AGcAVAB/wHxAZ4BUQH/AfEBnwFS
Af8B8gGgAVMB/wHyAaEBVAH/AfIBoQFUAf8B8gGgAVMB/wHyAaABUwH/AfEBngFSAf8B8AG2AXwB
/wMrAUIDCQEMEAADBwEJA1EBnAPYAf8D6AH/A90B/wJPAaMB/wIAAaEB/wIAAaIB/wIAAaMB/wIA
AaQB/wIAAaUB/wIAAacB/wIAAagB/wIAAakB/wIAAaoB/wIAAasB/wIAAawB/wIHAa0B/wLDAckB
/wPyAf8D8gH/A/IB/wKlAeAB/wIBAbQB/wJ0AbMB/wJWAcsB/wIAAbgB/wIAAbkB/wIAAboB/wIA
AbsB/wIAAbwB/wIAAb0B/wIAAb4B/wIAAb8B/wIAAcEB/wIAAcIB/wIAAcMB/wIAAcQB/wIAAcUB
/wIAAcYB/wI9AagB/wO1Af8DwAH/A7oB/wNRAZwDBwEJOAADXwHIAa0CqwH/AbEBsAGvAf8BoQGg
AZ8B/wGkAqIB/wGwAq4B/wGnAaQBogH/A1oBuggAA0QBewGWAWQBJQH/AYoBXAEgAf8BlwFmASUB
/wGlAXABKgH/Ab4BhgE7Af8BtwF8AS0B/wG3AXwBLQH/AbcBfAEtAf8BtgF7AS0B/wG1AXsBLQH/
AloBWAG3UAADBwEJA1UBrAEbAScBXgH/AUoBfgHCAf8BUQGKAcUB/wFNAYYBugH/AV0CXgHSAyEB
MAQBIAADHgErAWkBewGJAfIBLAFJAXQB/wEMARMBPwH/ATkBYgGdAf8BCwESAWUB/wJQAWYB6QMg
AS0EASAAAxIBGANaAb8BXAGjAc4B/wFgAagB0QH/ARQBGQGRAf8CDgGHAf8DVwG8AxABFRgAAwkB
DAHHAWgBPwH/AckBTgEXAf8BygFQARgB/wHLAVIBGQH/AcsBVAEbAf8BzAFVARwB/wHNAVcBHgH/
Ac4BWQEfAf8BzwFbASAB/wHQAV0BIgH/AdEBYAEkAf8B0wFiASYB/wHUAWQBJwH/AdUBZwEpAf8B
1gFpASoB/wHXAWsBLAH/AdkBbgEuAf8B2gFwATAB/wHbAXMBMhn/AeUBhgFAAf8B5gGJAUIB/wHo
AYsBRAH/AekBjgFGAf8B6gGRAUgB/wHrAZMBSQH/AewBlQFLAf8B7QGXAUwB/wHuAZkBTgH/Ae8B
mwFPAf8B8AGcAVAB/wHwAZ0BUQH/AfEBngFRAf8B8QGeAVEB/wHwAZ0BUQH/AfABnQFQAf8B8AGb
AU8B/wHvAaEBXQH/AdABbgEyAf8DFAEbBAEMAAMbASYDaAHkA+kB/wPoAf8CsQG+Af8CDgGfAf8C
AwGgAf8CAAGgAf8CAAGhAf8CAAGiAf8CAAGjAf8CAAGkAf8CAAGlAf8CAAGmAf8CAAGnAf8CAAGp
Af8CAAGqAf8CAAGrAf8ChQG2Af8D7wH/A/IB/wPyAf8C4AHvAf8CAgGyAf8CCAGxAf8CoQHGAf8C
DgG5Af8CAAG2Af8CAAG3Af8CAAG4Af8CAAG5Af8CAAG7Af8CAAG8Af8CAAG9Af8CAAG+Af8CAAG/
Af8CAAHAAf8CAAHBAf8CAAHCAf8CAAHEAf8CBQHBAf8CjQGeAf8DwQH/A78B/wJnAWgB5AMbASY4
AANhAdABugG5AbgB/QHIAccBxgH/AccBxgHFAf8BxwHGAcUB/wHDAcEBwAH/AbABrgGsAf8DWwHA
CAADJAE1AWoBZAFVAeoBkQFiASQB/wGWAWUBJQH/AaYBcQErAf8BwQGKAUAB/wG5AX0BLQH/AbgB
fQEtAf8BuAF9AS0B/wG3AXwBLQH/AbcBfAEtAf8CWwFZAcBUAAMeASsBSAFJAWkB8AEFAQcBSgH/
ARsBLAG0Af8BQgFuAbsB/wEzAVkBmAH/A0oBiwMOARIgAAMDAQQDOAFbAWoBcQF3Ae4BSgFRAWsB
/wFEAVwBowH/AVUBVwFcAecDNgFXAwUBBiAAAwUBBgM/AWwBWwGDAasB/gFmAbMB1QH/AVkBmgHL
Af8BEAERAY0B/wI9AWgB9AMrAUEEAhgAAjsBOgFiAcgBaAE+Af8ByQFOARcB/wHJAVABGAH/AcoB
UQEZAf8BywFTARoB/wHMAVUBHAH/Ac0BVwEdAf8BzgFZAR4B/wHPAVsBIAH/AdABXQEiAf8B0QFf
ASMB/wHSAWEBJQH/AdMBZAEmAf8B1QFmASgB/wHWAWgBKgH/AdcBagEsAf8B2AFtAS0B/wHZAW8B
LwH/AdsBcgExGf8B5AGEAT4B/wHlAYcBQAH/AecBigFCAf8B6AGMAUQB/wHpAY4BRgH/AeoBkAFH
Af8B6wGTAUkB/wHsAZQBSgH/Ae0BlgFMAf8B7gGYAU0B/wHuAZkBTgH/Ae8BmQFOAf8B7wGaAU4B
/wHvAZoBTgH/Ae8BmgFOAf8B7gGZAU4B/wHuAZgBTQH/Ae0BlwFMAf8B6gGnAW0B/wMfASwDBAEF
CAAEAQM7AWIDzQH/A+sB/wPjAf8CXwGlAf8CDgGgAf8CCwGgAf8CAgGeAf8CAAGeAf8CAAGfAf8C
AAGgAf8CAAGhAf8CAAGiAf8CAAGkAf8CAAGlAf8CAAGmAf8CAAGnAf8CAAGoAf8CRwGqAf8D4wH/
A/IB/wPyAf8D9AH/AjYBvwH/AgABsAH/Ah4BsQH/AgcBtAH/AgABswH/AgABtAH/AgABtgH/AgAB
twH/AgABuAH/AgABuQH/AgABugH/AgABuwH/AgABvAH/AgABvQH/AgABvwH/AgABwAH/AgABwQH/
AgABwgH/AkQBowH/A7oB/wPBAf8DtQH/AzsBYgQBNAADWQG7AbIBsQGwAf8B2AHWAdUB/wHZAdcB
1gH/AdYB1AHTAf8BzQHMAcsB/wG3AbUBswH/A18ByAgAA0UBfAGUAWQBJAH/AZEBYgEjAf8BmAFn
ASUB/wGpAXQBLAH/AcgBkwFLAf8BugF+AS0B/wG6AX4BLQH/AbkBfgEtAf8BuQF9AS0B/wG5AX0B
LQH/AWMBYQFcAdZUAAMDAQQDRgF/ARsBJQGXAf8BIAE1AVUB/wFKAXsBvwH/AUkBfAG6Af8BVQFc
AWcB6gMtAUYDAwEEIAADAgEDAxYBHQM1AVUDNQFVAxYBHgMDAQQgAAQBAx4BKgFgAWYBZwHgAWYB
tQHVAf8BZQGyAdYB/wFkAa4B0wH/AR4BLQGPAf8DTgGUAwkBDBgAAwMBBAGxAVgBLgH/AcgBTwEZ
Af8ByAFOARYB/wHJAU8BGAH/AcoBUQEZAf8BywFTARoB/wHMAVQBGwH/Ac0BVgEdAf8BzgFYAR4B
/wHPAVoBIAH/AdABXAEhAf8B0QFeASMB/wHSAWEBJAH/AdMBYwEmAf8B1AFlAScB/wHVAWcBKQH/
AdYBagErAf8B2AFsAS0B/wHZAW4BLgH/AdoBcQExGf8B4wGCAT0B/wHkAYQBPwH/AeUBhwFBAf8B
5wGKAUIB/wHoAYwBRAH/AekBjgFGAf8B6gGQAUcB/wHrAZEBSAH/AesBkwFJAf8B7AGUAUoB/wHt
AZYBSwH/Ae0BlgFMAf8B7QGXAUwB/wHtAZcBTAH/Ae0BlgFMAf8B7QGWAUsB/wHsAZUBSwH/AesB
kwFJAf8B6wGoAW4B/wJAAT8BbgMKAQ0IAAMGAQcDUwGnA+UB/wPrAf8C0AHRAf8CJgGfAf8CEwGh
Af8CEQGgAf8CDQGgAf8CAgGcAf8CAAGcAf8CAAGeAf8CAAGfAf8CAAGgAf8CAAGhAf8CAAGiAf8C
AAGjAf8CAAGkAf8CAAGlAf8CEgGmAf8DzgH/A/IB/wPyAf8D8wH/AoAB0wH/AgABrQH/AgABrgH/
AgABsAH/AgABsQH/AgABsgH/AgABswH/AgABtAH/AgABtQH/AgABtgH/AgABtwH/AgABuQH/AgAB
ugH/AgABuwH/AgABvAH/AgABvQH/AgABvgH/AgABvwH/AhABtQH/AqYBpwH/A8EB/wO/Af8DUwGn
AwYBBzAAAyEBMAGaApkB+wNhAc8B4QHfAd4B/wHgAd4B3QH/AdoB2QHYAf8BzwLNAf8BsgGxAbAB
/wNdAccDKwFCAy4DRwFGAYEBlgFmASUB/wGUAWQBJAH/AZ0BagElAf8BtAF8AS0B/wHYAa4BcgH/
AbsBfwEtAf8BuwF/AS0B/wG7AX4BLQH/AboBfgEtAf8BugF+AS0B/wGdAXkBNgH6AwsBDlQAAw8B
FAJeAWIB1wEqAUYBbwH/ASoBRAGSAf8BRwF3AbwB/wEvAVABgwH/A1UBrwMWAR4kAAMEAQUDOQFe
AzgBXQMGAQgkAAMKAQ0BTgJPAZcBVgGbAccB/wFpAbkB2AH/AWkBuAHYAf8BZgGxAdMB/wFfAWAB
ZgHgAxwBJwQBGAADBgEIAc4BfQFYAf8B0AFlATMB/wHIAU0BFgH/AckBTwEXAf8BygFQARgB/wHL
AVIBGgH/AcwBVAEbAf8BzAFWARwB/wHNAVcBHgH/Ac4BWQEfAf8BzwFbASAB/wHQAV4BIgH/AdEB
YAEkAf8B0wFiASUB/wHUAWQBJwH/AdUBZgEoAf8B1gFpASoB/wHXAWsBLAH/AdgBbQEuAf8B2gFw
AS8Z/wHiAYEBPAH/AeMBgwE9Af8B5AGFAT8B/wHlAYcBQQH/AecBigFCAf8B6AGLAUQB/wHoAY0B
RQH/AekBjwFGAf8B6gGQAUcB/wHrAZEBSAH/AesBkgFJAf8B6wGTAUkB/wHrAZMBSQH/AesBkwFJ
Af8B6wGTAUkB/wHrAZMBSQH/AesBkQFIAf8B6gGQAUcB/wHpAZYBUwH/AcwBawExAf8DEgEXCAAD
DwETA2MB2gPtAf8D7AH/AqABugH/AhoBowH/AhgBowH/AhYBogH/AhMBoQH/Ag4BnwH/AgEBmgH/
AgABmwH/AgABnAH/AgABnQH/AgABngH/AgABnwH/AgABoQH/AgABogH/AgABowH/AgABpAH/ApYB
uAH/A/AB/wPyAf8D8gH/AskB6AH/AgABqwH/AgABrAH/AgABrQH/AgABrgH/AgABrwH/AgABsAH/
AgABsQH/AgABswH/AgABtAH/AgABtQH/AgABtgH/AgABtwH/AgABuAH/AgABuQH/AgABugH/AgAB
vAH/AgABvQH/AgABvQH/AnkBnQH/A8IB/wPBAf8DYwHaAw8BEzAAA1oBwgNpAegDKQE9AeQB4gHh
Af8B4wHhAeAB/wHZAdgB1wH/AcwCygH/AakBqAGnAf8DbgH1A4AB/gGPAYsBhwH/AWwBZgFfAeUB
ogFtASYB/wGqAXUBJgH/AboBgAEnAf8BwgGHASwB/wHeAbkBgwH/Ab4BggExAf8BvAF/AS0B/wG8
AX8BLQH/AbwBfwEtAf8BuwF+AS0B/wG7AX4BLQH/AkgBRwGDVAAEAgM0AVMBQAFLAbIB/QEhATcB
WAH/AUYBdQG8Af8BNAFWAYcB/wE4AUEBZgH5AzsBZQMHAQkgAAMJAQwDWAG9A1QBqwMMARAgAAMC
AQMCLQEuAUYBWgF2AYUB9QFhAaoB1QH/AWEBqgHVAf8BaQG3AdgB/wFjAYsBpwH+Az4BagMFAQYc
AAMRARYB0AGBAV0B/wHQAWUBMwH/AdABZgEzAf8ByQFOARcB/wHKAVABGAH/AcoBUgEZAf8BywFT
ARoB/wHMAVUBHAH/Ac0BVwEdAf8BzgFZAR4B/wHPAVoBIAH/AdABXQEiAf8B0QFfASMB/wHSAWEB
JQH/AdMBYwEmAf8B1AFlASgB/wHVAWgBKQH/AdcBagErAf8B2AFsAS0B/wHZAW4BLhn/AeEBfgE6
Af8B4gGBATwB/wHjAYMBPQH/AeQBhAE/Af8B5QGHAUAB/wHmAYkBQgH/AecBigFDAf8B6AGLAUQB
/wHoAY0BRQH/AekBjgFGAf8B6QGPAUYB/wHpAY8BRgH/AeoBkAFHAf8B6gGQAUcB/wHpAY8BRgH/
AekBjwFGAf8B6QGOAUYB/wHoAY0BRQH/AegBjAFEAf8B1wF/AUYB/wMYASAEAQQAAxwBJwKiAaMB
+gPuAf8D6wH/AnABqgH/Ah8BpQH/Ah0BpQH/AhoBpAH/AhgBowH/AhYBogH/AhABoAH/AgIBmgH/
AgABmgH/AgABmwH/AgABnAH/AgABnQH/AgABngH/AgABnwH/AgABoAH/AgABoQH/AlUBqAH/A+cB
/wPyAf8D8gH/AvMB9AH/Ah8BsgH/AgABqQH/AgABqgH/AgABrAH/AgABrQH/AgABrgH/AgABrwH/
AgABsAH/AgABsQH/AgABsgH/AgABswH/AgABtAH/AgABtgH/AgABtwH/AgABuAH/AgABuQH/AgAB
ugH/AgABuwH/AksBnQH/A8AB/wPCAf8CmQGaAfoDHAEnLAADGgEjAa8BrgGtAf8BcQJvAfcDCgEN
A3cB6gHhAt8B/wHVAdQB0wH/AccBxgHFAf8BqAGnAaYB/wG6AbkBuAH/AcQBwQG9Af8BwwG9AbcB
/wGEAXsBbwHzAb8BhAEoAf8BuwGAAScB/wG9AYIBJwH/AcQBhwEqAf8B3QGwAW4B/wHMAZoBVAH/
Ab0BgAEuAf8BvQGAAS4B/wG9AYABLgH/Ab0BgAEtAf8BvAF/AS0B/wGdAXoBKwH8AjEBMAFMVAAD
BwEJA1YBsAEhATMBUgH/AUUBdAG9Af8BQQFuAZ8B/wEqAUgBbAH/Al0BYQHPAyEBLwQBHAADDgES
A10B1ANXAcIDEgEYIAADEgEYAVkCXAG+AWEBrQHPAf8BZwG1AdYB/wFnAbUB1wH/AWEBqgHOAf8D
WgG/AxEBFiAAAzUBVgHRAX8BWQH/AdABZQEzAf8B0QFlATMB/wHRAWYBMwH/AckBTwEYAf8BygFR
ARkB/wHLAVMBGgH/AcwBVAEbAf8BzQFWARwB/wHNAVgBHgH/Ac4BWgEfAf8B0AFcASEB/wHRAV4B
IgH/AdEBYAEkAf8B0wFiASUB/wHUAWQBJwH/AdUBZgEoAf8B1gFpASoB/wHXAWsBLAH/AdgBbQEt
Gf8B4AF9ATkB/wHhAX4BOgH/AeIBgQE8Af8B4wGCAT0B/wHkAYQBPgH/AeUBhgFAAf8B5QGHAUEB
/wHmAYkBQgH/AecBigFCAf8B5wGLAUMB/wHoAYsBRAH/AegBjAFEAf8B6AGNAUUB/wHoAY0BRQH/
AegBjAFEAf8B6AGLAUQB/wHnAYsBQwH/AecBigFDAf8B5gGJAUIB/wHlAZcBYAH/Ax0BKQMCAQME
AAMwAUsD0wH/A+8B/wPkAf8CUAGkAf8CJQGoAf8CIgGnAf8CIAGmAf8CHQGlAf8CGwGkAf8CGQGj
Af8CEwGhAf8CBAGaAf8CAAGZAf8CAAGZAf8CAAGaAf8CAAGbAf8CAAGcAf8CAAGdAf8CAAGfAf8C
HgGhAf8D1AH/A/IB/wPyAf8D8wH/AmgByAH/AgABpgH/AgABqAH/AgABqQH/AgABqgH/AgABqwH/
AgABrAH/AgABrQH/AgABrgH/AgABrwH/AgABsQH/AgABsgH/AgABswH/AgABtAH/AgABtQH/AgAB
tgH/AgABtwH/AgABuAH/AisBoQH/A7gB/wPEAf8DuQH/AzABSywAAw4BEgOFAfUBdgF1AXMB/wM/
AW0DXAG+AdABzwHOAf8ByQHIAccB/wG+Ab0BvAH/AbQCswH/AdABzAHKAf8BuAG2AbUB/wGlAaMB
oQH6A0IBdAHCAYYBKgH/Ab4BggEoAf8BvwGCASgB/wHEAYYBKgH/AdMBkwE2Af8B5AHBAYwB/wG+
AYEBLgH/Ab4BgQEuAf8BvgGBAS4B/wG+AYABLgH/Ab0BgAEuAf8BvQGAAS4B/wGFAW4BRQH1AysB
QlQAAyABLgFQAVQBXAHxATEBUgG9Af8BTAGAAb0B/wEfATQBUQH/AR0BMgGUAf8DSQGIAw0BERwA
AxkBIgFGAUkBTwHwA1sB3gMdASkcAAMFAQYDPgFqAVwBgwGnAf4BYwGtAdMB/wFmAbIB1QH/AWYB
sgHTAf8BWgFyAYMB9QMtAUQEAiAAAW0BWgFYAekB0QF3AU0B/wHQAWUBNAH/AdABZQEzAf8B0AFm
ATMB/wHRAWcBMwH/AcoBUAEYAf8BywFSARkB/wHLAVQBGwH/AcwBVQEcAf8BzQFXAR0B/wHOAVkB
HwH/Ac8BWwEgAf8B0AFdASIB/wHRAV8BIwH/AdIBYQElAf8B0wFjASYB/wHUAWUBJwH/AdUBZwEp
Af8B1gFqASsB/wHXAWsBLBn/Ad8BewE3Af8B4AF8ATkB/wHhAX4BOgH/AeIBgAE7Af8B4wGCAT0B
/wHjAYMBPQH/AeQBhAE/Af8B5QGGAUAB/wHlAYcBQAH/AeYBiAFBAf8B5gGJAUIB/wHmAYkBQgH/
AeYBiQFCAf8B5gGJAUIB/wHmAYkBQgH/AeYBiQFCAf8B5gGIAUEB/wHlAYcBQAH/AeUBhgFAAf8B
5AGUAV0B/wMhAS8DBQEGBAADPQFoA+AB/wPxAf8D3QH/Aj4BogH/AikBqQH/AicBqQH/AiUBqAH/
AiIBpwH/AiABpgH/Ah4BpQH/AhsBpAH/AhcBogH/AggBnAH/AgABmQH/AgABmQH/AgABmQH/AgAB
mgH/AgABmwH/AgABnAH/AgEBnQH/AqgBvAH/A/EB/wPyAf8D8gH/ArIB3wH/AgABpAH/AgABpQH/
AgABpgH/AgABpwH/AgABqAH/AgABqQH/AgABqwH/AgABrAH/AgABrQH/AgABrgH/AgABrwH/AgAB
sAH/AgABsQH/AgABsgH/AgABtAH/AgABtQH/AgABtgH/AhUBpQH/A7AB/wPEAf8DvwH/Az0BaDAA
AzMBUQGCAoEB9AGKAYgBhwH4AaYBpQGkAf4BrQKsAf8BoQKgAf8CnQGcAf8BwQG/Ab4B/wHBAb8B
vgH/AcABvAG4Af8DQQFxAwwBDwGhAXsBQQH5AcEBgwEpAf8BwAGCASgB/wHDAYQBKgH/Ac0BiwEt
Af8B6AG4AXMB/wHNAZYBRwH/Ab8BggEuAf8BvwGCAS4B/wG/AYEBLgH/Ab8BgQEuAf8BvgGBAS4B
/wG/AYIBMAH/AYUBbgFGAfUDLAFDUAADAwEEAkcBSAGDASUBMgGkAf8BOgFgAboB/wEnAUABZwH/
AS0BSgGSAf8BVQFaAWMB6QMsAUMDAwEEFAAEAgM1AVYDAAH/Ax4B+wMxAU4DAgEDFAAEAQMcAScB
WwFhAWQB3gFfAaYBzAH/AWMBrAHQAf8BZgGzAdQB/wFeAaQBxQH/A04BlgMJAQwgAAQBAaoBUgEp
Af8B0QFrAT0B/wHQAWUBNAH/AdABZQEzAf8B0AFmATMB/wHRAWYBMwH/AdEBZwEzAf8BygFRARkB
/wHLAVMBGgH/AcwBVAEbAf8BzQFWARwB/wHOAVgBHgH/Ac8BWgEgAf8B0AFcASEB/wHQAV4BIgH/
AdEBYAEkAf8B0wFiASUB/wHTAWQBJgH/AdUBZgEoAf8B1QFoASkB/wHXAWoBKxn/Ad4BeAE1Af8B
3wF6ATcB/wHgAXwBOAH/AeABfQE5Af8B4QF/ATsB/wHiAYEBPAH/AeMBggE9Af8B4wGDAT0B/wHk
AYQBPgH/AeQBhQE/Af8B5QGGAUAB/wHlAYYBQAH/AeUBhgFAAf8B5QGGAUAB/wHlAYYBQAH/AeUB
hgFAAf8B5AGFAT8B/wHkAYQBPgH/AeMBgwE+Af8B4wGPAVkB/wMrAUEDBgEIBAADRQF8A+cB/wPx
Af8D2AH/AjYBpAH/Ai4BrAH/AiwBqwH/AioBqgH/AicBqQH/AiUBqAH/AiIBpwH/AiABpgH/Ah4B
pQH/AhsBpAH/Ag8BnwH/AgEBmQH/AgABmQH/AgABmQH/AgABmQH/AgABmQH/AgABmwH/AmUBqAH/
A+oB/wPyAf8D8gH/Au0B8gH/Ag4BpgH/AgABogH/AgABpAH/AgABpQH/AgABpgH/AgABpwH/AgAB
qAH/AgABqQH/AgABqgH/AgABqwH/AgABrAH/AgABrgH/AgABrwH/AgABsAH/AgABsQH/AgABsgH/
AgABswH/AgcBpgH/AqsBrAH/A8UB/wPBAf8DRQF8NAADGgEkA1YBqwKYAZcB+wGaAZkBmAH/AasB
qgGpAf8BmwKaAf8BcAJuAegDVAGpAy4BSAgAAlIBUQGkAcUBhAEqAf8BwAGAASkB/wHBAYEBKQH/
AcYBhQErAf8B0gGOATMB/wHrAbwBcwH/AcYBiwE5Af8BwgGGATcB/wHDAYcBOQH/AcQBiAE7Af8B
xAGJAT0B/wHEAYkBPgH/AcQBiQE+Af8BhQFzAVAB9AMpAT1QAAMQARUCXAFhAdkBCAEKAbgB/wE2
AVgBsgH/AR0BMAFVAf8BMAFSAZQB/wNUAasDFQEdFAADCAEKA1IBoAEBAQIBAwH/AQMBBQENAf8D
TQGTAwsBDhQAAwoBDQNNAZMBUwGWAb4B/wFiAaoBzQH/AWQBrwHPAf8BZAGvAc0B/wFgAWQBZwHh
AxwBJwQBIAAEAQGsAVMBKwH/AdABZAE0Af8BzwFlATMB/wHQAWUBMwH/AdEBZQEzAf8B0AFmATMB
/wHRAWcBMwH/AdEBZwEzAf8BywFSARkB/wHLAVQBGwH/AcwBVQEcAf8BzQFXAR0B/wHOAVkBHwH/
Ac8BWwEgAf8B0AFdASIB/wHRAV4BIwH/AdIBYQEkAf8B0wFiASYB/wHUAWQBJwH/AdUBZgEoAf8B
1gFpASoZ/wHdAXYBNAH/Ad0BdwE1Af8B3gF6ATcB/wHfAXsBOAH/AeABfAE5Af8B4QF+AToB/wHh
AX8BOwH/AeIBgAE7Af8B4gGBATwB/wHjAYIBPQH/AeMBggE9Af8B4wGDAT0B/wHjAYMBPQH/AeMB
gwE9Af8B4wGDAT0B/wHjAYIBPQH/AeMBggE9Af8B4gGBATwB/wHiAYABOwH/AeEBigFUAf8BMQIw
AUwDBwEJBAADSAGDA+oB/wPyAf8C0QHSAf8CNgGlAf8CMwGuAf8CMQGtAf8CLgGsAf8CLAGrAf8C
KgGqAf8CJwGpAf8CJQGoAf8CIwGnAf8CIAGmAf8CHgGlAf8CGAGjAf8CCAGcAf8CAAGZAf8CAAGZ
Af8CAAGZAf8CAAGZAf8CKwGdAf8D2QH/A/IB/wPyAf8D8wH/AlEBvAH/AgABoAH/AgABoQH/AgAB
ogH/AgABowH/AgABpAH/AgABpQH/AgABpwH/AgABqAH/AgABqQH/AgABqgH/AgABqwH/AgABrAH/
AgABrQH/AgABrgH/AgABsAH/AgABsQH/AgEBpAH/AqUBqAH/A8YB/wPDAf8DSAGDPAADVQGvAY8C
jgH/AXcCdgH/AZABjwGOAf8DQAFuEAADFgEeAX8BawFQAfABwQGBASkB/wG+AX4BJwH/AcABfwEo
Af8BxwGFASsB/wHZAZgBPgH/AekBsgFeAf8ByAGNAT8B/wHGAYoBPgH/AcUBigE+Af8BxQGKAT4B
/wHFAYoBPgH/AcUBigE+Af8BxQGKAT4B/wF5AWoBUgHwAyABLkwABAIDNQFVATgBQAGZAf0BMQFM
AakB/wE0AVQBngH/ARYBJAFBAf8BOwFBAVwB+AM6AWEDBgEIEAADGgEkA1UB5wEdATIBRQH/AQIB
BAELAf8DXAHZAyABLQQBDAAEAgMsAUMBRQFTAVYB9AFQAYsBqAH/AWABqAHKAf8BXAGeAckB/wFc
AYABnQH+Az4BawMFAQYkAAQBAasBUwErAf8B0AFlATMB/wHQAWUBNAH/AdABZQE0Af8B0AFlATMB
/wHQAWYBMwH/AdEBZgEzAf8B0QFnATMB/wHRAWcBMwH/AdEBZgEyAf8BzAFUARsB/wHNAVYBHAH/
Ac0BWAEeAf8BzgFaAR8B/wHPAVwBIQH/AdABXQEiAf8B0QFfASMB/wHSAWEBJQH/AdMBYwEmAf8B
1AFkAScB/wHVAWcBKRn/AdsBcwEyAf8B3AF1ATQB/wHdAXcBNQH/Ad4BeAE2Af8B3wF6ATcB/wHf
AXsBOAH/AeABfAE5Af8B4AF9ATkB/wHhAX4BOgH/AeEBfwE7Af8B4QF/ATsB/wHiAYABOwH/AeIB
gAE7Af8B4gGAATsB/wHiAYABOwH/AeEBfwE7Af8B4QF/ATsB/wHhAX4BOgH/AeABfQE5Af8B4AGG
AVAB/wM1AVYDBgEIBAADRwGBA+sB/wPzAf8C0QHSAf8COwGmAf8COQGwAf8CNgGvAf8CNAGuAf8C
MQGtAf8CLwGsAf8CLQGrAf8CKgGqAf8CKAGpAf8CJgGoAf8CIwGnAf8CIQGmAf8CHgGlAf8CFQGh
Af8CBQGbAf8CAAGZAf8CAAGZAf8CBAGZAf8CuwHEAf8D8gH/A/IB/wPyAf8CmwHVAf8CAAGdAf8C
AAGeAf8CAAGfAf8CAAGgAf8CAAGhAf8CAAGjAf8CAAGkAf8CAAGlAf8CAAGmAf8CAAGnAf8CAAGo
Af8CAAGpAf8CAAGqAf8CAAGsAf8CAAGtAf8CAAGuAf8CAAGfAf8CpgGoAf8DxwH/A8UB/wNHAYE4
AAQCA2EB1gGcAZsBmgH/AZ0BnAGbAf8BlAGSAZEB/wNcAcMUAAMxAU4BsgF+ASsB/AG+AX0BJwH/
AbsBewEmAf8BvgF9AScB/wHHAYQBKwH/AdsBmQE9Af8B5wGsAVEB/wHJAY0BPwH/AcYBigE9Af8B
xgGKAT4B/wHGAYoBPgH/AcYBigE+Af8BxgGKAT4B/wHFAYoBPgH/AWkBZQFeAeIDEgEXTAADCAEK
AlYBVwGyARYBGAGSAf8BJQE3AZ4B/wEkATUBkgH/ARMBHgFLAf8DWwHNAyABLQQBCAADBQEGA0QB
eQE2AWEBfgH/AQ8BGQEuAf8CAAEEAf8CCgELAf4DQAFxAwcBCQwAAxIBFwNXAbwCAgE7Af8BNAFb
AXQB/wFbAZ4BwgH/AUYBeAG8Af8CWQFbAcADEQEWKAAEAQGpAVEBKAH/Ac8BZwE3Af8B0AFkATQB
/wHPAWUBNAH/AdABZQEzAf8B0QFlATMB/wHQAWYBMwH/AdEBZwEzAf8B0gFnATMB/wHSAWgBMwH/
AdIBaQE0Af8BzQFXAR8B/wHNAVcBHQH/Ac4BWQEeAf8BzwFaASAB/wHQAVwBIQH/AdABXgEiAf8B
0QFgASQB/wHSAWEBJQH/AdMBYwEmAf8B1AFlAScZ/wHaAXEBMQH/AdsBcwEyAf8B3AF0ATMB/wHd
AXYBNAH/Ad0BdwE1Af8B3gF4ATYB/wHeAXoBNwH/Ad8BewE3Af8B3wF7ATgB/wHgAXwBOQH/AeAB
fAE5Af8B4AF9ATkB/wHgAX0BOQH/AeABfQE5Af8B4AF9ATkB/wHgAX0BOQH/AeABfAE5Af8B3wF7
ATgB/wHfAXsBNwH/Ad4BgQFLAf8DLwFJAwYBBwQAA0QBeAPrAf8D9AH/AtgB2QH/AkIBpAH/Aj0B
sQH/AjsBsQH/AjkBsAH/AjYBrwH/AjQBrgH/AjIBrQH/Ai8BrAH/Ai0BqwH/AioBqgH/AigBqQH/
AiYBqAH/AiMBpwH/AiEBpgH/Ah4BpQH/AhQBoQH/AgYBmwH/AgABmQH/ApIBuQH/A/EB/wPyAf8D
8gH/AuEB7gH/AgQBnAH/AgABnAH/AgABnQH/AgABngH/AgABnwH/AgABoAH/AgABoQH/AgABogH/
AgABowH/AgABpAH/AgABpgH/AgABpwH/AgABqAH/AgABqQH/AgABqgH/AgABqwH/AgUBlwH/Aq0B
rgH/A8gB/wPEAf8DRAF4OAADHgEqAcEBvwG+Af8BxgHEAcMB/wHCAcEBvwH/AbQBsgGxAf8BiQGE
AYAB/gMLAQ4UAAM7AWMBvgGBAT0B/QG7AXoBJgH/AbcBeAElAf8BvAF7ASYB/wHFAYIBKQH/AdoB
lQE4Af8B6AGqAUwB/wHLAY4BPwH/AccBigE9Af8BxwGKAT4B/wHHAYoBPgH/AccBigE+Af8BxgGK
AT4B/wHGAYoBPgH/AloBWAG9BAJIAAQBAyEBMAFIAUoBcwHzASQBNQGdAf8BRAFxAbAB/wEvAUsB
jwH/ATYBVQGAAf4DSAGEAwwBEAgAAxgBIQJdAWIB3AErAUkBYQH/AgEBCAH/AgABAQH/AgABBgH/
A1sBygMbASYEAQQAAwUBBgM9AWgCFAEjAf0CAAEbAf8BEQEdATQB/wFeAaQBwAH/AUgBcwF7AfYD
LQFFBAIsAAGnAU4BJgH/AdIBdQFLAf8B0AFlATMB/wHQAWUBNAH/AdABZQE0Af8B0AFlATMB/wHQ
AWYBMwH/AdEBZgEzAf8B0QFnATQB/wHRAWcBMwH/AdIBaAE0Af8B0wFpATQB/wHTAWoBNQH/Ac0B
VwEeAf8BzgFZAR8B/wHPAVsBIAH/AdABXAEhAf8B0QFeASIB/wHRAWABJAH/AdIBYQElAf8B0wFj
ASYZ/wHZAW8BLwH/AdoBcQEwAf8B2wFyATEB/wHbAXMBMgH/AdwBdQEzAf8B3QF2ATQB/wHdAXcB
NQH/Ad4BeAE1Af8B3gF4ATYB/wHeAXkBNgH/Ad4BegE3Af8B3wF6ATcB/wHfAXoBNwH/Ad8BegE3
Af8B3wF6ATcB/wHeAXoBNwH/Ad4BeQE2Af8B3gF4ATYB/wHeAXgBNQH/Ad0BfAFHAf8DIQEvAwQB
BQQAAzoBYQPlAf8D9QH/A94B/wJQAaMB/wJCAbQB/wJAAbMB/wI+AbIB/wI7AbEB/wI5AbAB/wI2
Aa8B/wI0Aa4B/wIyAa0B/wIvAawB/wItAasB/wIrAaoB/wIoAakB/wImAagB/wIjAacB/wIhAaYB
/wIfAaUB/wIkAaYB/wK3Ac4B/wPxAf8D8gH/A/IB/wP0Af8COgGvAf8CAAGZAf8CAAGaAf8CAAGb
Af8CAAGcAf8CAAGdAf8CAAGfAf8CAAGgAf8CAAGhAf8CAAGiAf8CAAGjAf8CAAGkAf8CAAGlAf8C
AAGmAf8CAAGoAf8CAAGpAf8CEQGOAf8DswH/A8kB/wPDAf8DOgFhOAADJQE3AeIB4AHfAf8B4wHh
AeAB/wHaAdgB1gH/AcYBxAHCAf8BowGeAZgB/wMQARUYAAM3AVoBoAFtAUEB+QG3AXYBJQH/AbMB
cwEjAf8BtwF2ASQB/wHBAX4BKAH/AdUBkAE0Af8B6AGpAUkB/wHMAY8BQAH/AcgBiwE9Af8BxwGL
AT0B/wHHAYsBPgH/AccBiwE+Af8BxwGLAT4B/wHGAYoBPQH/AzsBY0wAAwQBBQNJAYcBWQGPAcUB
/wFfAaMBzgH/AUcBegGdAf8BVQGTAcMB/wFbAVwBZgHnAysBQgMCBAMBBAI/AUABbgE2AWABfQH/
AQ4BFwEfAf8CAAEEAf8CAAEBAf8CAAEQAf8CFAEqAfwDOwFkAwUBBgQBAxwBJwNaAd0CAAEVAf8C
AAEcAf8BAQECARgB/wEzAVcBbAH/A08BmQMJAQwwAANMAZAB1wGHAWMB/wHPAWUBNAH/AdABZQE0
Af8BzwFlATQB/wHQAWUBNAH/AdEBZQEzAf8B0AFmATMB/wHRAWcBMwH/AdIBZwEzAf8B0QFoATMB
/wHSAWgBNAH/AdMBagE0Af8B0wFqATUB/wHTAWsBNQH/Ac4BWQEfAf8BzwFbASAB/wHQAV0BIgH/
AdEBXgEjAf8B0gFgASQB/wHTAWIBJRn/AdgBbQEtAf8B2QFuAS4B/wHaAXABLwH/AdoBcQEwAf8B
2wFyATEB/wHbAXMBMgH/AdwBdAEzAf8B3AF1ATMB/wHdAXYBNAH/Ad0BdgE0Af8B3QF3ATUB/wHd
AXcBNQH/Ad0BdwE1Af8B3QF3ATUB/wHdAXcBNQH/Ad0BdwE1Af8B3QF2ATQB/wHdAXYBNAH/AdwB
dQE0Af8B3AF3AUIB/wMbASUEAgQAAyoBQAPaAf8D9gH/A+cB/wJjAaIB/wJHAbUB/wJFAbUB/wJC
AbQB/wJAAbMB/wI+AbIB/wI7AbEB/wI5AbAB/wI3Aa8B/wI0Aa4B/wIyAa0B/wIwAawB/wItAasB
/wIrAaoB/wIoAakB/wImAagB/wJ0AbUB/wLLAdIB/wPWAf8D4QH/A+kB/wPuAf8D8gH/AoQBywH/
AgABmQH/AgABmQH/AgABmQH/AgABmgH/AgABmwH/AgABnAH/AgABnQH/AgABngH/AgABnwH/AgAB
oAH/AgABogH/AgABowH/AgABpAH/AgABpQH/AgABpQH/AiUBhgH/A7wB/wPKAf8DvwH/AyoBQDgA
AwoBDQOaAfMB8AHtAesB/wHdAdoB1wH/Ab4BugG3Af8DZAHbBAEcAAMuAUcBiQFvAUYB9AGxAXEB
IwH/Aa0BbgEiAf8BsAFxASMB/wG7AXkBJgH/AdABjQEyAf8B6AGpAUkB/wHMAY8BPwH/AcgBiwE9
Af8ByAGLAT0B/wHIAYsBPQH/AcgBiwE+Af8BxwGLAT4B/wFlAWMBXQHfAwIBA0wAAxIBFwFdAWQB
ZgHcAVcBlAG7Af8BVQGSAcEB/wFMAYABwAH/AUQBeAGrAf8DUgGoAxQBGwMJAQsCVQFXAbQBFwEo
AUQB/wEBAQIBBgH/AgABAQH/AgABDwH/AgABEwH/AgABDwH/A1MBpwMMARADCgENA00BkgIAAQcB
/wIAARQB/wIAAQ8B/wIAAQoB/wNZAeMDHQEpBAEwAAMWAR4B2gGSAXIB/wHPAWQBNAH/AdABZQEz
Af8B0AFlATQB/wHQAWUBNAH/AdABZQE0Af8B0QFmATQB/wHQAWYBMwH/AdEBZwEzAf8B0gFnATMB
/wHSAWgBMwH/AdIBaQE0Af8B0wFqATUB/wHTAWoBNQH/AdMBawE1Af8B1AFrATUB/wHRAWABJgH/
AdABXQEiAf8B0QFeASMB/wHSAWABJBn/AdcBagEsAf8B2AFsAS0B/wHYAW0BLgH/AdkBbgEuAf8B
2QFvAS8B/wHaAXABMAH/AdoBcQExAf8B2wFyATEB/wHbAXMBMgH/AdsBcwEyAf8B3AF0ATIB/wHc
AXQBMgH/AdwBdAEyAf8B3AF0ATIB/wHcAXQBMgH/AdwBdAEyAf8B2wFzATIB/wHbAXMBMgH/AdsB
cgExAf8B0QFsATgB/wMVARwEAQQAAxIBFwK0AbUB/AP3Af8D8QH/An4BpgH/Ak0BtQH/AkoBtwH/
AkgBtgH/AkUBtQH/AkMBtAH/AkEBswH/Aj4BsgH/AjwBsQH/AjoBsAH/AjcBrwH/AjUBrgH/AjIB
rQH/AjABrAH/Ai4BqwH/AisBqgH/AikBqQH/AikBqQH/AjoBqAH/Ak8BqQH/AmgBrQH/AoUBtAH/
AqUBvwH/Ap8BygH/AgkBnQH/AgMBmgH/AgABmQH/AgABmQH/AgABmQH/AgABmQH/AgABmgH/AgAB
mwH/AgABnAH/AgABngH/AgABnwH/AgABoAH/AgABoQH/AgABogH/AgABoAH/AkQBggH/A8YB/wPL
Af8CoAGhAfwDEgEXPAADLwFJA10BygNpAeMDWQG5AyEBLyQAAykBPgGHAW4BQwH1AasBbQEhAf8B
qAFrASAB/wGsAW0BIQH/AbcBegEoAf8BzgGNATMB/wHmAasBUQH/AcoBiwE8Af8ByQGKATwB/wHJ
AYoBPAH/AcgBiwE9Af8ByQGLAT0B/wHHAYsBPQH/AyoBQEwABAIDNgFZAWkBhgGmAf4BXQGiAckB
/wFYAZYBygH/AVUBkgHGAf8BUQFvAYUB9wM5AV4DDwEUA1wByAEFAQgBDQH/AgABAQH/AgABCgH/
AgABEwH/AgABEgH/AgABDgH/A1gBuAMPARQDLAFDAj0BPwHzAgABCAH/AgABGgH/AgABDgH/AgoB
DgH+A0ABbwMFAQY0AAMFAQYB3AGWAXcB/wHPAWQBMwH/Ac8BZQE0Af8B0AFlATQB/wHQAWYBNAH/
AdABZQE0Af8B0AFlATMB/wHQAWYBMwH/AdEBZgE0Af8B0QFnATQB/wHRAWcBMwH/AdIBaAE0Af8B
0wFpATQB/wHTAWoBNQH/AdMBawE1Af8B1AFrATUB/wHUAWwBNSX/AdYBaQEqAf8B1gFqASsB/wHX
AWsBLAH/AdgBbAEtAf8B2AFtAS0B/wHZAW4BLgH/AdkBbgEuAf8B2QFvAS8B/wHaAXABLwH/AdoB
cAEwAf8B2gFxATAB/wHaAXEBMQH/AdoBcQExAf8B2gFxATEB/wHaAXEBMQH/AdoBcQEwAf8B2gFx
ATAB/wHaAXABMAH/AdkBbwEwAf8BwwFjAS8B/wMOARIIAAQCA2EB2QP3Af8D9gH/AqMBtgH/AlEB
sAH/Ak8BuQH/Ak0BuAH/AkoBtwH/AkgBtgH/AkYBtQH/AkMBtAH/AkEBswH/Aj4BsgH/AjwBsQH/
AjoBsAH/AjcBrwH/AjUBrgH/AjMBrQH/AjABrAH/Ai4BqwH/AisBqgH/AikBqQH/AicBqAH/AiQB
pwH/AiIBpwH/AiABpgH/Ah0BpQH/AhsBpAH/AhgBowH/AhUBoQH/Ag8BnwH/AgoBnQH/AgcBnAH/
AgQBmwH/AgIBmgH/AgEBmgH/AgABmwH/AgABnAH/AgABnQH/AgABngH/AgABoAH/AgABkgH/AnIB
jQH/A8wB/wPMAf8DYQHZBAJAAAMJAQsDHgEqAy8BSQI+AT0BaQNJAYgDUwGnA1kBuwFfAl0ByQFi
Al4B1wJVAVMBqhAAAz4BagGwAXIBIgH/AaYBagEfAf8BpgFqAR4B/wGrAW4BIAH/AbUBdwElAf8B
1gGfAVIB/wHVAZwBTwH/AckBigE7Af8ByQGKATsB/wHJAYoBPAH/AckBiwE8Af8ByQGLATwB/wJH
AUYBgFAAAwkBCwFWAlkBtgFnAa0B0gH/AWYBtAHWAf8BYwGuAdQB/wFcAaUBxQH/A10ByQMiATED
VAGrAgEBCQH/AgABEAH/AgABDQH/AgABEQH/AgABEAH/AgABDQH/A04BlgMYASEDWQG7AgABCgH/
AgABCQH/AgABBAH/AgABCQH/A1kBwwMSARg4AAQCAbcBZQFAAf8B0AFlATUB/wHPAWQBMwH/Ac8B
ZQE0Af8B0AFlATQB/wHPAWUBNAH/AdABZgE0Af8B0QFlATMB/wHQAWYBMwH/AdEBZwEzAf8B0gFn
ATMB/wHRAWcBMwH/AdIBaAE0Af8B0wFpATQB/wHTAWoBNQH/AdMBawE1Af8B1AFrATUl/wHVAWYB
KAH/AdUBZwEpAf8B1gFpASoB/wHWAWoBKwH/AdcBagEsAf8B1wFrASwB/wHYAWwBLQH/AdgBbQEt
Af8B2AFtAS4B/wHZAW4BLgH/AdkBbgEuAf8B2QFuAS4B/wHZAW8BLwH/AdkBbwEvAf8B2QFuAS4B
/wHZAW4BLgH/AdkBbgEuAf8B2AFtAS4B/wHYAW0BNAH/AVMCUQGiAwgBCgwAA04BmAPzAf8D9wH/
AtAB0gH/AloBowH/AlQBugH/AlIBugH/Ak8BuQH/Ak0BuAH/AkoBtwH/AkgBtgH/AkYBtQH/AkMB
tAH/AkEBswH/Aj8BsgH/AjwBsQH/AjoBsAH/AjcBrwH/AjUBrgH/AjMBrQH/AjABrAH/Ai4BqwH/
AiwBqgH/AikBqgH/AicBqAH/AiUBqAH/AiIBpwH/AiABpgH/Ah0BpQH/AhsBpAH/AhkBowH/AhYB
ogH/AhQBoQH/AhIBoAH/Ag8BnwH/Ag0BngH/AgoBnQH/AggBnQH/AgYBnQH/AgMBnQH/AgEBnQH/
AgcBeQH/AqkBrAH/A84B/wPLAf8DTgGYPAAEAQFwAWsBXgHlAb0BgAE4Af4BygGNATAB/wGYAXUB
RQH/AZYBZwEoAf8BpAFwASoB/wGwAXgBLQH/AboBfwEwAf8BwgGEATMB/wHJAYkBNQH/AYgBcQFR
AfMDBAEFDAADDQERAbABdAEhAf8BpwFsAR0B/wGkAWoBHQH/AacBbAEeAf8BrwFyASAB/wG6AX8B
LgH/Ad8BtAF5Af8BygGLATsB/wHKAYoBOwH/AcoBiwE7Af8BygGLATwB/wHKAYsBPAH/AlIBUQGk
UAAEAQMjATIBZAF4AYkB9AFdAaEB0QH/AWUBsgHVAf8BYAGoAcYB/wEkATkBQgH+A0YBgQMxAU4C
QwFIAfUBBAEFARcB/wIAARQB/wIAARIB/wIAARQB/wNTAesDKQQ9AWkCCgEPAf4CAAEFAf8CAAEF
Af8CAAEDAf8DMwH3Ay4BRwMCAQM8AAFfAlwByAHYAYcBYgH/Ac8BZQE0Af8BzwFkATQB/wHQAWUB
MwH/AdABZQE0Af8B0AFlATQB/wHQAWUBNAH/AdEBZQEzAf8B0AFmATMB/wHRAWcBMwH/AdIBZwEz
Af8B0QFoATMB/wHSAWgBNAH/AdMBaQE0Af8B0wFqATUB/wHTAWsBNSX/AdkBcwE5Af8B2AFzATkB
/wHZAXMBOQH/AdcBbgEyAf8B1gFpASsB/wHWAWkBKgH/AdYBagErAf8B1wFqASwB/wHXAWsBLAH/
AdcBawEsAf8B1wFrASwB/wHYAWwBLQH/AdgBbAEtAf8B2QFvATEB/wHbAXUBOQH/AdwBdwE8Af8B
2wF3ATwB/wHbAXgBPAH/AdsBdwE8Af8DGwEmAwIBAwwAAzABSgPdAf8D+QH/A+wB/wJ6AaEB/wJZ
AbgB/wJWAbwB/wJUAbsB/wJSAboB/wJPAbkB/wJNAbgB/wJLAbcB/wJIAbYB/wJGAbUB/wJEAbQB
/wJBAbMB/wI/AbIB/wI8AbEB/wI6AbAB/wI4Aa8B/wI1Aa4B/wIzAa0B/wIxAa0B/wIuAasB/wIs
AasB/wIpAaoB/wInAakB/wIlAagB/wIiAacB/wIgAaYB/wIeAaUB/wIbAaQB/wIZAaMB/wIWAaIB
/wIUAaEB/wISAaAB/wIPAZ8B/wINAZ4B/wILAZ0B/wIIAZ0B/wIGAZYB/wI6AXUB/wPFAf8DzwH/
A8IB/wMwAUpAAAF0AWwBXAHnAd8BmgEzAf8B4wGfATUB/wHrAckBlwH/AdABjgE2Af8B0AGOATYB
/wHPAY0BNgH/Ac8BjQE3Af8BzgGNATcB/wHOAY0BNwH/AcsBjAE4Af8DLQFFDAADCQELAZoBfgEr
Af4BpwFvAR4B/wGlAW0BHgH/AagBbwEeAf8BrQF0ASAB/wGtAXUBJwH/AdcBqQFsAf8BygGLAToB
/wHKAYsBOwH/AcoBiwE7Af8BygGLATsB/wHKAYsBOwH/A1UBrVQAAwQBBQNKAYkBaQGtAdEB/wFQ
AYwBpwH/ARwBMAE4Af8BSwGEAZwB/wFZAVwBXgHlAy0BRAM0AVQDYAHbAkwBWQH+AjYBQAH9A1wB
0gMwAUsDIAEtA1oB3QIAAQcB/wIAAQIB/wIAAQIB/wIAAQcB/wNQAZwDCgENQAADCQELAd4BmwF8
Af8B0AFlATUB/wHPAWQBMwH/Ac8BZQE0Af8B0AFlATQB/wHQAWUBNAH/AdABZQE0Af8B0AFlATQB
/wHRAWYBNAH/AdABZgEzAf8B0QFnATMB/wHSAWcBMwH/AdEBaAEzAf8B0gFoATQB/wHTAWkBNAH/
AdMBagE1Af8B0wFrATUB/wHTAWsBNgH/AdQBbAE2Af8B1QFtATYB/wHWAW4BNwH/AdYBbgE3Af8B
1gFuATcB/wHWAXABOAH/AdcBcAE3Af8B2AFxATgB/wHYAXIBOAH/AdkBcwE5Af8B2QF0ATkB/wHZ
AXQBOgH/AdkBdAE6Af8B2QF1AToB/wHZAXYBOgH/AdoBdgE7Af8B2gF3ATsB/wHaAXcBOwH/AdoB
dwE8Af8B2gF3ATwB/wHaAXcBPAH/AdoBdwE8Af8B2gF3ATsB/wHaAXcBOwH/AdoBdwE7Af8BxQFl
ATAB/wMQARUQAAMFAQYCbgFvAecD+gH/A/gB/wKyAbsB/wJeAaoB/wJcAb0B/wJZAb0B/wJXAbwB
/wJVAbsB/wJSAboB/wJQAbkB/wJOAbgB/wJLAbcB/wJJAbYB/wJGAbUB/wJEAbQB/wJCAbMB/wI/
AbIB/wI9AbEB/wI7AbAB/wI4Aa8B/wI2Aa4B/wJPAbUB/wLHAeAB/wLxAfMB/wLJAeUB/wJIAbUB
/wIoAakB/wIlAagB/wIjAacB/wIgAaYB/wIeAaUB/wIcAaQB/wIZAaMB/wIXAaIB/wIVAaEB/wIS
AaAB/wIQAZ8B/wINAZ4B/wIMAX4B/wKHAZUB/wPQAf8D0AH/A24B5wMFAQZAAAJbAVkBwAHkAZ0B
NAH/AecBoAE2Af8B8QHPAZsB/wHRAY4BNQH/AdABjgE1Af8B0AGOATYB/wHQAY0BNgH/Ac8BjQE2
Af8BzwGNATYB/wHPAY0BNwH/AlYBVQGuDAADMwFRAYABVAEbAf8BfAFRARkB/wF7AVABGQH/AX0B
UgEaAf8BgwFWARsB/wGWAWUBJwH/AcgBjwFEAf8BywGMAToB/wHLAYwBOgH/AcsBjAE7Af8BywGM
ATsB/wHKAYsBOwH/A1EBnlgAAxIBGANeAd0BGgEtATYB/wFeAaUBwwH/AVsBngG6Af8BEQEcAS0B
/wNTAaYDFQEcAwwBDwMdASgDHAEnAwwBEAMMAQ8DTQGSAgABAgH/AQEBAgEDAf8CAQECAf8BBwEL
ARAB/wNVAeQDHgEqBAFAAAQBAbEBXgE5Af8B0QFrAT0B/wHQAWUBNQH/Ac8BZAE0Af8BzwFlATQB
/wHQAWUBNAH/AdABZgE0Af8B0AFlATQB/wHQAWUBNAH/AdEBZgE0Af8B0QFmATQB/wHRAWcBMwH/
AdIBZwEzAf8B0QFoATMB/wHSAWkBNAH/AdMBaQE0Af8B0wFqATUB/wHUAWoBNQH/AdMBawE2Af8B
1AFsATYB/wHVAWwBNgH/AdUBbQE2Af8B1gFuATcB/wHWAW8BNwH/AdYBbwE3Af8B1gFwATgB/wHX
AXABOAH/AdgBcQE4Af8B2AFyATkB/wHYAXMBOAH/AdkBcwE5Af8B2QF0ATkB/wHZAXQBOgH/AdkB
dAE6Af8B2QF0AToB/wHZAXUBOgH/AdkBdQE6Af8B2QF1AToB/wHZAXUBOgH/AdkBdQE6Af8B2QF1
AToB/wHZAXQBOgH/AdkBdAE6Af8DSgGJAwYBCBQAA0gBhAPtAf8D+gH/A+UB/wJ4AZ4B/wJhAbkB
/wJeAb8B/wJcAb4B/wJaAb0B/wJXAbwB/wJVAbsB/wJSAboB/wJQAbkB/wJOAbgB/wJLAbcB/wJJ
AbYB/wJHAbUB/wJEAbQB/wJCAbMB/wI/AbIB/wI9AbEB/wI9AbEB/wLDAdMB/wPxAf8D8gH/A/IB
/wLUAekB/wIuAasB/wIqAaoB/wIoAakB/wIlAagB/wIjAacB/wIhAaYB/wIeAaUB/wIcAaQB/wIZ
AaMB/wIXAaIB/wIVAaEB/wISAZcB/wI3AXEB/wPBAf8D0gH/A8sB/wNIAYREAANGAX8B6wGiATcB
/wHrAaMBNwH/AfcB0wGXAf8B0wGSAT0B/wHRAY8BNQH/AdEBjgE1Af8B0QGOATUB/wHQAY4BNgH/
AdABjgE2Af8BzwGNATYB/wGxAYABPAH+Ay4BRwQAAhoBGQEjAWUBXgFaAeMBbQFFARUB/wFtAUUB
FAH/AW0BRAEUAf8BcAFHARYB/wF6AVABGgH/AZoBaQEqAf8ByAGJATcB/wHMAYwBOQH/AcsBjAE6
Af8BywGMAToB/wHMAY0BOgH/AcsBjAE7Af8DRAF4WAAEAgM4AVwBXwGAAY8B/gFXAZcBwgH/AVwB
oQHJAf8BJAE/AVQB/wIvATEB9gM4AVsDBgEHCAADAgEDAysBQgI9AT4B8wEYASgBMAH/ARIBHgEk
Af8BGAEoAS8B/wELAgwB/gNAAXADBQEGSAADKQE+Ad8BnQF/Af8BzwFlATUB/wHPAWQBNAH/Ac8B
ZAE0Af8B0AFlATQB/wHQAWUBNAH/AdABZgE0Af8B0AFmATQB/wHQAWYBNAH/AdEBZgE0Af8B0QFm
ATQB/wHRAWcBMwH/AdIBZwEzAf8B0QFoATMB/wHSAWkBNAH/AdMBaQE0Af8B0wFqATUB/wHUAWoB
NQH/AdMBawE1Af8B1AFsATYB/wHUAW0BNgH/AdUBbQE2Af8B1QFuATcB/wHWAW8BOAH/AdYBbwE3
Af8B1gFvATcB/wHWAXABOAH/AdcBcAE4Af8B1wFwATgB/wHYAXEBOAH/AdgBcgE5Af8B2AFyATkB
/wHYAXMBOAH/AdkBcwE5Af8B2QFzATkB/wHZAXMBOQH/AdkBcwE5Af8B2QFzATkB/wHZAXMBOQH/
AdkBcwE5Af8B2QFzAToB/wHNAWsBNAH/AxMBGgQBFAADEgEYA4kB9QP6Af8D+QH/AroBwAH/AmcB
pAH/AmMBvwH/AmEBwAH/Al4BvwH/AlwBvgH/AloBvQH/AlcBvAH/AlUBuwH/AlMBugH/AlABuQH/
Ak4BuAH/AksBtwH/AkkBtgH/AkcBtQH/AkQBtAH/AkIBswH/AlQBswH/A9wB/wPyAf8D8gH/A/IB
/wP0Af8CSgG2Af8CLwGsAf8CLQGrAf8CKgGqAf8CKAGpAf8CJgGoAf8CIwGnAf8CIQGmAf8CHgGl
Af8CHAGkAf8CGgGhAf8CGgF3Af8CkwGdAf8D0gH/A9MB/wKFAYcB9QMSARhEAAMaASMBzAGJAS8B
/AHxAacBOQH/AfgBvgFlAf8B4AGyAXQB/wHSAY8BNgH/AdIBjwE1Af8B0gGPATUB/wHRAY4BNQH/
AdEBjgE1Af8B0QGOATYB/wHQAY4BNgH/AXkBaQFQAfADUAGaAW8BYAFNAfMBewFUASIB/wFvAUgB
GQH/AWUBPgESAf8BagFDARQB/wF4AU4BFwH/AYsBXgEhAf8BuAF9AS8B/wHOAY0BOAH/Ac0BjQE5
Af8BzQGNATkB/wHNAY0BOQH/AcwBjQE6Af8BzQGNAToB/wMmAThcAAMJAQwDWgG6AWkBsgHTAf8B
ZAGuAc0B/wE6AWUBdgH/ARIBHwEsAf8DWQHGAx0BKQQBBAADEQEWA1cBuQEbAS8BNgH/ATMBVgFl
Af8BEAEcASAB/wEcATABNwH/A1oBxAMSARhMAAQCAbIBYAE8Af8B0gFxAUUB/wHPAWUBNQH/Ac8B
ZAE0Af8BzwFkATQB/wHQAWUBNAH/AdABZQE0Af8B0AFmATQB/wHQAWYBNAH/AdABZQE0Af8B0QFm
ATQB/wHRAWYBNAH/AdEBZwEzAf8B0gFoATQB/wHSAWgBNAH/AdIBaAE0Af8B0gFpATQB/wHTAWoB
NAH/AdMBawE1Af8B5wGuAZAJ/wHWAXABPAH/AdUBbQE2Af8B1QFuATcB/wHWAW4BNwH/AdYBbwE3
Af8B1gFvATcB/wHWAW8BNwH/AdYBcAE4Af8B1wFwATgB/wHXAXEBOAH/AdcBcQE5Af8B1wFwATgB
/wHYAXEBOAH/AdgBcQE4Af8B2AFxATkB/wHYAXEBOQH/AdgBcQE4Af8B2AFxATkB/wHXAXEBOQH/
AlABTwGbAwYBCBwAA0kBhgPrAf8D+gH/A+8B/wKQAaUB/wJoAbAB/wJmAcEB/wJjAcEB/wJhAcAB
/wJfAb8B/wJcAb4B/wJaAb0B/wJYAbwB/wJVAbsB/wJTAboB/wJQAbkB/wJOAbgB/wJMAbcB/wJJ
AbYB/wJHAbUB/wJOAbQB/wPMAf8D8gH/A/IB/wPyAf8C7gHwAf8CQwGzAf8CNAGuAf8CMgGtAf8C
LwGsAf8CLQGrAf8CKgGqAf8CKAGpAf8CJgGoAf8CIwGnAf8CIQGlAf8CHwGKAf8CXgF9Af8DzAH/
A9UB/wPMAf8DSQGGTAACUQFQAZ0B+QGrATsB/wH6Aa0BPQH/AfMB0gGhAf8B0wGPATYB/wHTAY8B
NgH/AdIBjwE2Af8B0gGPATYB/wHSAY8BNQH/AdEBjgE2Af8B0QGOATYB/wHRAY4BNgH/AboBfgEv
Af8BiQFcASIB/wFvAUkBGQH/AWQBQQEVAf8BZQFCARUB/wFyAUwBGgH/AYwBXwEiAf8BtwF8AS8B
/wHOAY0BOAH/Ac4BjQE4Af8BzgGNATgB/wHOAY0BOQH/Ac4BjQE5Af8BzgGNATkB/wFlAWMBXwHa
BAFcAAQBAyQBNQFjAX8BjgH2AVYBlQGsAf8BWQGbAbMB/wFIAX0BlAH/AR8BLwE/Af4DRQF8AwsB
DgMFAQYDOwFkAR8BJwEqAf0BJwFCAUwB/wEvAVABXQH/AR4BMwE6Af8BNwE8AT8B9wMvAUkDAgED
UAADEAEVAeABnwGCAf8BzwFmATUB/wHQAWUBNQH/Ac8BZQE0Af8BzwFkATQB/wHQAWUBNAH/AdAB
ZQE0Af8B0AFmATQB/wHQAWYBNAH/AdABZgE0Af8B0QFmATQB/wHQAWYBMwH/AdEBZwE0Af8B0gFo
ATQB/wHSAWgBNAH/AdIBaAEzAf8B0gFpATQB/wH4AeYB3RH/AdQBbAE2Af8B1AFtATYB/wHVAW0B
NwH/AdUBbQE2Af8B1gFuATcB/wHWAW4BNwH/AdYBbwE4Af8B1gFwATgB/wHWAW8BNwH/AdYBbwE4
Af8B1gFwATgB/wHWAXABOAH/AdYBcAE4Af8B1gFwATgB/wHWAXABOAH/AdYBcAE4Af8B1gFwATgB
/wHAAWEBLwH/Aw8BFAQBHAADCgENA2kB4gP6Af8D+gH/AtwB3QH/An0BnQH/AmsBtwH/AmgBwwH/
AmYBwgH/AmQBwQH/AmEBwAH/Al8BvwH/AlwBvgH/AloBvQH/AlgBvAH/AlUBuwH/AlMBugH/AlEB
uQH/Ak4BuAH/AkwBtwH/AkkBtgH/AoABrQH/A9oB/wPsAf8D5wH/ApcBywH/AjwBsQH/AjkBsAH/
AjcBrwH/AjQBrgH/AjIBrQH/AjABrAH/Ai0BqwH/AisBqgH/AikBqQH/AiYBlQH/AkIBcgH/A70B
/wPWAf8D1QH/A2kB4gMKAQ1MAAMOARIBbwFpAWAB4AH+Aa8BPQL/AckBdQH/Ad8BqAFcAf8B1AGQ
ATYB/wHUAY8BNgH/AdMBjwE2Af8B0gGPATYB/wHSAY8BNgH/AdIBjwE2Af8B0gGPATYB/wHRAY8B
NgH/Ac8BjQE1Af8BwAGCATEB/wG2AXsBLgH/AbYBewEuAf8BvwGCATEB/wHNAYwBNQH/AdABjgE3
Af8BzwGOATcB/wHPAY0BOAH/Ac8BjQE4Af8BzwGOATgB/wHPAY4BOAH/Ac8BjgE5Af8DOgFgZAAD
BAEFA0sBjQFRAYQBmAH/AWgBtgHVAf8BYAGpAcQB/wFJAYABlQH/A1oB4gMpAT4DHQEpA18B2gEY
ASkBLwH/ATUBWgFoAf8BKAFFAU8B/wEbAS4BNQH/A1EBngMKAQ1UAAQBAWICWwHYAd8BnAF+Af8B
zwFmATUB/wHQAWUBNQH/Ac8BZQE0Af8BzwFkATQB/wHQAWUBNAH/AdABZQE0Af8B0AFmATQB/wHQ
AWYBNAH/AdABZQE0Af8B0QFmATQB/wHQAWYBMwH/AdEBZwE0Af8B0QFoATQB/wHSAWgBNAH/AdIB
aQE0Ff8B+QHrAeQB/wHTAWsBNgH/AdQBbAE2Af8B1AFsATYB/wHUAW0BNgH/AdUBbQE3Af8B1QFt
ATYB/wHVAW4BNwH/AdYBbgE3Af8B1gFuATcB/wHWAW8BOAH/AdYBbwE4Af8B1gFvATgB/wHWAW8B
OAH/AdYBbwE4Af8B1gFvATgB/wHVAW4BOAH/Ax0BKAMDAQQkAAMvAUkDvgH9A/sB/wP5Af8CywHO
Af8CeAGdAf8CbgG4Af8CawHDAf8CaQHDAf8CZgHCAf8CZAHBAf8CYgHAAf8CXwG/Af8CXQG+Af8C
WwG9Af8CWAG8Af8CVgG7Af8CUwG6Af8CUQG5Af8CTwG4Af8CTQG3Af8CawGxAf8CiAG6Af8CcQG7
Af8CQwG0Af8CQQGzAf8CPgGyAf8CPAGxAf8COQGwAf8CNwGvAf8CNQGuAf8CMgGtAf8CMAGrAf8C
LgGZAf8CPAFyAf8CrAGwAf8D2AH/A9gB/wO+Af0DLwFJVAADHwEsAXsBbwFcAeoB/wGzAUQB/wH5
AckBegH/AdcBlAE6Af8B1AGQATYB/wHUAZABNgH/AdMBjwE2Af8B0wGPATYB/wHTAY8BNgH/AdMB
jwE2Af8B0wGPATYB/wHTAY8BNgH/AdIBjwE2Af8B0gGPATYB/wHRAY4BNgH/AdEBjgE2Af8B0QGO
ATYB/wHRAY4BNgH/AdABjgE2Af8B0AGOATcB/wHQAY4BOAH/Ac8BjgE4Af8B0AGOATgB/wJbAVkB
wAQCaAADEwEaAV0CYwHfAVcBlQHHAf8BTQGGAZwB/wEwAVIBXwH/AQ0BFgEaAf8DVAGrA1EBoQE3
AWIBcgH/ATYBXQFqAf8BIAE2AT4B/wEgATUBPQH/AVoBXAFeAeYDHwEsBAFYAAMCAQMBrwFcATcB
/wHXAYABWgH/Ac8BZgE2Af8B0AFlATUB/wHPAWUBNAH/Ac8BZAE0Af8B0AFlATQB/wHQAWUBNAH/
AdABZgE0Af8B0AFlATQB/wHQAWYBNAH/AdEBZQEzAf8B0QFmATQB/wHRAWYBNAH/AdEBZwE0Af8B
0gFoATQV/wH7AfIB7gH/AdMBawE1Af8B1AFrATYB/wHUAWsBNgH/AdMBawE2Af8B1AFsATYB/wHU
AWwBNgH/AdQBbAE2Af8B1QFtATcB/wHVAW0BNwH/AdUBbQE3Af8B1QFtATcB/wHVAW0BNwH/AdUB
bQE3Af8B1QFtATcB/wHVAW0BNwH/AVkCVwG8AwcBCSwAA0sBiwPmAf8D+wH/A/cB/wLGAckB/wJ6
AZ0B/wJwAbUB/wJuAcQB/wJrAcQB/wJpAcMB/wJnAcIB/wJkAcEB/wJiAcAB/wJfAb8B/wJdAb4B
/wJbAb0B/wJYAbwB/wJWAbsB/wJUAboB/wJRAboB/wJPAbgB/wJNAbgB/wJKAbcB/wJIAbYB/wJF
AbUB/wJDAbQB/wJBAbMB/wI+AbIB/wI8AbEB/wI6AbAB/wI3Aa0B/wI1AZcB/wJCAXQB/wKoAa0B
/wPYAf8D2QH/A80B/wNLAYtcAAMcAScBZQFiAV0B1AH/AbcBTwH/AfMBuAFdAf8B1gGSATcB/wHV
AZEBNgH/AdUBkAE2Af8B1AGQATYB/wHUAY8BNgH/AdMBjwE2Af8B0wGPATYB/wHTAY8BNgH/AdMB
jwE2Af8B0gGPATYB/wHSAY8BNgH/AdIBjwE2Af8B0QGPATYB/wHRAY8BNgH/AdEBjwE2Af8B0QGO
ATYB/wHRAY4BNgH/AdABjgE3Af8BbQFnAVsB5AMUARtsAAQCAzkBXwFcAZQBqAH/AUYBeQGMAf8B
TgGJAZ0B/wFFAXkBiwH/AUEBZQFqAfkBQgFcAXcB+AFAAW4BfgH/ATMBVwFkAf8BHgEyATkB/wEQ
ARwBIAH/A0IBdAMGAQdgAAMEAQUB0AGJAWkB/wHQAWoBPQH/Ac8BZgE2Af8B0AFlATUB/wHPAWUB
NAH/Ac8BZAE0Af8B0AFlATQB/wHQAWUBNAH/AdABZgE0Af8B0AFlATQB/wHQAWYBNAH/AdEBZgE0
Af8B0QFmATQB/wHRAWYBNAH/AdEBZwE0Ff8B2QGDAVcB/wHTAWkBNAH/AdMBagE1Af8B0wFrATUB
/wHUAWsBNQH/AdQBbAE2Af8B1AFrATUB/wHUAWsBNgH/AdQBbAE2Af8B1AFrATYB/wHUAWwBNgH/
AdQBbAE2Af8B1AFsATYB/wHUAWwBNgH/AdQBbAE3Af8BmgFYASsB/AMLAQ4EASwAAwMBBANXAbUD
7gH/A/sB/wP4Af8CygHNAf8CgQGdAf8CcwGuAf8CcAHBAf8CbgHFAf8CbAHEAf8CaQHDAf8CZwHC
Af8CZAHBAf8CYgHAAf8CYAG/Af8CXQG+Af8CWwG9Af8CWQG9Af8CVgG7Af8CVAG7Af8CUQG6Af8C
TwG5Af8CTQG4Af8CSgG3Af8CSAG2Af8CRgG1Af8CQwG0Af8CQQGzAf8CPgGsAf8CPAGOAf8CUQF4
Af8CrwGzAf8D2gH/A9wB/wPTAf8DVwG1AwMBBGAAAwYBCANEAXoBmwGBAVoB8gHzAbEBTAH/AdcB
lAE3Af8B1QGRATYB/wHVAZEBNgH/AdUBkAE2Af8B1QGQATYB/wHUAZABNgH/AdQBjwE2Af8B1AGP
ATYB/wHTAY8BNgH/AdMBjwE2Af8B0wGPATYB/wHSAY8BNgH/AdIBjwE2Af8B0gGPATYB/wHSAY8B
NgH/AdEBjwE2Af8BbQFmAVwB4wMdASl0AAMJAQwCVwFYAbwBMgFSAXMB/wFBAXABiwH/AT4BawF7
Af8BVgGWAawB/wE3AV8BbQH/ARoBLAEyAf8BHQEyATkB/wEjATsBRAH/A1wByAMTARloAAMFAQYB
2gGYAXkB/wHQAWoBPQH/Ac8BZgE2Af8B0AFlATUB/wHPAWUBNAH/Ac8BZAE0Af8B0AFlATQB/wHQ
AWUBNAH/AdABZQE0Af8B0AFmATQB/wHQAWYBNAH/AdABZgE0Af8B0QFmATQB/wHRAWYBNAH/AdEB
ZgE0Av8C/gn/AfcB5QHbAf8B0gFpATQB/wHSAWgBNAH/AdIBaQE0Af8B0gFqATUB/wHTAWkBNAH/
AdMBagE0Af8B0wFqATUB/wHTAWsBNQH/AdQBawE1Af8B1AFrATYB/wHUAWsBNgH/AdQBbAE2Af8B
1AFsATYB/wHUAWwBOgH/AbMBVwEqAf8DDAEQBAE0AAMJAQsDXAHDA+4B/wP7Af8D+QH/A9oB/wKS
AaQB/wJ2AaIB/wJzAbgB/wJwAcMB/wJuAcUB/wJsAcQB/wJpAcMB/wJnAcIB/wJlAcEB/wJiAcAB
/wJgAb8B/wJdAb4B/wJbAb0B/wJZAb0B/wJWAbwB/wJUAbsB/wJSAboB/wJPAbkB/wJNAbgB/wJK
AbcB/wJIAbIB/wJGAaEB/wJEAYEB/wJuAYcB/wLCAcMB/wPeAf8D3QH/A9UB/wNcAcMDCQELbAAD
EgEYAlABTwGbAc4BmgE/AfwB4AGcATsB/wHVAZEBNgH/AdUBkQE2Af8B1QGRATYB/wHVAZEBNgH/
AdQBkAE2Af8B1AGQATYB/wHUAZABNgH/AdQBjwE2Af8B0wGPATYB/wHTAY8BNgH/AdMBjwE2Af8B
0wGPATYB/wHXAZQBOwH/A1gBuAMSARh4AAQBAyUBNgFKAlMB9AFCAXABhgH/AV4BowG8Af8BVAGT
AaoB/wE2AV4BbAH/ASQBPQFHAf8BCgERARQB/wE5AUEBRAH3AzABSwMCAQNsAAMFAQYB0AGJAWkB
/wHWAX4BVwH/Ac8BZgE2Af8B0AFlATUB/wHQAWUBNQH/Ac8BZAE0Af8BzwFlATQB/wHQAWUBNQH/
AdABZQE0Af8B0AFmATQB/wHQAWUBNAH/AdABZgE0Af8B0QFmATQB/wHRAWYBNAH/AdEBZgE0Af8B
0QFmATQB/wHRAWcBNAH/AdEBZwE0Af8B0gFoATQB/wHSAWgBNQH/AdIBaAE0Af8B0wFpATQB/wHS
AWkBNAH/AdIBaQE0Af8B0gFpATQB/wHTAWoBNQH/AdMBagE1Af8B0wFqATUB/wHTAWoBNAH/AdMB
agE1Af8B0wFqAT0B/wGdAU0BMwH6AwwBDwQBPAADCQEMA1gBuAPoAf8D+wH/A/oB/wPrAf8CtgG8
Af8CggGdAf8CdgGlAf8CcwG2Af8CcQHBAf8CbwHEAf8CbAHEAf8CagHDAf8CZwHCAf8CZQHBAf8C
YwHAAf8CYAG/Af8CXgG/Af8CXAG+Af8CWQG9Af8CVwG7Af8CVQG6Af8CUgGzAf8CUAGkAf8CTQGK
Af8CXgGAAf8CnwGoAf8D1gH/A+AB/wPfAf8D0wH/A1gBuAMJAQx4AAMhAS8DVQGvAcwBlAE7AfwB
5AGgAT0B/wHYAZQBNwH/AdUBkQE2Af8B1QGRATYB/wHVAZEBNgH/AdUBkQE2Af8B1AGQATYB/wHU
AZABNgH/AdYBkgE6Af8BzAGMAVQB/gJcAVkBwwMxAU6EAAMDAQQBQQJCAXIBZgGeAbIB/QFjAaoB
wwH/AVwBoQG8Af8BVAGSAagB/wFAAW0BfgH/ARsBJwErAf4DSQGFAwkBDHQAAwQBBQGvAVwBNwH/
Ad8BnAF9Af8BzwFmATYB/wHPAWUBNQH/AdABZQE1Af8BzwFlATQB/wHPAWUBNAH/AdABZQE0Af8B
0AFlATQB/wHQAWYBNAH/AdABZgE0Af8B0AFmATQB/wHQAWYBNAH/AdEBZgE0Af8B0QFmATQB/wHR
AWYBNAH/AdEBZgE0Af8B0QFnATQB/wHRAWcBNAH/AdEBaAE0Af8B0gFoATQB/wHSAWgBNQH/AdIB
aAE1Af8B0gFpATQB/wHTAWkBNAH/AdMBaQE1Af8B0wFpATUB/wHSAWkBNQH/AdIBawFBAf8BYgJd
AdQDCQEMBAFEAAMEAQUDTQGTA8IB/gP6Af8D+gH/A/cB/wPhAf8CrgG2Af8ChgGdAf8CdgGeAf8C
cwGoAf8CcQGzAf8CbwG6Af8CbAG+Af8CagG/Af8CaAG/Af8CZQG+Af8CYwG8Af8CYQG4Af8CXgGy
Af8CXAGoAf8CWQGYAf8CWAGIAf8CawGIAf8CmwGlAf8D0AH/A+IB/wPiAf8D4QH/ArUBtgH+A00B
kwMEAQWEAAMUARsDPQFoA1IBowFeAV0BWwHKAWkBZQFdAd8BdAFuAV8B5QFnAWQBYAHbAlwBWQHD
A1EBngM9AWgDGAEhkAADBgEHAzwBZQFnAWkBagHhAYMBrQG8Af8BaAGUAaMB/wFYAloB6QNDAXcD
DAEPfAADAgEDAWICWwHYAeABnwGCAf8B0gFxAUUB/wHPAWYBNgH/AdABZQE1Af8BzwFlATQB/wHP
AWQBNAH/Ac8BZQE0Af8B0AFlATUB/wHQAWUBNAH/AdABZgE0Af8B0AFmATQB/wHQAWYBNAH/AdAB
ZgE0Af8B0QFmATQB/wHRAWYBNAH/AdEBZgE0Af8B0QFnATQB/wHRAWYBNAH/AdEBZwE0Af8B0QFn
ATQB/wHRAWgBNQH/AdIBaAE0Af8B0gFoATQB/wHSAWgBNQH/AdIBbgFEAf8BxQFlAToB/wMvAUkD
BgEHVAADNAFTA28B6QPvAf8D+gH/A/kB/wP2Af8D5gH/AsUByQH/AqIBrgH/AokBnQH/AnoBmAH/
AnEBlwH/Am8BmQH/Am0BmQH/AmoBmAH/AmgBlAH/AmYBjwH/AmsBjQH/AnkBkgH/ApQBogH/AroB
vgH/A9kB/wPlAf8D5QH/A+UB/wPcAf8DbwHpAzQBU/8ATQAEAgMMAQ8DIQEwAyQBNQMRARYDAwEE
hAAEAQMQARUBsgFfATsB/wHfAZwBfwH/AdEBbAE+Af8B0AFlATUB/wHQAWUBNQH/Ac8BZQE0Af8B
zwFlATQB/wHQAWUBNAH/AdABZQE1Af8B0AFlATQB/wHQAWYBNAH/AdABZgE0Af8B0AFmATQB/wHQ
AWYBNAH/AdABZwE0Af8B0QFnATQB/wHRAWcBNQH/AdEBZgE0Af8B0QFmATQB/wHRAWcBNAH/AdEB
ZwE1Af8B0QFvAUMB/wHQAXIBSgH/AW4BXAFaAecDDAEPBAJcAAMPARMDTgGWAqUBpgH7A/IB/wP5
Af8D9wH/A/cB/wP0Af8D6wH/A98B/wLSAdMB/wLFAcgB/wK/AcQB/wK+AcQB/wLCAcYB/wLOAc8B
/wPZAf8D4wH/A+kB/wPpAf8D6AH/A+gB/wPhAf8DnQH7A04BlgMPARP/APUABAIDKQE+AbEBXQE5
Af8B3QGaAXwB/wHYAYgBYwH/AdABZQE1Af8B0AFmATUB/wHPAWUBNQH/Ac8BZQE0Af8B0AFlATQB
/wHQAWUBNQH/AdABZQE0Af8B0AFlATQB/wHQAWYBNAH/AdABZgE0Af8B0AFmATQB/wHQAWYBNAH/
AdABZwE0Af8B0QFpATcB/wHRAXgBUgH/Ac4BdgFPAf8BlwFbASgB+wMNAREDAwEEbAADGgEjA08B
lwKGAYcB8wPkAf8D9QH/A/cB/wP2Af8D9AH/A/QB/wPzAf8D8QH/A/EB/wPwAf8D7gH/A+4B/wPs
Af8D6wH/A+kB/wPbAf8DhQHzA08BlwMaASP/AP8ABgAEAQMJAQsBXwJcAcgBtgFlAUAB/wHbAZYB
dwH/AdoBkgFzAf8B1wGIAWQB/wHSAXYBSwH/Ac8BZwE3Af8BzwFlATQB/wHQAWUBNAH/AdEBbAE+
Af8B0gF3AU4B/wHRAX8BWQH/AdABgQFdAf8BzQF8AVYB/wGvAVYBLQH/AjsBOgFiAwkBDAMDAQR8
AAMLAQ4DOQFfA1YBrgN5Ae4D1AH/A+QB/wPsAf8D8AH/A/EB/wPvAf8D7QH/A+gB/wPfAf8D0AH/
A3kB7gNWAa4DOQFfAwsBDv8A/wAaAAQCAwUBBgMWAR4DTAGQAaYBTQEmAf8BpwFPASgB/wGpAVIB
KgH/AaoBUgEqAf8BqAFQASgB/wFtAVoBWAHpAzUBVgMRARYDBgEIAwMBBJQAAwMBBAMeASoDNQFW
A0QBdwNLAYsDTwGZA08BmQNLAYsDRAF3AzUBVgMeASoDAwEE/wD/ADoAEAH/ACUAAUIBTQE+BwAB
PgMAASgDAAHIAwABZAMAAQEBAAEBBQAB8AEKFgAD/wEACf8CAAF/AfgFAAEECQAC/wHwAQAE/wHw
AgABBwHwDwAC/wGAAQABHwP/AYACAAEBAfAPAAH/Af4CAAEHAv8B/gQAAXAPAAH/AfgCAAEBAv8B
/AQAATAPAAH/AfADAAL/AfgEAAEQDwAB/wHgAwABPwH/AfgUAAH/AcADAAEfAf8B+BQAAf8BgAMA
AQ8B/wHwBAABCAUAAQQJAAH/BAABDwH/AeAEAAEcBQABBAkAAf4EAAEHAf8BwAQAATwFAAEMCQAB
/gQAAQMB/wGABAABfgUAAQwJAAH8BAABAwH/BAABAQH+BQABHAkAAfgEAAEBAf8EAAEBAf8FAAEc
CQAB+AQAAQEB/gQAAQEB/wUAATwJAAH4BQAB/AUAAf8BgAQAATwJAAHwBQAB/AUAAf8BgAQAAXwJ
AAHwBQAB+AUAAX8BwAQAAXwJAAHwBQABeAUAAX8BwAQAAfwJAAHgBQABeAUAAX8B4AQAAfwJAAHg
BQABcAUAAT8B4AMAAQEB/AkAAeAFAAFwBQABPwHwAwABAwH8CQAB4AUAAXAFAAE/AfADAAEDAfwJ
AAHgBQABcAUAAT8B+AMAAQcB/AkAAeAFAAFwBQABPwH4AwABBwH8CQAB4AUAAXAFAAE/AfwDAAEP
AfwJAAHgBQABcAUAAT8B/AMAAQ8B/AkAAeAFAAFwBQABPwH+AwABHwH8CQAB4AUAAXAFAAE/Af4D
AAEfAfwJAAHgBQABcAUAAT8B/wMAAT8B/AkAAfAFAAHwBQABPwH/AwABPwH8CQAB8AUAAfAFAAE/
Af8BgAIAAX8B/AkAAfAFAAHwBQABPwH/AYACAAF/AfwJAAHwBAABAQHwBQABPwH/AcACAAH/AfwJ
AAH4BAABAQH4BQABfwH/AeACAAH/AfwJAAH4BAABAwH4BQABfwH/AeABAAEBAf8B/AkAAfwEAAED
AfgFAAF/Af8B8AEAAQEB/wH8CQAB/gQAAQcB/AUAAv8B8AEAAQMB/wH8CQAB/gQAAQ8B/AUAAv8B
+AEAAQMB/wH8CQAB/wQAAR8B/gQAAQEC/wH4AQABBwH/AfwJAAH/AYADAAE/Af8EAAEDAv8B/AEA
AQcB/wH8CQAB/wHAAwABfwH/BAABAwL/AfwBAAEPAf8B/AkAAf8B4AMAAv8BgAMAAQcC/wH+AQAB
DwH/AfwJAAH/AfgCAAEDAv8BwAMAAQ8C/wH+AQABHwH/AfwJAAH/AfwCAAEHAv8B4AMAAR8D/wEA
AR8B/wH8CQAC/wIAAT8C/wHwAwABPwP/AQABPwH/AfwJAAL/AfABAQP/AfwDAAT/AYABPwH/AfwJ
AAj/AgABAwT/AYABfwH/AfwJAAj/AcABAAEPBP8BwAF/Af8B/AkACP8B8AEAAT8E/wHgAv8B/AkA
D/8BAAE/BP8BgAEHAv8DAA7/AfgBAAEDA/8B/AIAAv8DAA7/AcACAAP/AeACAAEfAf8DAAH/AeAC
AAEDAv8BwAMAAQ8C/wMAAT8C/wHAAgABDwH/AwAB/wHgAgABAwH/AfwFAAH/Af4DAAEPAv8DAAED
Af8DAAH/AcACAAEDAf8B+AUAAX8B+AMAAQcB/wH+AwABAQH/AwAB/wGAAgABAwH/AfAFAAE/AfAD
AAEDAf8B/AQAAf8DAAH/AYACAAEDAf8B4AUAAR8B4AMAAQEB/wH4BAABfwMAAf8BgAIAAQMB/wHg
BQABHwHABAAB/wHwBAABPwMAAf8BwAIAAQEB/wHgBQABHwHABAABfwHgBAABHwMAAf8B8AIAAQEB
/wHgBQABHwGABAABPwHgBAABHwMAAf8B+AIAAQEB/wHgAQ8B/wEBAf8B4AEfBQABPwHABAABDwMA
Af8B+AIAAQMB/wHwAQ8B/gEBAf8BwAEfBQABHwGABAABBwMAAf8B+AIAAT8B/wHwAQcB/AEAAf8B
gAE+BQABHwGABAABBwMAAf8B+AEMAQABPwH/AfgBBwH8AQAB/wGAAT4FAAEPBQABAwMAAf8B8AEM
AQABPwH/AfgBAwH8AQAB/wEAAXwFAAEPBQABAwMAAf8B8AEMAQABPwH/AfwBAQH+AQAB/wEAAfwF
AAEHBQABAwMAAf8B8AEMAQABPwH/Af4BAQH+AQEB/gEAAfwFAAEGBQABAQMAAf8B8AEMAQABPwH/
Af4BAAH/AQMB/AEBAfgFAAEGBQABAQMAAf8B4AIAAR8C/wEAAf8BhwH8AQEB+AUAAQYFAAEBAwAB
/wHgAgABHwL/AQABfwGHAfgBAwH4BQABAgUAAQEDAAH/AcACAAEPAv8BgAE/AYcB+AEHAfgFAAEC
BQABAQMAAf8BwAIAAQcC/wHAAT8BhwHwAQcB+AUAAQIFAAEBAwAB/wHgAgABAwL/AcABHwEDAeAB
DwHwBQABAgUAAQEDAAH/AfABBgEAAQEC/wHgAR8BAwHgAQ8B8AUAAQIFAAEBAwAB/wH8AR4CAAL/
AeABDwEBAcABHwHwBQABAgUAAQEDAAH/AfgBHwIAAX8B/wHwAQYBAQHAAT8B8AUAAQIFAAEBAwAB
/wH4AQ8BgAEAAT8B/wHwAQYBAAGAAT8B+AUAAQIFAAEBAwAB/wH4AQ8BwAEAAT8B/wH4AwABfwH4
BQABAgUAAQEDAAH/AfgBDwHgAQABHwH/AfwDAAF/AfgFAAECBQABAQMAAf8B/AEfAfABAAEfAf8B
/AMAAf8B+AUAAQYFAAEBAwAB/wH+AQABeAEAAR8B/wH+AgABAQH/AfgFAAEHBQABAwMAAf8B+AEA
ATgBAAEfAf8B/gIAAQEB/wH8BQABBwUAAQMDAAH/AfwBAAE4AQABHwL/AgABAwH/AfwFAAEPBQAB
AwMAAf8B/AEAATgBAAEfAv8BgAEAAQMB/wH8BQABDwGABAABBwMAAf8B/AEAARABAAEfAv8BgAEw
AQcB/wH+BQABDwGABAABBwMAAf8B/AMAAR8C/wHAARABDwH/Af4FAAEfAcAEAAEPAwAB/wH+AwAB
HwL/AcABAAEPAv8FAAEfAcAEAAEPAwAB/wH+AwABPwL/AeABAAEfAv8FAAE/AeAEAAEfAwAC/wMA
AT8C/wHwAQABHwL/AYAEAAF/AfAEAAE/AwAC/wGAAgABfwL/AfABAAE/Av8BwAQAAX8B8AQAAT8D
AAL/AcACAAP/AfgBAAF/Av8B4AQAAf8B+AQAAX8DAAL/AfABAAEBA/8B+AEAAX8C/wHwAwABAQH/
AfwEAAH/AwAC/wH8AQABBwP/AfwBAAP/AfgDAAEDAf8B/gMAAQEB/wMAA/8BAAEfA/8B/gEBA/8B
/AMAAQ8C/wGAAgABBwH/AwAJ/wEDA/8B/gMAAR8C/wHAAgABDwH/AwAO/wGAAgABfwL/AfACAAE/
Af8DAA7/AeABAAEBA/8B/AIAAv8DAA7/AfwBAAEPBP8BgAEHAv8DAA//AeEJ/wMACw=='))
	#endregion
	$imagelist.ImageStream = $Formatter_binaryFomatter.Deserialize($System_IO_MemoryStream)
	$Formatter_binaryFomatter = $null
	$System_IO_MemoryStream = $null
	$imagelist.TransparentColor = 'Transparent'
	$formMessageBox.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formMessageBox.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formMessageBox.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formMessageBox.add_FormClosed($Form_Cleanup_FormClosed)
	#Store the control values when form is closing
	$formMessageBox.add_Closing($Form_StoreValues_Closing)
	#Show the Form
	return $formMessageBox.ShowDialog()

}
#endregion Source: MessageBox.psf

#region Source: ShowCurrentConfig.psf
function Show-ShowCurrentConfig_psf
{
	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	$formCurrentConfig = New-Object 'System.Windows.Forms.Form'
	$buttonClose = New-Object 'System.Windows.Forms.Button'
	$datagridview1 = New-Object 'System.Windows.Forms.DataGridView'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	$formCurrentConfig_Load={
		Update-LoadedConfigTable
		$datagridview1.DataSource = $LoadedConfigTable
		$datagridview1.Columns['Config'].ReadOnly = $true
		$datagridview1.Columns['Attribute'].ReadOnly = $true
		$datagridview1.Columns['User Customized'].ReadOnly = $true
		$datagridview1.Columns['Value'].ReadOnly = $false
		$Script:LockedItems = Get-LockedConfigItems
	}
	$buttonClose_Click={
		$formCurrentConfig.Close()
	}
	$datagridview1_CellEndEdit=[System.Windows.Forms.DataGridViewCellEventHandler]{
		If ($LockedItems -notcontains "$($datagridview1.CurrentRow.Cells['Attribute'].Value)")
		{
			Debug-Log -text "Updating attribute `"$($datagridview1.CurrentRow.Cells['Attribute'].Value)`" for config `"$($datagridview1.CurrentRow.Cells['Config'].Value)`"" -Component "ShowCurrentConfig.psf_datagridview1_CellEndEdit" -Type 4
			If ($datagridview1.CurrentRow.Cells['Value'].Value.ToString().Length -ge 1)
			{
				If (((Get-ItemProperty "$Config_RootHKCU$($datagridview1.CurrentRow.Cells['Config'].Value)\")."$($datagridview1.CurrentRow.Cells['Attribute'].Value)"))
				{
					$Error.Clear()
					Set-ItemProperty -Path "$Config_RootHKCU$($datagridview1.CurrentRow.Cells['Config'].Value)" -Name "$($datagridview1.CurrentRow.Cells['Attribute'].Value)" -Value "$($datagridview1.CurrentRow.Cells['Value'].Value)"
					If ($Error)
					{
						Log -text "An error occured while attempting to update a user customized attribute setting." -Component "ShowCurrentConfig.psf_datagridview1_CellEndEdit" -Type 3
						Log -text "$Error" -Component "ShowCurrentConfig.psf_datagridview1_CellEndEdit" -Type 3
						Log -text "" -Component "ShowCurrentConfig.psf_datagridview1_CellEndEdit" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured. See log for details." -boxtype 1 -image 5 -x ($formCurrentConfig.Location.X + ($formCurrentConfig.Size.Width / 2)) -y ($formCurrentConfig.Location.Y + ($formCurrentConfig.Size.Height / 2))
					}
					Else
					{
						Debug-Log -text "Successfully updated the custom setting." -Component "ShowCurrentConfig.psf_datagridview1_CellEndEdit" -Type 4
					}
				}
				Else
				{
					$Error.Clear()
					New-ItemProperty -Path "$Config_RootHKCU$($datagridview1.CurrentRow.Cells['Config'].Value)" -Name "$($datagridview1.CurrentRow.Cells['Attribute'].Value)" -Value "$($datagridview1.CurrentRow.Cells['Value'].Value)"
					If ($Error)
					{
						Log -text "An error occured while attempting to create a user customized attribute setting." -Component "ShowCurrentConfig.psf_datagridview1_CellEndEdit" -Type 3
						Log -text "$Error" -Component "ShowCurrentConfig.psf_datagridview1_CellEndEdit" -Type 3
						Log -text "" -Component "ShowCurrentConfig.psf_datagridview1_CellEndEdit" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured. See log for details." -boxtype 1 -image 5 -x ($formCurrentConfig.Location.X + ($formCurrentConfig.Size.Width / 2)) -y ($formCurrentConfig.Location.Y + ($formCurrentConfig.Size.Height / 2))
					}
					Else
					{
						Debug-Log -text "Successfully created the custom setting." -Component "ShowCurrentConfig.psf_datagridview1_CellEndEdit" -Type 4
					}
				}	
			}
			Else
			{
				Debug-Log -text "New value is blank. If user customized value exists, it will be deleted." -Component "ShowCurrentConfig.psf_datagridview1_CellEndEdit" -Type 4
				If (((Get-ItemProperty "$Config_RootHKCU$($datagridview1.CurrentRow.Cells['Config'].Value)\")."$($datagridview1.CurrentRow.Cells['Attribute'].Value)"))
				{
					$Error.Clear()
					Remove-ItemProperty -Path "$Config_RootHKCU$($datagridview1.CurrentRow.Cells['Config'].Value)" -Name "$($datagridview1.CurrentRow.Cells['Attribute'].Value)" -Force
					If ($Error)
					{
						Log -text "An error occured while attempting to delete a user customized attribute setting." -Component "ShowCurrentConfig.psf_datagridview1_CellEndEdit" -Type 3
						Log -text "$Error" -Component "ShowCurrentConfig.psf_datagridview1_CellEndEdit" -Type 3
						Log -text "" -Component "ShowCurrentConfig.psf_datagridview1_CellEndEdit" -Type 3
						Show-MessageBox_psf -title "ERROR" -text "An error occured. See log for details." -boxtype 1 -image 5 -x ($formCurrentConfig.Location.X + ($formCurrentConfig.Size.Width / 2)) -y ($formCurrentConfig.Location.Y + ($formCurrentConfig.Size.Height / 2))
					}
					Else
					{
						Debug-Log -text "Successfully deleted the custom setting." -Component "ShowCurrentConfig.psf_datagridview1_CellEndEdit" -Type 4
					}
				}
			}
		}
	}
	$datagridview1_CellBeginEdit=[System.Windows.Forms.DataGridViewCellCancelEventHandler]{
		If ($LockedItems -contains "$($datagridview1.CurrentRow.Cells['Attribute'].Value)")
		{
			Show-MessageBox_psf -title "ERROR" -text "This attribute is read only." -boxtype 1 -image 5 -x ($formCurrentConfig.Location.X + ($formCurrentConfig.Size.Width / 2)) -y ($formCurrentConfig.Location.Y + ($formCurrentConfig.Size.Height / 2))
			$datagridview1.EndEdit()
		}
	}
	$formCurrentConfig_SizeChanged={
		$datagridview1.Size = (New-Object System.Drawing.Size(($formCurrentConfig.Width - 38), ($formCurrentConfig.Height - 81)))
		$buttonClose.Location = (New-Object System.Drawing.Size((($formCurrentConfig.Width / 2) - ($buttonClose.Width / 2)), ($formCurrentConfig.Height - 65)))
	}	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formCurrentConfig.WindowState = $InitialFormWindowState
	}
	
	$Form_StoreValues_Closing=
	{
		#Store the control values
		$script:ShowCurrentConfig_datagridview1 = $datagridview1.SelectedCells
	}

	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$buttonClose.remove_Click($buttonClose_Click)
			$datagridview1.remove_CellBeginEdit($datagridview1_CellBeginEdit)
			$datagridview1.remove_CellEndEdit($datagridview1_CellEndEdit)
			$formCurrentConfig.remove_Load($formCurrentConfig_Load)
			$formCurrentConfig.remove_SizeChanged($formCurrentConfig_SizeChanged)
			$formCurrentConfig.remove_Load($Form_StateCorrection_Load)
			$formCurrentConfig.remove_Closing($Form_StoreValues_Closing)
			$formCurrentConfig.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$formCurrentConfig.SuspendLayout()
	#
	# formCurrentConfig
	#
	$formCurrentConfig.Controls.Add($buttonClose)
	$formCurrentConfig.Controls.Add($datagridview1)
	$formCurrentConfig.AutoScaleDimensions = '6, 13'
	$formCurrentConfig.AutoScaleMode = 'Font'
	$formCurrentConfig.ClientSize = '670, 504'
	$formCurrentConfig.ControlBox = $False
	$formCurrentConfig.Name = 'formCurrentConfig'
	$formCurrentConfig.ShowIcon = $False
	$formCurrentConfig.ShowInTaskbar = $False
	$formCurrentConfig.SizeGripStyle = 'Hide'
	$formCurrentConfig.StartPosition = 'CenterParent'
	$formCurrentConfig.Text = 'Current Config'
	$formCurrentConfig.add_Load($formCurrentConfig_Load)
	$formCurrentConfig.add_SizeChanged($formCurrentConfig_SizeChanged)
	#
	# buttonClose
	#
	$buttonClose.Location = '295, 478'
	$buttonClose.Name = 'buttonClose'
	$buttonClose.Size = '75, 23'
	$buttonClose.TabIndex = 1
	$buttonClose.Text = 'Close'
	$buttonClose.UseVisualStyleBackColor = $True
	$buttonClose.add_Click($buttonClose_Click)
	#
	# datagridview1
	#
	$datagridview1.AllowUserToAddRows = $False
	$datagridview1.AllowUserToDeleteRows = $False
	$datagridview1.AutoSizeColumnsMode = 'Fill'
	$datagridview1.ClipboardCopyMode = 'Disable'
	$datagridview1.ColumnHeadersHeightSizeMode = 'AutoSize'
	$datagridview1.Location = '12, 12'
	$datagridview1.Name = 'datagridview1'
	$datagridview1.RowHeadersWidthSizeMode = 'AutoSizeToAllHeaders'
	$datagridview1.Size = '646, 460'
	$datagridview1.TabIndex = 0
	$datagridview1.add_CellBeginEdit($datagridview1_CellBeginEdit)
	$datagridview1.add_CellEndEdit($datagridview1_CellEndEdit)
	$formCurrentConfig.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formCurrentConfig.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formCurrentConfig.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formCurrentConfig.add_FormClosed($Form_Cleanup_FormClosed)
	#Store the control values when form is closing
	$formCurrentConfig.add_Closing($Form_StoreValues_Closing)
	#Show the Form
	return $formCurrentConfig.ShowDialog()

}
#endregion Source: ShowCurrentConfig.psf

#region Source: ShowNewStuff.psf
function Show-NewStuff
{
	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	$formNewStuff = New-Object 'System.Windows.Forms.Form'
	$checkboxDontShowInTheFuture = New-Object 'System.Windows.Forms.CheckBox'
	$labelTheFollowingChangesH = New-Object 'System.Windows.Forms.Label'
	$richtextbox1 = New-Object 'System.Windows.Forms.RichTextBox'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	$formNewStuff_Load={
		$tbht = $false
		ForEach ($file in Get-ChildItem -Path "$Config_NetSourceDir$AppShortName\UpdateDetails" | Where-Object { $_.PSIsContainer -eq $false })
		{
			If ($file.BaseName -gt $Global:LRV)
			{
				$contents = Get-Content -Path $file.FullName
				foreach ($line in $contents)
				{
					If ($tbht -eq $false)
					{
						$richtextbox1.Text = "$line"
						$tbht = $true
					}
					Else
					{
						$richtextbox1.AppendText("`n$line")
					}
				}
				$richtextbox1.AppendText("`n`n")
			}
		}
	}
	$checkboxDontShowInTheFuture_CheckedChanged={
		If ($checkboxDontShowInTheFuture.Checked -eq $true)
		{
			If (((Get-ItemProperty "$Config_RootHKCU$AppShortName")."ShowNewStuff"))
			{
				$Error.Clear()
				Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name "ShowNewStuff" -Value "false"
				If ($Error)
				{
					Log -text "An error occured while attempting to update the ShowNewStuff attribute for the tool in the registry." -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 3
					Log -text "$Error" -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 3
					Log -text "" -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured. See log for details." -boxtype 1 -image 5 -x ($formNewStuff.Location.X + ($formNewStuff.Size.Width / 2)) -y ($formNewStuff.Location.Y + ($formNewStuff.Size.Height / 2))
				}
				Else
				{
					Debug-Log -text "Successfully updated the ShowNewStuff attribute." -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 4
				}
			}
			Else
			{
				$Error.Clear()
				New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name "ShowNewStuff" -Value "false"
				If ($Error)
				{
					Log -text "An error occured while attempting to create the ShowNewStuff attribute for the tool in the registry." -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 3
					Log -text "$Error" -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 3
					Log -text "" -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured. See log for details." -boxtype 1 -image 5 -x ($formNewStuff.Location.X + ($formNewStuff.Size.Width / 2)) -y ($formNewStuff.Location.Y + ($formNewStuff.Size.Height / 2))
				}
				Else
				{
					Debug-Log -text "Successfully created the ShowNewStuff attribute" -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 4
				}
			}
		}
		Else
		{
			If (((Get-ItemProperty "$Config_RootHKCU$AppShortName\")."ShowNewStuff"))
			{
				$Error.Clear()
				Set-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name "ShowNewStuff" -Value "true"
				If ($Error)
				{
					Log -text "An error occured while attempting to update the ShowNewStuff attribute for the tool in the registry." -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 3
					Log -text "$Error" -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 3
					Log -text "" -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured. See log for details." -boxtype 1 -image 5 -x ($formNewStuff.Location.X + ($formNewStuff.Size.Width / 2)) -y ($formNewStuff.Location.Y + ($formNewStuff.Size.Height / 2))
				}
				Else
				{
					Debug-Log -text "Successfully updated the ShowNewStuff attribute." -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 4
				}
			}
			Else
			{
				$Error.Clear()
				New-ItemProperty -Path "$Config_RootHKCU$AppShortName" -Name "ShowNewStuff" -Value "true"
				If ($Error)
				{
					Log -text "An error occured while attempting to create the ShowNewStuff attribute for the tool in the registry." -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 3
					Log -text "$Error" -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 3
					Log -text "" -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 3
					Show-MessageBox_psf -title "ERROR" -text "An error occured. See log for details." -boxtype 1 -image 5 -x ($formNewStuff.Location.X + ($formNewStuff.Size.Width / 2)) -y ($formNewStuff.Location.Y + ($formNewStuff.Size.Height / 2))
				}
				Else
				{
					Debug-Log -text "Successfully created the ShowNewStuff attribute" -Component "ShowNewStuff.psf_checkboxDontShowInTheFuture_CheckedChanged" -Type 4
				}
			}
		}
	}	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formNewStuff.WindowState = $InitialFormWindowState
	}
	
	$Form_StoreValues_Closing=
	{
		#Store the control values
		$script:ShowNewStuff_checkboxDontShowInTheFuture = $checkboxDontShowInTheFuture.Checked
		$script:ShowNewStuff_richtextbox1 = $richtextbox1.Text
	}

	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$checkboxDontShowInTheFuture.remove_CheckedChanged($checkboxDontShowInTheFuture_CheckedChanged)
			$formNewStuff.remove_Load($formNewStuff_Load)
			$formNewStuff.remove_Load($Form_StateCorrection_Load)
			$formNewStuff.remove_Closing($Form_StoreValues_Closing)
			$formNewStuff.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$formNewStuff.SuspendLayout()
	#
	# formNewStuff
	#
	$formNewStuff.Controls.Add($checkboxDontShowInTheFuture)
	$formNewStuff.Controls.Add($labelTheFollowingChangesH)
	$formNewStuff.Controls.Add($richtextbox1)
	$formNewStuff.AutoScaleDimensions = '6, 13'
	$formNewStuff.AutoScaleMode = 'Font'
	$formNewStuff.ClientSize = '665, 485'
	$formNewStuff.FormBorderStyle = 'FixedSingle'
	$formNewStuff.MaximizeBox = $False
	$formNewStuff.MinimizeBox = $False
	$formNewStuff.Name = 'formNewStuff'
	$formNewStuff.Text = 'Changelog'
	$formNewStuff.ShowIcon = $False
	$formNewStuff.ShowInTaskbar = $False
	$formNewStuff.StartPosition = 'CenterParent'
	$formNewStuff.add_Load($formNewStuff_Load)
	#
	# checkboxDontShowInTheFuture
	#
	$checkboxDontShowInTheFuture.Location = '512, 459'
	$checkboxDontShowInTheFuture.Name = 'checkboxDontShowInTheFuture'
	$checkboxDontShowInTheFuture.Size = '150, 24'
	$checkboxDontShowInTheFuture.TabIndex = 2
	$checkboxDontShowInTheFuture.Text = 'Don''t show in the future'
	$checkboxDontShowInTheFuture.UseVisualStyleBackColor = $True
	$checkboxDontShowInTheFuture.add_CheckedChanged($checkboxDontShowInTheFuture_CheckedChanged)
	#
	# labelTheFollowingChangesH
	#
	$labelTheFollowingChangesH.Location = '12, 9'
	$labelTheFollowingChangesH.Name = 'labelTheFollowingChangesH'
	$labelTheFollowingChangesH.Size = '395, 23'
	$labelTheFollowingChangesH.TabIndex = 1
	$labelTheFollowingChangesH.Text = 'The following changes have been made since you last used this tool:'
	$labelTheFollowingChangesH.TextAlign = 'MiddleLeft'
	#
	# richtextbox1
	#
	$richtextbox1.Location = '12, 35'
	$richtextbox1.Name = 'richtextbox1'
	$richtextbox1.ReadOnly = $True
	$richtextbox1.Size = '640, 418'
	$richtextbox1.TabIndex = 0
	$richtextbox1.Text = ''
	$formNewStuff.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formNewStuff.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formNewStuff.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formNewStuff.add_FormClosed($Form_Cleanup_FormClosed)
	#Store the control values when form is closing
	$formNewStuff.add_Closing($Form_StoreValues_Closing)
	#Show the Form
	return $formNewStuff.ShowDialog()

}
#endregion Source: ShowNewStuff.psf

#Start the application
Show-MainForm