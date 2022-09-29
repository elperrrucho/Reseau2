#==========================================================================
# Script pour afficher les GPO qui sont liées au DOMAINE et
# les GPO qui sont liées à chaque unité d'organisation.
#
# AUTEUR: Richard Jean
#         Département d'informatique
#
# NOTE: La longueur du GUID d'une GPO est de 36 caractères
#
# DATE:   24 septembre 2022
#==========================================================================
Clear-Host

#------------------------------------------------------------------------------------
# Trouve les GPO qui sont liées au niveau du DOMAINE
Write-Host "LA LISTE DES GPO LIÉES AU DOMAINE" -ForegroundColor Green
Write-Host ""

$nomDomaineDNS = (Get-ADDomain).DnsRoot
Write-Host $nomDomaineDNS -ForegroundColor Cyan

# Cette variable contient une ou plusieurs GPO qui sont liées au DOMAINE
# Malheureusement $gpoLinks est une STRING
$nomDomaine = (Get-ADDomain).distinguishedName
$gpoLinks = (Get-ADObject -Identity $nomDomaine -Properties gPLink).gPLink

# Pour faciliter la recherche on transforme le contenu de $gpoLinks en MAJUSCULE
$gpoLinks = $gpoLinks.ToUpper()

# On compte le nombre d'occurence de "CN={"
$selection = $gpoLinks | Select-String "CN={" -AllMatches
$compte = $selection.Matches.Count

# On trouve le nombre de caractères contenu dans $gpoLinks
$l = $gpoLinks.Length

# On trouve le nombre de caractères par "ligne"
# Chaque "ligne" débute par les 12 caractères suivants "[LDAP://CN={"
$n = $l / $compte

for ($i = 0 ; $i -le ($l - $n); $i += $n)
{ 
  $ligne = $gpoLinks.substring($i,$n)

  # On extrait le GUID pour afficher le nom de la GPO
  $GPOGuid = $ligne.Substring(12,36)

  Write-Host "$compte - " -ForegroundColor Yellow -NoNewline
  Write-Host "NOM = " (Get-GPO -Guid $GPOGuid).DisplayName
    
  $compte--
}

Write-Host ""
"=" * 80

#------------------------------------------------------------------------------------

# Trouve SEULEMENT les unités d'organisation qui ont des GPO liées
# De plus, le nom des unités d'organisation est en ordre alphabétique
$LinkedGPOs = Get-ADOrganizationalUnit -Filter * -Properties CanonicalName | Where-Object LinkedGroupPolicyObjects | Sort-Object CanonicalName

Write-Host ""
Write-Host "LA LISTE DES GPO LIÉES SUR LES UNITÉS D'ORGANISTATION" -ForegroundColor Green
Write-Host ""

foreach ($LinkedGPO in $LinkedGPOs)
{
   # Cette variable contient le nom de l'unité d'organisation
   $nomOU = $LinkedGPO.CanonicalName
   Write-Host $nomOU -ForegroundColor Cyan
   
   # Cette variable contient une ou plusieurs GPO qui sont liées
   $gpoLinks = $LinkedGPO.LinkedGroupPolicyObjects

   # Trouve le nombre de GPO liées
   $nombre_GPO = $gpoLinks.count
      
   foreach ($gpoLink in $gpoLinks)
   {
    # On extrait le GUID pour afficher le nom de la GPO
    $GPOGuid = $gpoLink.Substring(4,36)
    
    Write-Host "$nombre_GPO - " -ForegroundColor Yellow -NoNewline
    Write-Host "NOM = " (Get-GPO -Guid $GPOGuid).DisplayName
    
    $nombre_GPO--
   }

   "-" * 80   
}

Write-Host ""
Write-Warning "INFORMATION AU SUJET DE L'AFFICHAGE"
Write-Warning "On affiche le nom de l'unité d'organisation en CYAN sous la forme 'Canonical Name'."
Write-Warning "Le chiffre en JAUNE devant le nom de la GPO indique l'ordre de lien."
Write-Warning  "Plus le chiffre est petit plus grande est la priorité d'exécution de la GPO."
