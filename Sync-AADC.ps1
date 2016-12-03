Function Sync-AADC{
[CmdletBinding()]
param(
[parameter(Mandatory=$true)][string]$AADCServer,
$Credential

)
<#
  .SYNOPSIS
  Runs a delta sync of the Azure AD Connector (AADC) service. 

  .DESCRIPTION
  Runs a delta sync of the Azure AD Connector (AADC) service. 
  
  .EXAMPLE
   Run sync with verbose output
   Sync-AADC -AADCServer server1.fabrikam.com -verbose

  .SYNTAX
  Sync-AADC [-AADCServer] <string>  [<CommonParameters>]

  .PARAMETER AADCServer
  Specify the AADC Server

  .PARAMETER Credential
  Credential object used to connect to the Msol Service with user account management permissions
  #> 

    BEGIN{
     Write-Verbose 'Starting AADC synchronization process...'
    }
    
    PROCESS{
        
        if ($Credential){

            $Sync = Invoke-Command -ComputerName $AADCServer -ScriptBlock {Start-AdSyncSyncCycle -policytype Delta} -Credential $Credential
        
            Start-Sleep -Seconds 10

            Invoke-Command -ComputerName $AADCServer -ScriptBlock {

                While (Get-AdSyncConnectorRunStatus){

                    Start-Sleep -Seconds 5
            
                } 

            } -Credential $Credential

        }

        else{

            $Sync = Invoke-Command -ComputerName $AADCServer -ScriptBlock {Start-AdSyncSyncCycle -policytype Delta}
        
            Start-Sleep -Seconds 10

            Invoke-Command -ComputerName $AADCServer -ScriptBlock {

                While (Get-AdSyncConnectorRunStatus){

                    Start-Sleep -Seconds 5
            
                } 

            }

        }
    }

    END{

    Write-Verbose 'AADC synchronization complete'

    }
}