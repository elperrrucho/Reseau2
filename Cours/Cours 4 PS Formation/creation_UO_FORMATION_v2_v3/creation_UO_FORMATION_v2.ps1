#==========================================================================
# Technique: Fichier CSV avec PowerShell
#
# Création de la structure des unités d'organisation (version 2)
# 
# AUTEUR: Richard Jean
# DATE:   14 septembre 2021
#
# COMMENTAIRES: 
#   Le fichier csv contient
#   - le nom de la UO
#   - le DistinguishedName de son parent
#==========================================================================
Clear-Host

#-------------------------------------------------------------------------------
$OU = "OU=FORMATION,DC=formation,DC=local"

# On efface la OU
try
{
  # Si la OU n'existe pas il y aura un message d'erreur
  Get-ADOrganizationalUnit -Identity $OU | Out-Null
  $message = "$OU existe, donc on l'efface."
  Write-Host $message  -ForegroundColor Green

  # Si la OU existe, on permet de supprimer la OU
  Set-ADOrganizationalUnit -Identity $OU `
                           -ProtectedFromAccidentalDeletion $false

  Remove-ADOrganizationalUnit -Identity $OU `
                              -Recursive `
                              -Confirm:$false 
}
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
{
  $message = "$OU n'existe pas."
  Write-Host $message -ForegroundColor Yellow
}
catch
{
  Write-Warning "ERREUR INATTENDUE !!!"
  Exit
}

#-------------------------------------------------------------------------------
# Création de la structure des UO en utilisant le fichier CSV
$FichierCSV = Import-Csv -Path "UO_FORMATION.csv" `
                         -Delimiter ";"

$Compte = 0

Foreach ($Ligne in $FichierCSV)
{
  $Nom    = $Ligne.Nom
  $Parent = $Ligne.Parent
  
  New-ADOrganizationalUnit `
    -Name $Nom `
    -Path $Parent `
    -ProtectedFromAccidentalDeletion $false

  $Compte++
}

$message = "Création de $Compte unités d'organisation."
Write-Host $message
