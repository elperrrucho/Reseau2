#--------------------------------------------------
# Richard Jean
# 21 avril 2022
#
# Ce script affiche le contenu d'un fichier CSV
#--------------------------------------------------
Clear-Host

# Nom du fichier CSV
$CSVPath = "INFO_EMPLOYES.CSV"

$lignes = Import-Csv -Path $CSVPath `
                     -Delimiter ";"

Write-Host $("-" * 80) -ForegroundColor Yellow

foreach ($ligne in $lignes)
{
  $ID           = $ligne.ID
  $Nom          = $ligne.Nom
  $Prenom       = $ligne.Prenom
  $DateEmbauche = $ligne.DateEmbauche
  $NomDept      = $ligne.Dept

  Write-Host "Le numéro d'employé de $Prenom $Nom est $ID."
  Write-Host "Il travaille au département $NomDept depuis le $DateEmbauche."
  Write-Host $("-" * 80) -ForegroundColor Yellow
}
