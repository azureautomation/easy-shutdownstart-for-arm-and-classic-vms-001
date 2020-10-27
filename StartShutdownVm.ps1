workflow StartShutdownVm
{
	Param
    (   [Parameter(Mandatory=$true)]  
        [String]  
        $SubscriptionName, 
        [Parameter(Mandatory=$true)]  
        [String]  
        $VmName,  
        [Parameter(Mandatory=$true)]  
        [Boolean]  
        $Shutdown
    )
	
	#The name of the Automation Credential Asset this runbook will use to authenticate to Azure.
    $CredentialAssetName = "AzureCredential";
	
	#Get the credential with the above name from the Automation Asset store
    $Cred = Get-AutomationPSCredential -Name $CredentialAssetName
    if(!$Cred) {
        Throw "Could not find an Automation Credential Asset named '${CredentialAssetName}'. Make sure you have created one in this Automation Account."
    }

    #Connect to your Azure Account         
    Add-AzureRmAccount -Credential $Cred  
    Add-AzureAccount -Credential $Cred  
 
    #Check for each subscription to find VM 
    Get-AzureSubscription | where {$_.SubscriptionName -eq $SubscriptionName} | ForEach-Object {  
        Write-Output "`n Looking into $($_.SubscriptionName) subscription..." 
 
        #Select subscription 
        Select-AzureSubscription -SubscriptionId $_.SubscriptionId 
        Select-AzureRmSubscription -SubscriptionId $_.SubscriptionId 
 
        write-host " Looking into ARM VM Resources..." 
        Get-AzureRmResource | where {$_.ResourceType -eq "Microsoft.Compute/VirtualMachines"} | ForEach-Object {
            #DEBUG: Write-Output "`t Looking for resource: '$($_.ResourceGroupName)' / $($_.ResourceType)" 
            if($_.Name -eq $vmName) {
                $vm = Get-AzureRmVM -ResourceGroupName $_.ResourceGroupName -Name $VmName
                if($vm)
                {
                    Write-Output "`t`t Found ARM VM: '$($vm.Name)'"
                    if($Shutdown -eq $true){
                        Write-Output "`t`t`t Stopping '$($vm.Name)' ARM Virtual Machine ..." 
                        $vm | Stop-AzureRmVM -Force
                    }
                    else{
                        Write-Output "`t`t`t Starting '$($vm.Name)' ARM Virtual Machine ..."              
                        $vm | Start-AzureRmVM
                    }
                }
                else
                {
                    Write-Output "`t`t ARM VM: '$($vm.Name)' not found" 
                }
            }
        }
        # -------------------------------------------------------------------------------------------- 
        Write-Output "Looking into Classic VM resources:";  
        Get-AzureRmResource | where { $_.ResourceType -eq "Microsoft.ClassicCompute/VirtualMachines"} | ForEach-Object {
            #DEBUG: Write-Output "`t Looking for resource: '$($_.ResourceGroupName)' / $($_.ResourceType)" 
            if($vmName -eq $_.Name) {
                Write-Output "`t`t Found Classic VM: '$($vmName)'"
                if($Shutdown -eq $true){
                    Get-AzureVM | where {$_.Name -eq $vmName} | ForEach-Object {
                        Write-Output "`t`t`t The machine '$($_.Name)' is $($_.PowerState)"  
                        if($_.PowerState -eq "Started"){
                            Write-Output "`t`t`t Stopping '$($_.Name)' Classic Virtual Machine ..."          
                            Stop-AzureVM -ServiceName $_.ServiceName -Name $_.Name -Force 
                        }
                    }
                }
                else{
                    Get-AzureVM | where {$_.Name -eq $vmName} | ForEach-Object {  
                        Write-Output "`t`t`t The machine '$($_.Name)' is $($_.PowerState)"  
                        if($_.PowerState -eq "Stopped"){
                            Write-Output "`t`t`t Starting '$($_.Name)' Classic Virtual Machine ..."         
                            Start-AzureVM -ServiceName $_.ServiceName -Name $_.Name 
                        }
                    }
                }
            }    
        }
    }
}

