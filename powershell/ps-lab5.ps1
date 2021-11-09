## PowerShell Lab 5
## Use functions in "labfunctions" module for this lab

# Add a paramater to the command line
Param ([Parameter(Mandatory=$false)][string]$info)
       
# Check to see what parameter was given
switch ($info) { 

    "disks" {":: Harddrive Information ::"
             diskInfo} 

    "system" {":: Processor Information ::"
              proInfo
              ""
              ":: Operating System ::"
              osInfo
              ""
              ":: Memory Information ::"
              memInfo
              ""
              ""
              ":: Graphics Adapter Information ::"
              videoInfo}

    "network" {":: Network Adapter Information ::" 
                netAdaptInfo}

    default {
                ""
                ":: System Hardware ::"
                ""
                sysHardware

                ""
                ""
                ":: Operating System ::"
                ""
                osInfo

                ""
                ""
                ":: Processor Information ::"
                ""
                proInfo
                ""
                ""
                ":: Memory Information ::"
                memInfo

                ""
                ""
                ""
                ":: Harddrive Information ::"
                diskInfo

                ""
                ":: Network Adapter Information ::"
                netAdaptInfo

                ""
                ":: Graphics Adapter Information ::"
                ""
                videoInfo

                ""
                ""}
}

#END OF SCRIPT