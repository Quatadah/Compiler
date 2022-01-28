# Les fonctionnalités réalisées
**On a réaliser toutes les fonctionnalités mentionnées dans le sujet de projet.**

# Etapes de compilation des tests de projet:

1. Depuis le répertoire parent, on tape la commande "make" qui permet d'éxecuter les fichiers *lang.l* et *lang.y*.
2. Ensuite, on lance ./lang sur les tests qu'on a crée dans le répertoire *test* (ces fichiers sont nommées *testX_Y.my*. X représente le numéro de la fonctionnalité qu'on vérifie dans le test) et la sorite de cette execution est dirigée vers les fichiers *testX_Y.c* qui représente la traduction des fichiers de langage MyC en des fichiers de langage PCode dans le repértoire PCode.
3. Enfin,pour créer les exécutables des fichiers *testX_Y.c* on éxecute la commande make dans le répertoire PCode, ce qui crée les executables ./testX_Y pour le fichier *testX_Y.c*.

# Etapes de compilation des fichiers myc quelconques:

* Dans le repertoire parent, il y a le script *compil* qui prend comme argument le nom de fichier (par exemple, si on veut compiler le fichier test1_1.myc on tape la commande **./compil test1_1.myc**).**Le fichier doit etre placé dans le repertoire *test***.
* Ce script permet de créer les fichiers de tests qu'on a fait, un fichier pcode*result_compil.c* et un éxecutable *result_compil* dans le repertoire *PCode* . Ces derniers sont la traduction en pcode du fichier  myc passé en paramètre de script.

# Remarques générales

* Pour les conditions et les boucles, on a considéré qu'ils ne sont pas des **blocks** d'après vos tests dans le répertoire PCode (dans le langage C, ils sont considéré comme des blocks).

* On a utilisé le champs *int_val* de la structure ATTRIBUTE pour stocker les *offsets* des identifiants car il est inutile dans le cas des attributs qui ne sont pas des NUM.  

* A l'éxecution de test7_3, quelques *warning* sont crées car on teste les fonctions récursifs liées *pair* et *impair* ce qui nous impose à appeller les fonctions avant la définir(on ne peut pas mettre des prototypes de fonctions en myc). Mais malgré les warning, le test marche bien.