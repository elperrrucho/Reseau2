#==========================================================================
# Technique: Fichier CSV, cmdlet
#
# Création de plusieurs utilisateurs
# - si l'utilisateur existe alors ne rien faire
# - si l'utilisateur n'existe pas alors il sera créé
#
# AUTEUR: Richard Jean
# DATE  : 3 septembre 2022
#
# COMMENTAIRES: 
#	Le fichier CSV contient les informations pour créer les utilisateurs
#==========================================================================
Clear-Host

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
  
  $resultat = Get-ADUser -Filter 'Name -eq $login'
  
  if ($resultat -ne $null)
  {
    $message = "$login existe."
    Write-Host $message  -ForegroundColor Green  
  }
  else
  {
    $message = "$login n'existe pas."
    Write-Host $message -ForegroundColor Yellow    

    # IMPORTANT: création du compte utilisateur
    # Si on ne déclare pas le paramètre -SamAccountName
    # le contenu de -SamAccountName sera le même que le paramètre -Name
    New-ADUser -Name $login `
               -UserPrincipalName $UserPrincipalName `
               -Path $parent `
               -GivenName $prenom `
               -Surname $nom `
               -DisplayName $displayName `
               -AccountPassword $mdp `
               -PasswordNeverExpires $true `
               -Enabled $true
    
     Write-Host "$login existe" -ForegroundColor Yellow
     
	 $Compte++
    }
}

Write-Host "Création de $Compte utilisateurs." -ForegroundColor Cyan
