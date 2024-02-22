# Remove-AllSnapshots.ps1
# Release 1
# Usage: ./Remove-AllSnapshots.ps1
#
# Will remove all VM snapshot and dismount on vCenter (VCC) and attached ESXi host (VASA,VASB,VASC etc.)
# The "$vCenterServer" variable must be set to the vCenter/ESXi host that you want to connect to. Best to connet to the vCenter(VCC) host.
# *** You must connet to ESXi/vCenter Server via Powercli
# *** Tested with Powercli 13.1.0.21624340
# *** Powershell Execution Policy must be set to "Set-ExecutionPolicy RemoteSigned" or disabled 
#
# 
#	Latest Release date: 2-22-2023

# Import the VMware vSphere PowerCLI module
Import-Module VMware.VimAutomation.Core

# Set the vCenter server name and credentials
$vCenterServer = "s0u1vcc.vida.local"

# Connect to vCenter
Connect-VIServer $vCenterServer 

# List all virtual machines in vCenter
Get-VM "*" | Get-Snapshot

# For each virtual machine remove all the snapshots
Get-VM "*" | Get-Snapshot | Remove-Snapshot -RunAsync -Confirm:$false

# For each virtual machine dismount CD-ROM 
Get-VM "*" | Get-CDDrive | Where {$_.ISOPath -ne $null} | Set-CDDrive -NoMedia -Confirm:$false

# Disconnect from vCenter
$wshell = New-Object -ComObject Wscript.Shell
$Output = $wshell.Popup("All Snapshot have been removed!")
#Disconnect-VIServer -Force
