#### Network Configuration Display ####

## Get network adapter configuration info & assign to variable
$netadapt=(Get-CimInstance Win32_NetworkAdapterConfiguration)

## Filter only wanted information
Write-Output $netadapt | where {$_.ipenabled -eq "True"} | 
    Format-Table -Property "Index","Description","IPaddress", @{label="Subnet Mask"; expression={$_.ipsubnet}},
                                                              @{label="DNS Server"; expression={$_.dnsserversearchorder}},
                                                              @{label="DNS Domain Name"; expression={$_.dnsdomain}}
## END OF SCRIPT