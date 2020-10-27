Easy Shutdown/Start for ARM and Classic VMs
===========================================

            
This script shutdowns/starts VMs (both ASM and ARM) just by given a
**Subscription name** and a 
**VM name**.

First step is, you need to create an credential asset and update $CredentialAssetName variable in the code. And then you can use the script by just a  enter a Subscription name for $SubscriptionName, a VM name for $VmName variable
 and select $Shutdown variable to $true for Shutdown VM or $false for Start VM.

Ps: This script forked from Easy Shutdown/Start for ARM and Classic VMs by Mehmet
 Çakoğlu. Thanks Mehmet :) 

Ps #2: You need to import the latest AzureResourceManager module located in C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ResourceManager.


Ps #3: [To create new credential asset with the Azure Portal* *](https://docs.microsoft.com/en-us/azure/automation/automation-credentials#creating-a-new-credential-asset)


 

 
 

 


        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
