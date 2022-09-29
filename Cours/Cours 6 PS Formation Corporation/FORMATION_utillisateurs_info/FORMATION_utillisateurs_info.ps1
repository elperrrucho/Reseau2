#==========================================================================
# AUTEUR: Richard Jean 
# DATE  : 3 septembe 2022
#
# La variable $info contient toutes les informations sur les utilisateurs
# qui sont dans l'unité d'organisation "FORMATION".
# Le contenu de la variable $info est triées en ordre alphabétique selon
# la propriété CanonicalName.
#==========================================================================
Clear-Host

$OU = "OU=FORMATION,DC=FORMATION,DC=LOCAL"

$info = Get-ADUser -Filter 'Name -like "EMP*"' `
                   -SearchBase $OU `
                   -Properties CanonicalName  | Sort-Object CanonicalName

Write-Host ("-" * 100) -ForegroundColor Yellow

$info.CanonicalName

Write-Host ("-" * 100) -ForegroundColor Yellow

$info.DistinguishedName

Write-Host ("-" * 100) -ForegroundColor Yellow
