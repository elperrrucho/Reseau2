#-------------------------------------------------------------------
# Richard Jean
# 30 octobre 2021
#-------------------------------------------------------------------

Clear-Host

#-------------------------------------------------------------------
# Le serveur SERVEUR1 est le contrôleur de domaine
#-------------------------------------------------------------------
$ordi="SERVEUR1"
$chemin="\\" + $ordi + "\C$\_C53_"

# Supprime les anciens partages sur le serveur SERVEUR1
Get-SmbShare -Name C53_* -CimSession $ordi | Remove-SmbShare -Force -ErrorAction SilentlyContinue

# Supprime les anciens dossiers sur le serveur SERVEUR1
Remove-Item -Path $chemin"*" -Recurse -Force -ErrorAction SilentlyContinue

# Création des nouveaux dossiers sur le serveur SERVEUR1
new-item -itemtype directory -Path $chemin"Clients"
new-item -itemtype directory -Path $chemin"Inventaire"
new-item -itemtype directory -Path $chemin"Publicite"
new-item -itemtype directory -Path $chemin"Publicite\EMP09"
new-item -itemtype directory -Path $chemin"Publicite\EMP10"

#"Désactiver l’héritage" et "Supprimer toutes les autorisations héritées de cet objet"
  icacls.exe $chemin"Clients" /inheritance:r
# Ajout des autorisations NTFS
  icacls.exe $chemin"Clients" /grant "administrateurs:(CI)(OI)(F)"
  icacls.exe $chemin"Clients" /grant "system:(CI)(OI)(F)"
  icacls.exe $chemin"Clients" /grant "FORMATION\TECH:(CI)(OI)(F)"
  icacls.exe $chemin"Clients" /grant "grINF_Gestionnaires:(CI)(OI)(M)"

#"Désactiver l’héritage" et "Supprimer toutes les autorisations héritées de cet objet"
  icacls.exe $chemin"Inventaire" /inheritance:r
# Ajout des autorisations NTFS
  icacls.exe $chemin"Inventaire" /grant "administrateurs:(CI)(OI)(F)"
  icacls.exe $chemin"Inventaire" /grant "system:(CI)(OI)(F)"
  icacls.exe $chemin"Inventaire" /grant "FORMATION\TECH:(CI)(OI)(F)" 
  icacls.exe $chemin"Inventaire" /grant "grINF_Gestionnaires:(CI)(OI)(M)"

#"Désactiver l’héritage" et "Supprimer toutes les autorisations héritées de cet objet"
  icacls.exe $chemin"Publicite" /inheritance:r
# Ajout des autorisations NTFS
  icacls.exe $chemin"Publicite" /grant "administrateurs:(CI)(OI)(F)"
  icacls.exe $chemin"Publicite" /grant "system:(CI)(OI)(F)"
  icacls.exe $chemin"Publicite" /grant "FORMATION\TECH:(CI)(OI)(F)" 
  icacls.exe $chemin"Publicite" /grant "grINF_Gestionnaires:(RX)"

# Ajout des autorisations NTFS
  icacls.exe $chemin"Publicite\EMP09" /grant "EMP09:(CI)(OI)(M)"
  icacls.exe $chemin"Publicite\EMP10" /grant "EMP10:(CI)(OI)(M)"

# Les nouveaux partages sur le contrôleur de domaine
New-SMBShare -Name C53_Cli `
             -Path C:\_C53_Clients `
             -FullAccess "Tout le monde" `
             -CachingMode none `
             -FolderEnumerationMode AccessBased `
             -CIMSession $ordi

New-SMBShare -Name C53_InvB `
             -Path C:\_C53_Inventaire `
             -FullAccess "Tout le monde" `
             -CachingMode none `
             -FolderEnumerationMode AccessBased `
             -CIMSession $ordi 

New-SMBShare -Name C53_Pub `
             -Path C:\_C53_Publicite `
             -FullAccess "Tout le monde" `
             -CachingMode none `
             -FolderEnumerationMode AccessBased `
             -CIMSession $ordi

#-------------------------------------------------------------------
# Les nouveaux dossiers sur le "Serveur virtuel 2"
#-------------------------------------------------------------------
$ordi="SERVEUR2"
$chemin="\\" + $ordi + "\C$\_C53_"

# Supprime les anciens partages sur le "Serveur virtuel 2"
Get-SmbShare -Name C53_* -CimSession $ordi | Remove-SmbShare -Force -ErrorAction SilentlyContinue

# Supprime les anciens dossiers sur le "Serveur virtuel 2"
Remove-Item -Path $chemin"*" -Force -Recurse -ErrorAction SilentlyContinue

# Création des nouveaux dossiers sur le "Serveur virtuel 2"
new-item -itemtype directory -path $chemin"Commande"
new-item -itemtype directory -path $chemin"Inventaire"
new-item -itemtype directory -path $chemin"Production"
new-item -itemtype directory -path $chemin"Web"

#"Désactiver l’héritage" et "Supprimer toutes les autorisations héritées de cet objet"
  icacls.exe $chemin"Commande" /inheritance:r
# Ajout des autorisations NTFS
  icacls.exe $chemin"Commande" /grant "administrateurs:(CI)(OI)(F)"
  icacls.exe $chemin"Commande" /grant "system:(CI)(OI)(F)"
  icacls.exe $chemin"Commande" /grant "FORMATION\TECH:(CI)(OI)(F)" 
  icacls.exe $chemin"Commande" /grant "grINF_Gestionnaires:(CI)(OI)(M)"

#"Désactiver l’héritage" et "Supprimer toutes les autorisations héritées de cet objet"
  icacls.exe $chemin"Inventaire" /inheritance:r
# Ajout des autorisations NTFS
  icacls.exe $chemin"Inventaire" /grant "administrateurs:(CI)(OI)(F)"
  icacls.exe $chemin"Inventaire" /grant "system:(CI)(OI)(F)"
  icacls.exe $chemin"Inventaire" /grant "FORMATION\TECH:(CI)(OI)(F)"
  icacls.exe $chemin"Inventaire" /grant "grINF_Gestionnaires:(CI)(OI)(M)"

#"Désactiver l’héritage" et "Supprimer toutes les autorisations héritées de cet objet"
  icacls.exe $chemin"Production" /inheritance:r
# Ajout des autorisations NTFS
  icacls.exe $chemin"Production" /grant "administrateurs:(CI)(OI)(F)"
  icacls.exe $chemin"Production" /grant "system:(CI)(OI)(F)"
  icacls.exe $chemin"Production" /grant "FORMATION\TECH:(CI)(OI)(F)"
  icacls.exe $chemin"Production" /grant "grINF_Gestionnaires:(CI)(OI)(RX)"
  icacls.exe $chemin"Production" /grant "EMP10:(CI)(OI)(M)"

#"Désactiver l’héritage" et "Supprimer toutes les autorisations héritées de cet objet"
  icacls.exe $chemin"Web" /inheritance:r
# Ajout des autorisations NTFS
  icacls.exe $chemin"Web" /grant "administrateurs:(CI)(OI)(F)"
  icacls.exe $chemin"Web" /grant "system:(CI)(OI)(F)"
  icacls.exe $chemin"Web" /grant "FORMATION\TECH:(CI)(OI)(F)"
  icacls.exe $chemin"Web" /grant "grINF_Gestionnaires:(CI)(OI)(M)"

# Les nouveaux partages sur le "Serveur virtuel 2"
New-SMBShare -Name C53_Cmd `
             -Path C:\_C53_Commande `
             -FullAccess "Tout le monde" `
             -CachingMode none `
             -FolderEnumerationMode AccessBased `
             -CIMSession $ordi

New-SMBShare -Name C53_InvA `
             -Path C:\_C53_Inventaire `
             -FullAccess "Tout le monde" `
             -CachingMode none `
             -FolderEnumerationMode AccessBased `
             -CIMSession $ordi

New-SMBShare -Name C53_Prod `
             -Path C:\_C53_Production `
             -FullAccess "Tout le monde" `
             -CachingMode none `
             -FolderEnumerationMode AccessBased `
             -CIMSession $ordi

New-SMBShare -Name C53_Web `
             -Path C:\_C53_Web `
             -FullAccess "Tout le monde" `
             -CachingMode none `
             -FolderEnumerationMode AccessBased `
             -CIMSession $ordi
#-------------------------------------------------------------------
