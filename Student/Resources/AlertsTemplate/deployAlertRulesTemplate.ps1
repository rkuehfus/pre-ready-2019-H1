Connect-AzAccount

#Specify your resourcegroup
$rgname="your-resourcegroupName-here"
$rg = Get-AzResourceGroup -Name $rgname

#Get Azure Monitor Action Group
(Get-AzResource -ResourceType 'Microsoft.Insights/actiongroups').ResourceId

#Update Path to files as needed
#Update the parameters file with the names of your VMs and the ResourceId of your Action Group (use command above to find ResourceId)
$template=".\AlertsTemplate\GenerateAlertRules.json"
$para=".\AlertsTemplate\deployAlertRules.parameters.json"

$job = 'job.' + ((Get-Date).ToUniversalTime()).tostring("MMddyy.HHmm")
New-AzResourceGroupDeployment `
  -Name $job `
  -ResourceGroupName $rg.ResourceGroupName `
  -TemplateFile $template `
  -TemplateParameterFile $para

#To check your results - Get metric Alerts Rule for Resourcegroup
Get-AzResource -ResourceGroupName $rg.ResourceGroupName -ResourceType 'Microsoft.Insights/metricalerts' -Name CPU*| ft

#To delete your Alert Rules
Get-AzResource -ResourceGroupName $rg.ResourceGroupName -ResourceType 'Microsoft.Insights/metricalerts'  -Name CPU* | Remove-AzResource -Force