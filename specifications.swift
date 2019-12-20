/*----------------------------------------------------------------------------------------*/

/* Pion : */

// TPion(nomPion : String, maitre : Bool, couleurPion : Bool, position : (Int,Int), capture : Bool)
// nomPion sera du format : Mr ou Er1 à  Er4 (pour le maitre rouge et les élèves rouge de 1 à  4) et Mb ou Eb1 à  Eb4 (pour le maitre bleu et les élèves bleu de 1 à  4
// maitre : True si un pion est maître, False si élève (get)
// couleurPion : un pion pourra etre rouge ou bleu (get)
// position : les Int sont compris entre 0 et 4 car le plateau est de taille (5,5) si capture = True // alors position = (-1,-1) (get set)
// capture : False en debut de partie et True quand le pion sera capturé (get set)

protocol TPion{
    
    // init : String x Bool x Bool-> Tpion
    // création d'un pion
    // la position sera initialisée en fonction de la position dans le tableau du joueur au moment de leur création dans la partie
    // sa couleur sera la même que le joueur pour lequel il sera créé
    init(namePion : String, master : Bool, color : Bool, position: (Int,Int))
    
    // nomPion : TPion -> String
    // renvoie le nom du pion, ce qui sera utile ensuite pour voir les positions sur le plateau
    var nomPion : String { get }
    
    //position : TPion -> (Int,Int)
    //renvoie la position du pion
    var position : (Int,Int) { get }
    
    // couleurPion : TPion -> Bool
    // renvoie la couleur du pion (True si blanc , False si noir)
    var couleurPion : Bool { get }
    
    // master : TPion -> Bool
    // renvoie True si un pion est maître , False sinon
    var master : Bool { get }
    
    // seDeplacer : TPion x positionAjoute -> TPion
    // déplacer le pion vers une position                
    // pré-condition : la pos doit être une pos sur la carte jouée
    // pré-condition 2 : la pos ne doit pas être occupé par un pion allié et la position indiqué sur la carte doit exister (en fonction du pion joué - ne pas dépasser les limites du plateau-)
    //post-condition : utilise la fonction capture si la place est occupé par un pion adverse
    mutating func seDeplacer(positionAjoute : (Int,Int))
    
    // estCapture : TPion -> TPion
    //changer les positions du pion (-1,-1) pour montrer qu'il est capturé et qu'il sorte du plateau.
    //Pré-condition : le pion doit être présent sur le plateau et n'est donc pas déjà  capturé (pos: (-1,-1))
    mutating func estCapture()

    //supression de la fonction jouer car elle ne représentait aucun intérêt (en accord avec l'équipe adverse)
}



class Pion : TPion {
    
    //variables privées
    private var _nomPion : String
    private var _master : Bool
    private var _couleurPion : Bool
    private var _position : (Int, Int)

    //initialisation
    required init(namePion : String, master : Bool, color : Bool, position : (Int,Int)){
        self._nomPion = namePion
        self._master = master
        self._couleurPion = color
        self._position = position
    }
    
    //variables publiques
    var nomPion : String {return self._nomPion}
    var master : Bool {return self._master}
    var color : Bool {return self._couleurPion}
    var position : (Int,Int) {return self._position}
    var couleurPion: Bool {return self._couleurPion}
    

    //fonctions publiques 

    func seDeplacer(positionAjoute : (Int,Int)) {
         //vérification de la position si elle appartient au plateau de jeu 0 <= (x,y) <= 4
        if (positionAjoute.0 >= 0 && positionAjoute.0 <= 4 && positionAjoute.1 >= 0 && positionAjoute.1 <= 4){
            self._position = positionAjoute
        }
    }
    
    func estCapture() {
        if (self._position != (-1, -1)) {
            self._position = (-1, -1)
        }
    }

}


/*----------------------------------------------------------------------------------------*/

/* Carte : */

//TCarte(nomCarte : String, colorCarte : Bool, positionCaseDepart : (Int,Int),mvmtPossibles : [(Int,Int)])
// nomCarte : nom de l'école d'arts martiaux (voir exemple du sujet) (get)
// colorCarte : couleur de la carte (utilisé pour savoir qui commence) (get)
// positionCaseDepart : toujours la même position sur les cartes (case centrale) (get)
// mvmtPossibles : donne les couples de positions possibles d'accès en fonction de la case de départ de la carte (get)

protocol TCarte {
    
    // init : String x [(Int,Int)] -> TCarte
    // création d’une carte
    // la position de la case de depart sur la carte est (2,2) (avec la grille de (0 à 4,0 à 4)
    // ici la couleur de la carte sera attribuée au hasard dans l'initialisation.
    init(nomEcole : String, possibilites : [(Int,Int)])
    
    //nomCarte : TCarte -> String
    // renvoie le nom de l'école d'art de la carte
    var nomCarte : String { get }
    
    // colorCarte : TCarte -> Bool
    // renvoie la couleur de la carte
    var colorCarte : Bool { get }
    
    // mvmtPossible : TCarte -> [(Int,Int)]
    // renvoie la liste des différents mouvements possibles pour le pion
    var mvmtPossible : [(Int,Int)] { get }
    
    // detailsDeplacement : Int -> (Int,Int)
    // renvoie un couple d entier representant le nombre de case à ajouter en avant ou arriere et en lateral par rapport a la position de depart (Int,Int) de i - (Int,Int) depart.
    //Exemple : position possible (3,1) et case centrale (2,2) donc la fonction renverra : (1,-1)
    // pré-condition : numDeplacement correspond à l’un des indices du tableau mvmtPossibles
    func detailsDeplacement(numDeplacement : Int ) -> (Int,Int)
    
}



struct Carte : TCarte {

    //variables privées
    private var _nomCarte:String
    private var _mvmtPossible:[(Int,Int)] = []
    private var _colorCarte:Bool=false //initialisé à rouge

    //initialisation
    init(nomEcole:String,possibilites:[(Int,Int)]){ //rajouter la couleur dans le init ? 
        self._nomCarte = nomEcole

        //on convertit les positions afin de répondre à la structure de donnée (matrice)
        var mvmt_convertis : [(Int,Int)] = possibilites
        if(mvmt_convertis.count != 0){
            for i in 0...mvmt_convertis.count-1{
                mvmt_convertis[i] = (4-mvmt_convertis[i].1,mvmt_convertis[i].0)
            }
        }
        
        self._mvmtPossible = mvmt_convertis

        //la couleur de la carte dépend de son nom
        if(self._nomCarte == "Dragon" || self._nomCarte == "Tigre" || self._nomCarte == "Elephant"){
            self._colorCarte = true //correspond à bleu
        }
        if (self._nomCarte == "Lapin" || self._nomCarte == "Cobra" || self._nomCarte == "Boeuf"){
            self._colorCarte = false //correspond à rouge
        }
    }
    
    //variables publiques
    var nomCarte : String { return self._nomCarte }
    var mvmtPossible: [(Int, Int)] { return self._mvmtPossible }
    var colorCarte: Bool { return self._colorCarte }
    

    //fonctions publiques
    func detailsDeplacement(numDeplacement: Int) -> (Int, Int) {
        //on récupére le déplacement donné en paramètre de la carte
        let deplacement : (Int,Int) = self._mvmtPossible[numDeplacement]

        //calcul de la nouvelle position : on soustrait 2 pour savoir quel déplacement faire depuis la carte centrale
        let nv_x : Int = deplacement.0
        let nv_y : Int = deplacement.1
        let nv_position : (Int,Int) = (nv_x - 2,nv_y - 2)

        return nv_position
    }    
}




/*----------------------------------------------------------------------------------------*/

/* Joueur : */

// TJoueur(Pions : [TPion], couleurJoueur : Bool, carteJoueur : (TCarte,TCarte))
// Pions : liste des pions du joueur dont 4 élèves et 1 maître (get set), le tableau aura donc une taille de 5.
// couleurJoueur : couleur rouge ou bleu correspondant à la même couleur que les pions du tableau Pions (get)
// carteJoueur : couple de TCarte qui pourront être utilisées par le joueurs dans la mesure du possible (get set)

protocol TJoueur{
    
    // init : String -> TJoueur
    // création d’un joueur + les 2 cartes tirées en random
    init (color : Bool)
    
    // couleurJoueur : TJoueur -> Bool
    // renvoie la couleur du joueur, sera utile pour tester qui commence
    var couleurJoueur : Bool { get }
    
    // carteJoueur : TJoueur -> (TCarte,TCarte)
    // getter permettant de récupérer le couple de cartes que le joueur a en sa possession
    var carteJoueur : (TCarte,TCarte) { get set } //modification mis en get set !
    
    var Pions : [TPion] { get }
    
    // changeCarte : TJoueur x Int x TCarte -> TJoueur //TCarte ?
    // modifie le couple de TCarte du joueur en mettant la carte TCarte donnée à la place de la carte en position  Int du couple
    // Pré-condition : Int est un entier et appartient à {1,2}
    // Pré-condition 2 : la carte donnée en paramètre doit être la carte du milieu et le numéro de carte celui de la carte jouée dans le couple de cartes en main du joueur
    mutating func changeCarte(numéroCarte : Int, carteMilieu : inout TCarte)
}



class Joueur : TJoueur {
    
    //variables privées
    private var _couleurJoueur: Bool
    private var _Pions : [TPion]
    
    //initialisation
    required init(color:Bool){
        self._couleurJoueur = color

        //création des pions
        if(self._couleurJoueur){ //bleu
            let pion1 : TPion = Pion(namePion:"Eb1",master:false,color:color,position:(0,0))
            let pion2 : TPion = Pion(namePion:"Eb2",master:false,color:color,position:(0,1))
            let pion3 : TPion = Pion(namePion:"Mb",master:true,color:color,position:(0,2))
            let pion4 : TPion = Pion(namePion:"Eb3",master:false,color:color,position:(0,3))
            let pion5 : TPion = Pion(namePion:"Eb4",master:false,color:color,position:(0,4))
            self._Pions = [pion1,pion2,pion3,pion4,pion5]
        } else {
            let pion1 : TPion = Pion(namePion:"Er1",master:false,color:color,position:(4,0))
            let pion2 : TPion = Pion(namePion:"Er2",master:false,color:color,position:(4,1))
            let pion3 : TPion = Pion(namePion:"Mr",master:true,color:color,position:(4,2))
            let pion4 : TPion = Pion(namePion:"Er3",master:false,color:color,position:(4,3))
            let pion5 : TPion = Pion(namePion:"Er4",master:false,color:color,position:(4,4))
            self._Pions = [pion1,pion2,pion3,pion4,pion5]
        }
        
        let carte1 : TCarte = Carte(nomEcole:"",possibilites:[])
        let carte2 : TCarte = Carte(nomEcole:"",possibilites:[])

        //on initialise les cartes du joueur avec des cartes vide
        self.carteJoueur = (carte1,carte2)
    }
    
    //variables privées
    var couleurJoueur: Bool { return _couleurJoueur }
    var carteJoueur: (TCarte, TCarte)
    var Pions: [TPion] { return _Pions }
    
    //fonctions publiques
    func changeCarte(numéroCarte: Int, carteMilieu: inout TCarte) {
        if(numéroCarte == 0 ) {
            let temp : TCarte = self.carteJoueur.0
            self.carteJoueur.0 = carteMilieu
            carteMilieu = temp
        }else if(numéroCarte == 1){
            let temp : TCarte = self.carteJoueur.1
            self.carteJoueur.1 = carteMilieu
            carteMilieu = temp
        }
    }
    
}




/*----------------------------------------------------------------------------------------*/

/* Jeu : */


//TJeu(plateau : [[TPions?]], carteCentre : TCarte, joueurs1 : TJoueur,joueur2 : TJoueur, termine : Bool, joueurCourant : TJoueur) // Le plateau doit être une matrice [[TPion?](5)](5) on verra le tableau comme un repère cartésien (x,y) avec 0<=x<=4 et 0<=y<=4 // le joueur 1 aura la couleur rouge et sera placé sur la ligne du bas (soit la ligne y = 0 du plateau) // le joueur 2 aura la couleur bleu et sera placé sur la ligne du haut (soit la ligne y = 4 du plateau) // termine aura la valeur True si la partie est finie, false sinon // carteCentre sera la cinquième carte distribué lorsqu'on crée la partie et pourra être modifié //joueurCourant correspond au joueur qui est en train de jouer son tour

protocol TJeu{
    
    // init :[TCarte] -> TJeu //crée un plateau de couples d'entiers, deux joueurs et place leur pions respectifs sur ce plateau // Le plateau doit être une matrice [[TPion?](5)](5) // Les joueurs porteront les couleurs rouge et bleu // Les pions des joueurs seront placés en fonction de leur couleur chacun sa ligne de départ avec le maitre au centre et se faisant face.
    
    // Le joueur courant prend la valeur du joueur portant la couleur de la carte centrale // Pré-requis : Le tableau de carte en paramètre comportera au moins 5 cartes qui seront répartis au hasard entre les joueurs 1 (2cartes) et 2 (2 cartes également) et 1 au centre // Il faudra préciser que la partie n'est pas terminée.
    
    init(pioche : [TCarte])
    
    // carteCentre : TJeu -> TCarte // renvoie la carteCentrale du jeu
    var carteCentre : TCarte { get set } //mis en get set
    
    //verifierCartePion : TPion x TJeu x TCarte -> Bool //renvoie false si pour une carte et un pion donné, il n'y a pas de déplacement possible
    func verifierCartePion(pion : TPion , carte : TCarte) -> Bool
    
    //listePionVerifier : TCarte x TJeu -> [TPion?] //renvoie la liste des pions qui ont des déplacements possible avec les cartes du joueur courant
    func listePionVerifier(carte : TCarte) -> [TPion?]
    
    // deplacementPossible : TJeu x TPion x (Int,Int) -> Bool // renvoie True si la position du pion + la position donnée est encore dans le plateau, False sinon // pionVoulu est le pion que l'on souhaite déplacer // déplacement correspond au couple d'entier renvoyer par la fonction "detailsDeplacement" situé dans TCarte, qui permet de voir directement les ajouts à faire aux coordonnées du pion.
    
    func deplacementPossible( pionVoulu : TPion, deplacement : (Int,Int) ) -> Bool
    
    // deplacementPossibleCartePion : TJeu x TCarte x TPion -> [(Int,Int)] // renvoie le tableau des positions que le pion peut prendre en fonction de la carte donnée // ici il faudra utiliser la fonction détailsDéplacement situé dans TCarte, la fonction deplacementPossible de TJeu pourra également vous aider.
    
    func deplacementPossibleCartePion(carte : TCarte ,pion : TPion) -> [(Int,Int)]?
    
    // deplacerPion : TJeu x TPion x (Int,Int) -> TJeu // deplace le pion sur le plateau // la fonction seDeplacer située dans TPion sera utilisé // si un pion adverse était déjà placé sur la case en question alors on utilise la fonction estCapture() de TPion sur ce pion adverse avant de déposer le pion sur cette case.
    
    mutating func deplacerPion(pion : inout TPion, pos : (Int,Int))
    
    //plateau : TJeu -> [[TPion?]] //renvoie le plateau
    var plateau : [[TPion?]] { get }
    
    // joueurCourant : TJeu -> TJoueur // get : renvoie le joueur courant
    var joueurCourant : TJoueur { get set } //mis en get set
    
    // changerJoueurCourant : TJeu -> TJeu // change le joueur courant de la partie
    mutating func changerJoueurCourant()
    
    // termine : TJeu -> Bool // renvoie la valeur de termine True = terminé et False = en cours
    var termine : Bool { get }
    
    // existeDeplacement : TJeu -> Bool // renvoie s'il est possible pour le joueur courant de déplacer un pion. // True si possible , False sinon
    func existeDeplacement() -> Bool
    
    //existeDeplacementCarte : TJeu x TCarte -> Bool // renvoie True s'il existe des pions que l'on peut déplacer à carte donnée en paramètre, False sinon
    func existeDeplacementCarte(carte : TCarte) -> Bool
        
    // endBattle : TJeu -> Int x TJeu // renvoie 1 si le pion joué est le maitre et est arrivé sur la case centrale du joueur adverse renvoie 2 si le joueur a capturé le maître adverse, renvoie 3 si 1 et 2 et renvoie 0 sinon , termine devient True si une des deux conditions de fin est respectée
    
    mutating func endBattle() -> Int
    
}



class Jeu : TJeu {
    
    //variables privées
    private var _plateau : [[TPion?]]
    private var _joueur1 : TJoueur
    private var _joueur2 : TJoueur
    private var _pioche : [TCarte]
    private var _termine : Bool
    
    //initialisation
    required init(pioche: [TCarte]) { 
        self._plateau = [[TPion?]](repeating:[TPion?](repeating:nil,count:5),count:5)
        self._joueur1 = Joueur(color:false) //rouge
        self._joueur2 = Joueur(color:true) //bleu

        //placement des pions sur le plateau
        for i in 0...4 { 
            self._plateau [4][i] = self._joueur1.Pions[i] //joueur rouge
            self._plateau[0][i] = self._joueur2.Pions[i] //joueur bleu
        }

        self._pioche = pioche
        self._termine = false
        
        var rand = Int.random(in: 0...self._pioche.count-1)
        
        //cartes pour le joueur rouge
        //Première carte
        self._joueur1.carteJoueur.0 = self._pioche[rand]
        self._pioche.remove(at:rand)
        
        //Deuxième carte
        rand = Int.random(in: 0...self._pioche.count-1)
        self._joueur1.carteJoueur.1 = self._pioche[rand]
        self._pioche.remove(at:rand)
        
        //cartes pour le joueur bleu
        //Première carte
        rand = Int.random(in: 0...self._pioche.count-1)
        self._joueur2.carteJoueur.0 = self._pioche[rand]
        self._pioche.remove(at:rand)
        
        //Deuxième carte
        rand = Int.random(in: 0...self._pioche.count-1)
        self._joueur2.carteJoueur.1 = self._pioche[rand]
        self._pioche.remove(at:rand)
        
        //carte centrale
        rand = Int.random(in: 0...self._pioche.count-1)
        self.carteCentre = self._pioche[rand]
        self._pioche.remove(at:rand)
        
        //la couleur de la carte centrale donne le premier joueur courant
        if(self.carteCentre.colorCarte == self._joueur1.couleurJoueur) {
            self.joueurCourant = self._joueur1
        }
        else {
            self.joueurCourant = self._joueur2
        }
    }
    
    //variables publiques
    var plateau : [[TPion?]] {return self._plateau}
    var joueurCourant : TJoueur
    var termine : Bool {return self._termine}
    var carteCentre: TCarte
    
    //fonctions publiques
    func verifierCartePion(pion: TPion, carte: TCarte) -> Bool {
        let position_pion : (Int,Int) = pion.position
        
        //calcul pour chaques positions possibles
        var i : Int = 0
        var verif : Bool = false
        while (i < carte.mvmtPossible.count && !verif){ //conditon arret : si verif passe à true (cad qu'un déplacement est possible) et que i ne dépasse pas la taille des déplacements possibles que permet la carte
            
            //on récupère la position à ajouter à la position du pion. i représente le déplacement courant.
            var position_calculee : (Int,Int) = carte.detailsDeplacement(numDeplacement: i)
            
            //si le pion est bleu alors il faut multiplier par -1 les positions car les coord x et y sont exprimer en fonction des rouges
            if(pion.couleurPion){
                position_calculee = convertPourJoueurB(position: position_calculee)
            }
            
            let nv_x : Int = position_pion.0 + position_calculee.0
            let nv_y : Int = position_pion.1 + position_calculee.1
            //on regarde le déplacement du pion qui serait fait avec ce déplacement
            
            //on vérifie que x et y sont dans le plateau
            if (nv_x >= 0 && nv_x <= 4 && nv_y >= 0 && nv_y <= 4 ){ //si x et y sont à l'intérieur du plateau
                let contenu : TPion? = self._plateau[nv_x][nv_y]
                guard let c = contenu else { return true } //si contenu == nil
                if (c.couleurPion == pion.couleurPion) { //le contenu est un pion de la même couleur que le pion déplacé = impossible
                    verif = false
                } else { //le contenu est un pion de la couleur adverse, on pourra donc le capturer
                    verif = true
                }
            }
            i+=1
        }
        return verif
    }
    
    func listePionVerifier(carte: TCarte) -> [TPion?] {
        //var i : Int = 0
        var liste_res : [TPion?] = []
        for i in 0...self.joueurCourant.Pions.count-1 {
            let pion_courant : TPion = self.joueurCourant.Pions[i]
            if (verifierCartePion(pion: pion_courant, carte: carte)){
                liste_res.append(pion_courant)
            }
        }
        return liste_res
    }
    
    func deplacementPossible(pionVoulu: TPion, deplacement: (Int, Int)) -> Bool {
        let position_pion : (Int,Int) = pionVoulu.position
        
        var verif : Bool = false
        var nv_deplacement : (Int,Int) = deplacement
        
        if(pionVoulu.couleurPion){ //si le pion est rouge alors il faut multiplier par -1 les positions car les coord x et y sont exprimees en fonction des rouges
            nv_deplacement = convertPourJoueurB(position: deplacement)
        }
        
        let nv_x : Int = position_pion.0 + nv_deplacement.0
        let nv_y : Int = position_pion.1 + nv_deplacement.1
        //on regarde le déplacement du pion qui serait fait avec ce déplacement
        
        //on vérifie que x et y sont dans le plateau
        if (nv_x >= 0 && nv_x <= 4 && nv_y >= 0 && nv_y <= 4 ){ //si x et y sont à l'intérieur du plateau
            let contenu : TPion? = self._plateau[nv_x][nv_y]
            guard let c = contenu else { return true } //si contenu == nil
            if (c.couleurPion == pionVoulu.couleurPion) { //le contenu est un pion de la même couleur que le pion déplacé = impossible
                verif = false
            }
            else { //le contenu est un pion de la couleur adverse, on pourra donc le capturer
                verif = true
            }
        }
        return verif
    }
    
    func deplacementPossibleCartePion(carte: TCarte, pion: TPion) -> [(Int, Int)]? {
        if (verifierCartePion(pion: pion, carte: carte) == false){
            return nil
        } else {
            let position_pion : (Int,Int) = pion.position
            var tab_pos : [(Int,Int)] = []
            if(position_pion != (-1,-1)){
                //calcul pour chaque position possible
                var i : Int = 0
                while (i < carte.mvmtPossible.count){ //conditon arret : i dépasse la taille des déplacements possibles que permet la carte
                    
                    //on récupère la position à ajouter à la position du pion. i représente le déplacement courant.
                    var position_calculee : (Int,Int) = carte.detailsDeplacement(numDeplacement: i)
                    
                    //si le pion est rouge alors il faut multiplier par -1 les positions car les coord x et y sont exprimer en fonction des rouges
                    if(pion.couleurPion){
                        position_calculee = convertPourJoueurB(position: position_calculee)
                    }
                    
                    let nv_x : Int = position_pion.0 + position_calculee.0
                    let nv_y : Int = position_pion.1 + position_calculee.1
                    //on regarde le déplacement du pion qui serait fait avec ce déplacement
                    let nv_position : (Int,Int) = (nv_x,nv_y)
                    
                    //on vérifie que x et y sont dans le plateau
                    if (nv_x >= 0 && nv_x <= 4 && nv_y >= 0 && nv_y <= 4 ){ //si x et y sont à l'intérieur du plateau
                        let contenu : TPion? = self._plateau[nv_x][nv_y]
                        if let c = contenu {
                            if (c.couleurPion != pion.couleurPion) { //le contenu est un pion de la couleur inverse que le pion déplacé (on pourra alors le capturer)
                                tab_pos.append(nv_position)
                            }
                        } else {
                            tab_pos.append(nv_position)
                        } //si contenu == nil alors on pourra se déplacer
                    }
                    i+=1
                }
            }
            
            //on convertit les positions pour l'affichage afin d'être conforme au repère donné dans les specif
            for i in 0...tab_pos.count-1{
                tab_pos[i] = conversionPosition(pos: tab_pos[i], conv : false)
            }
            return tab_pos
        }
    }
    
    func deplacerPion( pion: inout TPion, pos: (Int, Int)) {
        
        let contenu : TPion? = self._plateau[pos.0][pos.1]
        if var c = contenu {
            if(c.couleurPion != pion.couleurPion){ //si c'est un pion adverse
                c.estCapture()
                self._plateau[pion.position.0][pion.position.1] = nil //on vide l'ancienne position de pion
                pion.seDeplacer(positionAjoute: pos) //on modifie la position du pion (set)
                self._plateau[pos.0][pos.1] = pion //on déplace le pion sur la nouvelle position du tableau
            }
        }
        else { //si la case est vide
            self._plateau[pion.position.0][pion.position.1] = nil
            pion.seDeplacer(positionAjoute: pos)
            self._plateau[pos.0][pos.1] = pion
        }
    }
    
    func existeDeplacement() -> Bool {
        var k : Int = 0
        var verif : Bool = false
        
        //on vérifie pour chaque pion et chaque carte du joueur si il exsite des déplacements
        while (k < self.joueurCourant.Pions.count && !verif){ //condition d'arret : on a parcouru tous les pions du joueur ou verif est passé à true (il existe au moins un déplacement possible)
            if (existeDeplacementCarte(carte: self.joueurCourant.carteJoueur.0) || existeDeplacementCarte (carte : self.joueurCourant.carteJoueur.1)) {
                verif = true
            }
            k+=1
        }
        
        return verif
    }
    
    func existeDeplacementCarte(carte: TCarte) -> Bool {
        //on vérifie s'il existe des pions que l'on peut jouer avec la carte donée en paramètre (true si c'est la cas false sinon)
        if(listePionVerifier(carte: carte).count == 0) {
            return false
        }
        else {
            return true
        }
    }
    
    func endBattle() -> Int {
        var res : Int = 0

        if(self.joueurCourant.couleurJoueur){ //joueur bleu
            var i : Int = 0
            var master : Bool = false
            var pion_master : TPion = self.joueurCourant.Pions[i] //master du joueur bleu


            while(i < self.joueurCourant.Pions.count && !master){ //condition d'arret : on a parcouru tous les pions du joueur ou master est passé à true (on a trouvé le master dans la liste)
                if(self.joueurCourant.Pions[i].master){
                    master = true
                    pion_master = self.joueurCourant.Pions[i]
                }
                i+=1
            }
            
            if(pion_master.position == (4,2)){ //si le master bleu est arrivé sur l'arche du joueur rouge (position en (4,2))
                self._termine = true
                res = 1
            }
            
            master = false
            i = 0
            var master_rouge : TPion = self.joueurCourant.Pions[i]
            while(i < self._joueur1.Pions.count && !master){//condition d'arret : on a parcouru tous les pions du joueur adverse ou master est passé à true (on a trouvé le master rouge dans la liste du joueur rouge)
                if(self.joueurCourant.Pions[i].master){
                    master = true
                    master_rouge = self._joueur1.Pions[i]
                }
                i+=1
            }
            
            if (master_rouge.position == (-1,-1)){ //si le master rouge s'est fait capturé
                self._termine = true
                res = 2
            }
            
            if(pion_master.position==(4,2) && master_rouge.position == (-1,-1)){ //si le master rouge s'est fait capturé et si le master bleu est arrivé sur l'arche du joueur rouge (position en (4,2))
                self._termine = true
                res = 3
            }
            
        } else { //joueur rouge
            var i : Int = 0
            var master : Bool = false
            var pion_master : TPion = self.joueurCourant.Pions[i] //master du joueur rouge

            while(i < self.joueurCourant.Pions.count && !master){ //condition d'arret : on a parcouru tous les pions du joueur ou master est passé à true (on a trouvé le master dans la liste)
                if(self.joueurCourant.Pions[i].master){
                    master = true
                    pion_master = self.joueurCourant.Pions[i]
                }
                i+=1
            }
            
            if(pion_master.position == (0,2)){ //si le master rouge est arrivé sur l'arche du joueur bleu (position en (0,2))
                self._termine = true
                res = 1
            }
            
            master = false
            i = 0
            var master_bleu : TPion = self.joueurCourant.Pions[i]
            while(i < self._joueur2.Pions.count && !master){//condition d'arret : on a parcouru tous les pions du joueur adverse ou master est passé à true (on a trouvé le master bleu dans la liste du joueur bleu)
                if(self.joueurCourant.Pions[i].master){
                    master = true
                    master_bleu = self._joueur2.Pions[i]
                }
                i+=1
            }
            
            if (master_bleu.position == (-1,-1)){ //si le master bleu s'est fait capturé
                self._termine = true
                res = 2
            }
            
            if(pion_master.position==(0,2) && master_bleu.position == (-1,-1)){ //si le master bleu s'est fait capturé et si le master rouge est arrivé sur l'arche du joueur bleu (position en (0,2))
                self._termine = true
                res = 3
            }
        }
        return res
    }
    
    func changerJoueurCourant(){
        if(self.joueurCourant.couleurJoueur == self._joueur1.couleurJoueur){
            self.joueurCourant = self._joueur2
        }
        else {
            self.joueurCourant = self._joueur1
        }
    }

    //fonctions privées

    //Résultat : La fonction permet de convertir la position donnée en paramètre afin que les pions bleus puissent être déplacés sur le plateau
    //param : position une position (x,y) avec 0 <= x,y <= 4. Cette position répond à la structure de la matrice
    private func convertPourJoueurB(position:(Int,Int)) -> (Int,Int){
        let pos_x : Int = position.0 * (-1)
        let pos_y : Int = position.1 * (-1)
        let convert_pos : (Int,Int) = (pos_x,pos_y)
        return convert_pos
    }

    //Résultat : La fonction permet de convertir les positions afin de correspondre à la structure d'une matrice et non au repère euclidien demandé
    //param : pos une position (x,y) avec 0 <= x,y <= 4. Le booleen permet de savoir si il faut convertir du repère euclédien au repère de la matrice (true) ou inversement (false) 
    private func conversionPosition(pos: (Int,Int), conv : Bool) -> (Int,Int){
        var nv_pos : (Int,Int)
        if(conv){
            nv_pos = (4-pos.1, pos.0)
        } else {
             nv_pos = (pos.1, 4-pos.0) 
        }
        return nv_pos
    }
}




/*----------------------------------------------------------------------------------------*/

/* Main : */


// création des cartes à mettre dans la pioche 
//*- seulement 5 cartes ont été créées par l'équipe adverse, nous en avons ajouté une afin de tester la robustesse -*
var Carte1 : TCarte = Carte(nomEcole : "Lapin",possibilites : [(1,1),(3,3),(4,2)])
var Carte2 : TCarte = Carte(nomEcole : "Boeuf",possibilites : [(2,1),(2,3),(3,2)])
var Carte3 : TCarte = Carte(nomEcole : "Cobra",possibilites : [(1,2),(3,1),(3,3)])
var Carte4 : TCarte = Carte(nomEcole : "Dragon",possibilites : [(0,3),(1,1),(3,1),(4,3)])
var Carte5 : TCarte = Carte(nomEcole : "Tigre",possibilites : [(2,1),(2,4)])
var Carte6 : TCarte = Carte(nomEcole : "Elephant", possibilites : [(1,2),(1,3),(3,2),(3,3)])

// création de la pioche et insertion des cartes dans la pioche
var TableauCarte : [TCarte] = [Carte1,Carte2,Carte3,Carte4,Carte5,Carte6]

// initialisation de la partie avec la pioche générée précédemment
var jeu : TJeu = Jeu(pioche : TableauCarte)

// condition d'arrêt du while Jeu.termine == True
while !jeu.termine {
    
    //affichage du joueur courant avec bleu et rouge affichés en couleur dans le terminal
    if(jeu.joueurCourant.couleurJoueur){
        print("C'est au tour du joueur \u{001B}[0;34mBleu \u{001B}[0;37mde jouer")
    } else {
        print("C'est au tour du joueur \u{001B}[0;31mRouge \u{001B}[0;37mde jouer")
    }

    //afichage du plateau
    var affichage : String = "     0    1    2    3    4 \n"
    for i in 0...4 {
        affichage += "\(4-i)  "
        for j in 0...4 {
            if let c = jeu.plateau[i][j] {
                if(c.couleurPion){
                    affichage += " \u{001B}[0;34m\(c.nomPion)\u{001B}[0;37m "
                    } else {
                        affichage += " \u{001B}[0;31m\(c.nomPion)\u{001B}[0;37m "
                    }
            } else {
                affichage += " --- "
            }
        }
        affichage += "\n"  
    }

    print(affichage)

    if(jeu.existeDeplacement()){
        var a : Int = 0 //compteur de carte possible
        var ListeCarte : [TCarte] = []// liste des cartes possibles de jouer
        if (jeu.existeDeplacementCarte(carte:jeu.joueurCourant.carteJoueur.0)){ // s'il existe des déplacements possibles pour la carte 1 on l'ajoute aux cartes que le joueur  peut choisir
            ListeCarte.append(jeu.joueurCourant.carteJoueur.0)
            a = a+1
        }
        if (jeu.existeDeplacementCarte(carte:jeu.joueurCourant.carteJoueur.1)){ // s'il existe des déplacements possibles pour la carte 2 on l'ajoute aux cartes que le joueur peut choisir
            ListeCarte.append(jeu.joueurCourant.carteJoueur.1)
            a = a+1
        }
        
        
        var carteJoue : TCarte = ListeCarte[0]
        var numCarte : Int = 0
        if a == 2 { // si le joueur peut choisir entre les deux cartes
            print("Vous pouvez choisir entre 2 cartes : \(ListeCarte[0].nomCarte) ou \(ListeCarte[1].nomCarte)")
            var b : Bool = false
            while !b {
                print("Vous devez donner une Carte : ")
                guard let choixCarte = readLine() else { fatalError("erreur de saisie") }
                for i in 0...1 {
                    if choixCarte == ListeCarte[i].nomCarte {
                        b = true
                        carteJoue = ListeCarte[i]
                        numCarte = i
                    }
                }
            }//condition d'arret b = vrai
        }else{
            print("Vous n'avez pas le choix vous devez jouer la carte : \(ListeCarte[0].nomCarte)")
            carteJoue = ListeCarte[0]
        }
        var ListePion : [TPion] = []
        var affiche_pions : String = "Vous avez le choix de jouer ces pions : "
        //on verifie pour chaque pion si il peut être joué
        for i in 0...4 {
            if (jeu.verifierCartePion(pion:jeu.joueurCourant.Pions[i],carte:carteJoue)){
                ListePion.append(jeu.joueurCourant.Pions[i])
                affiche_pions += "\(jeu.joueurCourant.Pions[i].nomPion), "
            }
        }

        print(affiche_pions)
        var b : Bool = false // condition d'arret du while pour savoir si le pion est dans la liste des pions a joué ou non
        var pionJoue : TPion = ListePion[0]// pion joué par le joueur a ce tour
        while !b {
            print("Vous devez donner le nom d'un Pion : ")
            guard let choixPion = readLine() else { fatalError("erreur de saisie") }
            for i in 0...ListePion.count-1 {// verifie si pion est dans la liste des pions a joué
                if choixPion == ListePion[i].nomPion {
                    b = true
                    pionJoue = ListePion[i]
                }
            }
        }
        
        // le joueur doit maintenant choisir où il va placer le pion
        let ListePosition : [(Int,Int)]? = jeu.deplacementPossibleCartePion(carte : carteJoue,pion : pionJoue) // liste des positions possibles du pion par rapport a la carte
        guard let liste_pos = ListePosition else { fatalError("il y a un problème, veuillez redémarrer le jeu")} //si la liste est vide ici ça n'est pas normal donc on conseille de redémarrer le programme
        var affiche_pos : String = ("Veuillez déplacer votre pion sur une des cases suivantes : ")
    
        for i in 0...liste_pos.count-1{
            affiche_pos += "\(liste_pos[i]), "
        }
        print(affiche_pos)
        var pos : (Int,Int) = (0,0) //position choisie
        b = false // condition d'arrêt de la boucle sera quand il sera vrai
        while !b {
            print("Veuillez entrer une première coordonnée pour déplacer votre pion (x) : ")
            guard let posxx = readLine() else {fatalError("erreur de saisie")}
            guard let posx = Int(posxx) else{fatalError("il faut donner un entier !")}
            print("Veuillez entrer une première coordonnée pour déplacer votre pion (y) : ")
            guard let posyy = readLine() else {fatalError("erreur de saisie")}
            guard let posy = Int(posyy) else {fatalError("il faut donner un entier !")}
            for i in 0...ListePosition!.count-1 { //oublie du -1
                if (ListePosition![i].0 == posx){
                    if (ListePosition![i].1 == posy) {
                        b = true
                        pos = (posx,posy)
                    }
                }
            }
            
        }
        //conversion de la position
        pos = (4-pos.1,pos.0)
        
        // on vérifie s'il existe déjà un pion adverse sur le plateau à la position donnée et si oui on capture le pion adverse

        //*- ici l'équipe des specifications avait oublié de verifier si c'est un pion adverse ou non -*
        if jeu.plateau[pos.0][pos.1] != nil {
            var j : TPion? = jeu.plateau[pos.0][pos.1]
            if(j!.couleurPion != jeu.joueurCourant.couleurJoueur){
                j!.estCapture()
                jeu.deplacerPion(pion: &pionJoue,pos : pos)
            }
        } else {
            jeu.deplacerPion(pion: &pionJoue,pos : pos)
        }

        //*- ici l'équipe des specifications avait oublié de rajouter le changement de carte -*
        var jeu_local : TJeu = jeu
        jeu.joueurCourant.changeCarte(numéroCarte : numCarte,carteMilieu : &jeu_local.carteCentre)
        
        if jeu.endBattle() == 0 {
            jeu.changerJoueurCourant()
        }
        if jeu.endBattle() == 1 { //case centrale de l'adversaire avec le maitre
            print("Votre art est supérieur grâce à la voie du Ruisseau")
        }
        if jeu.endBattle() == 2 { // pion maitre adverse capturé
            print("Votre art est supérieur grâce à la voie de la Pierre")
        }
        if jeu.endBattle() == 3 {
            print("Votre art est supérieur grâce à la voix du Ruisseau ET la voie de la Pierre")
        }


    }else{
        print("Vous ne pouvez faire aucun mouvement, choisissez une carte à échanger : \(jeu.joueurCourant.carteJoueur.0.nomCarte) ou \(jeu.joueurCourant.carteJoueur.1.nomCarte)")
        var carteJoue : Int = 0// carte choisie pour échange
        var b : Bool = false
        while !b {
            print("Vous devez donner une Carte : ")
            guard let choixCarte = readLine() else { fatalError("erreur de saisie") }
            if choixCarte == jeu.joueurCourant.carteJoueur.0.nomCarte {
                b = true
                carteJoue = 0
            }
            if choixCarte == jeu.joueurCourant.carteJoueur.1.nomCarte {
                b = true
                carteJoue = 1
            }
        }

        var jeu_local : TJeu = jeu
        jeu.joueurCourant.changeCarte(numéroCarte : carteJoue,carteMilieu : &jeu_local.carteCentre)
    }
}
if(jeu.joueurCourant.couleurJoueur){
    print("Le joueur gagnant est le joueur \u{001B}[0;34mBleu \u{001B}[0;37m")
} else {
    print("Le joueur gagnant est le joueur \u{001B}[0;31mRouge \u{001B}[0;37m")
}



