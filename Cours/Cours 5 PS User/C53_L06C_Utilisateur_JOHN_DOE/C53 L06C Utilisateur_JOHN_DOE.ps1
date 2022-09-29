#==========================================================================
# AUTEUR: Richard Jean 
# DATE  : 14 septembe 2021
#
# Création d'un utilisateur à l'aide des cmdlets du module ActiveDirectory
# L'utilisateur sera créé directement sous l'unité d'organisation TEST
#==========================================================================
# Utilisation de deux propriétés du domaine
$nomDom = "DC=formation,DC=local"
$nomDNS = "formation.local"

# Les 3 paramètres pour le pays Canada
$codePays = "CA"
$nomPays  = "CANADA"
$noPays   = 124

# La OU TEST est directement sous le domaine
$cheminOU = "OU=TEST,$nomDom"
$Prenom   = "JOHN"
$Nom      = "DOE"
$Desc     = "Utilisateur de la OU TEST"

# Le nom d'ouverture de session sera le PRÉNOM.NOM
$loginName = "$Prenom.$Nom"

# On efface le compte utilisateur avant de le créer
try
{
  Get-ADUser -Identity $loginName | Out-Null
  Write-Host "Le compte utilisateur $loginName existe, donc on l'efface." 

  Remove-ADUser -Identity $loginName -Confirm:$False
}
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
{
  Write-Host "Le compte $loginName n'existe pas." -ForegroundColor Yellow
}
catch
{
  Write-Warning "ERREUR INATTENDUE !!!"
  Exit
}

# IMPORTANT: création du compte utilisateur
# Si on ne déclare pas le paramètre -SamAccountName
# Le contenu de -SamAccountName sera le même que le paramètre -Name
$mdp = ConvertTo-SecureString -AsPlainText "AAAaaa111" -Force

New-ADUser -Name $loginName `
           -UserPrincipalName "$loginName@$NomDNS" `
           -Path $cheminOU `
           -GivenName $Prenom `
           -Surname $Nom `
           -DisplayName "$Prenom $Nom" `
           -Description $Desc `
           -Office "INFORMATIQUE" `
           -OfficePhone "514-999-6000" `
           -HomePhone "450-222-2222" `
           -MobilePhone "450-333-3333" `
           -Fax "450-444-4444" `
           -EmailAddress "$loginName@FORMATION.LOCAL" `
           -HomePage "WWW.FORMATION.LOCAL" `
           -OtherAttributes @{'c'=$codePays;'co'=$nomPays;'countryCode'=$noPays;
                              'otherTelephone'="514-999-7000","514-999-8000"} `
           -AccountPassword $mdp `
           -PasswordNeverExpires $true `
           -Enabled $true

Write-Host "Fin de la création du compte utilisateur $loginName"
