## PowerShell Lab 4
## Gather and display system information and component information

# Create system hardware function
#*** "[string]::IsNullOrWhiteSpace($VARNAME)" checks VARNAME to see if it is $null, empty, or whitespace all in one command ***

function sysHardware { $desc=(Get-CimInstance Win32_ComputerSystem).Description
                       
                       if ([string]::IsNullOrWhiteSpace($desc) -eq "True") { $desc="Data Unavailable" }
                       
                       Write-Host -NoNewline "Hardware Description:"$desc
                       ""
                     }

# Create operating system function
function osInfo   { $osName=(Get-CimInstance Win32_OperatingSystem).Name
                    $osVer=(Get-CimInstance Win32_OperatingSystem).Version

                    if ([string]::IsNullOrWhiteSpace($osName) -eq "True") { $osName="Data Unavailable" }
                    if ([string]::IsNullOrWhiteSpace($osVer) -eq "True") { $osVer="Data Unavailable" }

                    Write-Host -NoNewline "Operating System Name:"$osName
                    ""
                    Write-Host -NoNewline "Operating System Version:"$osVer
                    ""
                  }

# Create processor information function
#  --demonstrates FOREACH and FOR loops 
function proInfo  { $cpuInfo=("Description","NumberOfCores","CurrentClockspeed")
                    
                    #FOREACH LOOP
                    foreach ($property in $cpuInfo) {
                    $value=(Get-CimInstance Win32_Processor).$property

                    if ([string]::IsNullOrWhiteSpace($value) -eq "True") { $value="Data Unavailable" } #make sure value isn't null/empty/whitespace

                    if ($property -eq "CurrentClockspeed") { $value=([string]($value / 1000)+"Ghz") } #make clockspeed more human readable
                    
                    Write-Host -NoNewline ${property}": "$value
                    ""   
                    }

                    #FOR LOOP
                    for ($i=0; $i -le 2; $i++) {
                    
                    $size=((Get-CimInstance Win32_CacheMemory).MaxCacheSize | Select-Object -Index $i) #get L cache size depending on index number
                    if ([string]::IsNullOrWhiteSpace($size) -eq "True") { $size="Data Unavailable"
                                                                          $unit=""                     #check for null/empty/whitespace
                                                                        } 
                    elseif ($size -ge 1024) { $size=($size / 1024) #make sizes human readable
                                          $unit="MB"
                                        }
                    else { $unit="KB" }
                    $i++
                    Write-Host -NoNewline "L${i} Cache:"$size$unit
                    ""
                    $i--
                    }
                  } #END PROCESSOR FUNCTION

# Create memory information function
function memInfo { #convert bytes to GB -- bytes / 1,073,741,824
                   Get-CimInstance Win32_PhysicalMemory | Format-Table -AutoSize @{label="Description"; expression={$_.version}}, 
                                                                                 @{label="Vendor"; expression={$_.manufacturer}},
                                                                                 @{label="Size(GB)"; expression={($_.capacity / 1073741824)}},
                                                                                 @{label="Memory Bank"; expression={$_.banklabel}},
                                                                                 @{label="Memory Slot"; expression={$_.devicelocator}}
                   
                   foreach ($value in (Get-CimInstance Win32_PhysicalMemory).Capacity) { $total+=$value }
                   Write-Host -NoNewline "Total Memory:"($total / 1073741824)GB                                                             
                 }

# Create disk drive information function
function diskInfo {
                   $diskdrives = Get-CIMInstance CIM_diskdrive
                   foreach ($disk in $diskdrives) {
                            $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
                            foreach ($partition in $partitions) {
                                    $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
                                    foreach ($logicaldisk in $logicaldisks) {
                                            new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Model=$disk.model
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size"=[string]($logicaldisk.size / 1gb -as [int])+"GB"
                                                               "Free Space"=[string]($logicaldisk.freespace / 1gb -as [int])+"GB"
                                                               "Free"=[string]((($logicaldisk.freespace / $logicaldisk.size) * 100) -as [int])+"%"
                                                               } | Format-Table -AutoSize
           }
      }
  }
  }
# Use network adapter info from Lab 3 to create network adapter information function
function netAdaptInfo {
                        $netadapt=(Get-CimInstance Win32_NetworkAdapterConfiguration)
                        $dnsdomain=$netadapt.DNSDomain
                        if ([string]::IsNullOrWhiteSpace($dnsdomain) -eq "True") { $dnsdomain="data unavailable" }
                        Write-Output $netadapt | where {$_.ipenabled -eq "True"} | 
                        Format-Table -AutoSize -Property "Index","Description","IPaddress", @{label="Subnet Mask"; expression={$_.ipsubnet}},
                                                                                            @{label="DNS Server"; expression={$_.dnsserversearchorder}},
                                                                                            @{label="DNS Domain Name"; expression={$dnsdomain}} 

                       }

function videoInfo { 
                    $vidInfo=("Description","AdapterCompatibility")
                    
                    #FOREACH LOOP
                    foreach ($property in $vidInfo) {
                    $value=(Get-CimInstance Win32_VideoController).$property

                    if ([string]::IsNullOrWhiteSpace($value) -eq "True") { $value="Data Unavailable" } #make sure value isn't null/empty/whitespace

                    if ($property -eq "AdapterCompatibility") { $property="Vendor" } 
                   
                    Write-Host -NoNewline ${property}": "$value  #display info
                    ""
                                                    }
                    Write-Host -NoNewline "Screen Resolution:" (Get-CimInstance Win32_VideoController).CurrentHorizontalResolution "x" (Get-CimInstance Win32_VideoController).CurrentVerticalResolution
                }
# Display information from functions with headings
## Extra "" (blanklines) help display information more clearly  
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
""
#END OF SCRIPT