#==========================================================================
# Technique: Fichier CSV, cmdlet
#
# Cr�ation de plusieurs utilisateurs
# - supprime tous les utilisateurs dont le nom d�bute par EMP
# - cr�ation des utilisateurs
#
# AUTEUR: Richard Jean
# DATE  : 15 septembre 2021
#
# COMMENTAIRES: 
#	Le fichier CSV contient les informations pour cr�er les utilisateurs
#==========================================================================
Clear-Host

#----------------------------------------------------------------------------
# Supprime tous les utilisateurs de la OU FORMATION si le nom d�bute par EMP
$chemin = "OU=FORMATION,DC=FORMATION,DC=LOCAL"
Get-ADUser -Filter 'Name -like "EMP*"' `
           -SearchBase $chemin | Remove-ADUser -Confirm:$false
#----------------------------------------------------------------------------

# Fichier CSV
$NomFichier = "FORMATION_donnees.csv"
$FichierCSV = Import-Csv -Path $NomFichier `
                         -Delimiter ";"

# Initialisation des variable
$nomDNS = (Get-ADDomain).DnsRoot

$motDePasse = "AAAaaa111"
$mdp = ConvertTo-SecureString -AsPlainText $MotdePasse -Force

$Compte = 0

Foreach ($Ligne in $FichierCSV)
{
  $parent = $Ligne.Parent
  $prenom = $Ligne.Prenom
  $nom    = $Ligne.Nom
  $code   = $Ligne.Code
  $login  = $Ligne.Login

  $UserPrincipalName = "$login@$nomDNS"
  $DisplayName       = "$prenom $nom - $code"
  
  # IMPORTANT: cr�ation du compte utilisateur
  # Si on ne d�clare pas le param�tre -SamAccountName
  # le contenu de -SamAccountName sera le m�me que le param�tre -Name
  New-ADUser -Name $login `
             -UserPrincipalName $UserPrincipalName `
             -Path $parent `
             -GivenName $prenom `
             -Surname $nom `
             -DisplayName $DisplayName `
             -AccountPassword $mdp `
             -PasswordNeverExpires $true `
             -Enabled $true

   Write-Host "$login" -ForegroundColor Yellow
   
   $Compte++
}

Write-Host "Cr�ation de $Compte utilisateurs." -ForegroundColor Cyan
