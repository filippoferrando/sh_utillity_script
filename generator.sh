#!/bin/bash
MATRICE="!$%&/()=?^ì'+èùàò-.,;:_ç°§é*@#]\|<>£0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
# ==> La password viene formata con caratteri alfanumerici.
LUNGHEZZA="10000"
# ==> Se desiderate passaword più lunghe modificate 'LUNGHEZZA'.


while [ "${n:=1}" -le "$LUNGHEZZA" ]
# ==> Ricordo che := è l'operatore "sostiruzione default".
# ==> Quindi, se 'n' non è stata inizializzata, viene impostata ad 1.
do
	PASS="$PASS${MATRICE:$(($RANDOM%${#MATRICE})):1}"
	# ==> Molto intelligente e scaltro.

	# ==> Iniziando dall'annidamento più interno...
	# ==> ${#MATRICE} restituisce la lunghezza dell'array MATRICE.

	# ==> $RANDOM%${#MATRICE} restituisce un numero casuale compreso tra 1
	# ==> e [lunghezza di MATRICE] - 1.

	# ==> ${MATRICE:$(($RANDOM%${#MATRICE})):1}
	# ==> restituisce l'espansione di lunghezza 1 di MATRICE 
	# ==> partendo da una posizione casuale.
	# ==> Vedi la sostituzione di parametro {var:pos:lun},
	# ==> con relativi esempi, al Capitolo 9.

	# ==> PASS=... aggiunge semplicemente il risultato al precedente 
	# ==> valore di PASS (concatenamento).

	# ==> Per visualizzare tutto questo più chiaramente, 
	# ==> decommentate la riga seguente
	#                 echo "$PASS"
	# ==> e vedrete come viene costruita PASS,
	# ==> un carattere alla volta ad ogni iterazione del ciclo.

	let n+=1
	# ==> Incrementa 'n' per il passaggio successivo.
done

echo "$PASS"      # ==> Oppure, se preferite, redirigetela in un file.

exit 0
