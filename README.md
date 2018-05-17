# Azure Infrastructure Security Lab
**Author** [Thomas Janetscheck](https://about.me/tjanetscheck)

**This repository is currently in preview. PowerShell scripts and ARM templates are still in development, do not use them in production!**


# Content
This repository contains PowerShell scripts and ARM templates that are used to automatically deploy an Azure hands-on lab environment.
1. [Prerequisites](https://github.com/azureandbeyond/AzureSecLab/blob/master/README.md#prerequisites)
2. [Background information](https://github.com/azureandbeyond/AzureSecLab/blob/master/README.md#background-information)
3. [Initial lab deployment](https://github.com/azureandbeyond/AzureSecLab/blob/master/README.md#initial-lab-deployment)


## Prerequisites
To be able to attend the workshop and complete all hands-on demos, a valid Azure subscription is required. If you don't currently own a subscription or don't have access to one, you can sign up for a free trial [here](https://azure.microsoft.com/en-us/free/).


## Background information
In this one-day workshop you will learn how to securely deploy Azure infrastructure solutions. We will cover the following topics:
* Azure Security Center
* Virtual Machines
* Azure Networking
* JIT
* Azure Storage
* Azure SQL
* RBAC
* Governance


## Initial lab deployment
All user names and password for the environment are set to **labuser / Secur1tyR0cks**.

**1.** Login to [Azure Primary Portal](https://portal.azure.com) with an account that has administrative rights on an active Azure subscription.

**2.** In [Azure Portal](https://portal.azure.com) start an Azure cloud shell session clicking on the "**>_**" symbol in the top right corner of the portal. Make sure the shell is set to PowerShell instead of Bash as shown in the screen shot below.

![Azure Cloud Shell](https://github.com/azureandbeyond/AzureSecLab/blob/master/pics/AzureCloudShell.png)

**3.** To create the lab ressources copy the code below into Azure Cloud Shell and execute it.

```powershell
$script = Invoke-WebRequest https://raw.githubusercontent.com/azureandbeyond/AzureSecLab/master/PowerShell/deployLab.ps1 -UseBasicParsing
Invoke-Expression $($script.Content)
```

The deployment takes up to 15 minutes. After the deployment has finished you will be informed in Azure Cloud Shell.