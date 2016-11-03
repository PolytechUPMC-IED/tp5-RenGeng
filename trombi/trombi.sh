#!/bin/sh

# Décompressage de l'archive passée en argument et affectation des noms des fichiers décompresser dans liste_fichier
liste_fichier=`tar xvzf $1`

# Création du fichier filieres.txt pour mettre les répertoires crés
touch filieres.txt

for image in $liste_fichier;
do
    # On affecte à spe le nom de la spé et annee le numéro de l'année
    spe=`echo $image | cut -d "_" -f 3`
    annee=`echo $image | tr "_" " " | tr "." " " | cut -d " " -f 4`
    # On crée le répertoire avec l'option -p pour éviter les erreurs
    mkdir -p $spe$annee
    # Si on trouve pas speannee dans filieres.txt alors on l'écrit
    if ! grep -q $spe$annee filieres.txt; then
	echo $spe$annee >> filieres.txt
    fi
    # On prend le nom et le prénom
    prenom=`echo $image | cut -d "_" -f 1`
    nom=`echo $image | cut -d "_" -f 2`
    # On convertit et on met l'image dans la bonne répertoire
    convert -resize 90x120 $image $spe$annee/$nom.$prenom.jpg
    
done
# On affecte a filieres la liste des répertoires créés
filieres=`cat filieres.txt`

for dossier in $filieres;
do
    # On crée le fichier index.html dans chaque répertoire
    echo "<html><head><title> Trombinoscope $dossier </title></head>\n<body>\n<h1 align='center'>Trombinoscope $dossier </hl>\n<table cols=2 align='center'>" > $dossier/index.html
    # On affecte à img_pour_html la liste des images triées
    img_pour_html=`ls $dossier | grep jpg | sort`
    for picture in $img_pour_html;
    do
	echo "<tr>\n<td><img src="$picture" width=90 height=120/>`echo $picture| cut -d "." -f 2`.`echo $picture | cut -d "." -f 1`</td>\n</tr>" >> $dossier/index.html
    done
    echo "</table>\n</body></html>" >> $dossier/index.html
done
    
rm -f *.jpg


