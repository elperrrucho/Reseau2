# =============================================================================
# Richard Jean
# 12 septembre 2021
# NOTE 1: Le fichier CSV doit exister
# NOTE 2: Le script affiche l'adresse MAC en utilisant des "-"
# =============================================================================
Clear-Host

# Fichier CSV
$fCsv = "ORDI_MAC.csv"

# Importation du fichier CSV
$oCsv = Import-Csv -path $fCsv -Delimiter ";"

Foreach ($Ligne in $oCsv)
{
 $NomOrdinateur = $Ligne.NomOrdi
 $AdresseMAC    = $Ligne.AdresseMAC

 $AdresseMAC = $AdresseMAC.Replace(":","-")

 Write-Host "$AdresseMAC de l'ordinateur $NomOrdinateur" -ForegroundColor Yellow
}
