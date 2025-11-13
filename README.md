SLCheck
1. Introducere
În cadrul acestui proiect, am dezvoltat un script shell care permite utilizatorului să verifice dacă există link-uri simbolice rupte într-un director dat și în subdirectoarele sale, într-o manieră recursivă. Scopul principal al acestui program este de a identifica link-uri simbolice care fac referire la fișiere sau directoare inexistente, cunoscute și sub denumirea de "broken links". Acest tip de verificare este util în administrarea sistemelor de fișiere, mai ales atunci când se lucrează cu link-uri simbolice care pot fi afectate de ștergerea sau deplasarea fișierelor de destinație. Rezultatele sunt salvate într-un fișier  denumit pe baza datei și orei curente.
Scenarii de utilizare
Acest script poate fi folosit în diverse scenarii, cum ar fi:
•	Verificarea integrității unui sistem de fișiere după ce o unitate de stocare a fost montată sau demontată.
•	Detectarea link-urilor rupte într-o structură de directoare complexă, pentru a preveni erori cauzate de referințe invalide.
Funcționalități
1. Verificarea broken links
2. Urmărirea link-urilor simbolice
3. Ștergerea broken links

2. Descrierea soluției
Soluția a fost implementată folosind un script shell, în care funcțiile de bază sunt organizate pentru a permite analiza recursivă a unui director. Scriptul face față cerinței de a identifica link-uri simbolice rupte, oferind totodată opțiunea de a urma link-urile către directoare atunci când utilizatorul specifică acest comportament printr-un flag. 



2.1. Funcția verifica_daca_exista_broken_links
Funcția verifica_daca_exista_broken_links este funcția principală care parcurge un director și detectează link-urile simbolice rupte. Aceasta lucrează recursiv, examinând fiecare subdirector. Dacă întâlnește un link simbolic, verifică dacă ținta sa există sau nu. În cazul în care link-ul simbolic nu mai este valid, funcția afișează un mesaj indicând link-ul rupt și ținta sa.
Fluxul funcției:
•	Se primește un director de analizat și un flag care decide dacă se vor urmări sau nu link-urile simbolice către directoare.
•	Pentru fiecare fișier sau subdirector din directorul curent, se verifică dacă este un link simbolic.
•	Se afiseaza directorul curent in care se cauta.
•	Dacă este un link simbolic, se verifică dacă ținta sa există (prin comanda -e). Dacă nu există, se raportează ca link rupt si se adauga in fisierul de output.
•	Dacă ținta este un director și utilizatorul a specificat flag-ul --follow-symlinks, scriptul va continua analiza recursivă pentru directorul respectiv.
•	Dacă întâlnește un subdirector, continuă analiza recursivă în interiorul acestuia.
•	Afiseaza numarul de link-uri rupte.
2.2. Functia stergere
Cauta recursive link-urile rupte si apoi le sterge.
2.3. Funcția main
Funcția main gestionează logica principală a scriptului, inclusiv validarea parametrilor de intrare. Aceasta verifică dacă a fost furnizat un director valid și opțiunea --follow-symlinks, dacă este cazul. Dacă directorul nu există, scriptul va opri execuția și va afișa un mesaj de eroare. Daca directorul este valid se apeleaza functia verifica_daca_exista_broken_links . Afisam mesajul “Vreti sa stergem Broken Links(DA / NU)” si in cazul unui input pozitiv  se apeleaza functia stergere.



Fluxul funcției:
•	Verifică dacă un director a fost furnizat ca parametru.
•	Se creeaza fisierul de output.
•	Verifică dacă al doilea parametru este flag-ul --follow-symlinks, și setează un flag corespunzător.
•	Verifică dacă directorul furnizat există și este valid.
•	Apelează funcția verifica_daca_exista_broken_links pentru a începe verificarea link-urilor simbolice.
3. Detaliile implementării
3.1. Argumentele scriptului
Scriptul primește două argumente:
1.	Directorul de pornire: Acesta este directorul în care se va începe căutarea link-urilor simbolice rupte. Este un argument obligatoriu.
2.	Flag-ul --follow-symlinks: Acesta este un argument opțional. Dacă este specificat, scriptul va urmări link-urile simbolice care indică directoare și va analiza recursiv acele directoare.
3.2. Comenzile și sintaxa shell utilizată
În cadrul scriptului, s-au folosit următoarele comenzi și funcționalități shell:
•	for entry in "$dir"/* - Buclează prin toate fișierele și subdirectoarele dintr-un director.
•	-L - Verifică dacă un fișier este un link simbolic.
•	-e - Verifică dacă un fișier sau director există si se poate folosii pentru schimbarea culorii textului in afisare.
•	readlink - Afișează destinația unui link simbolic.
•	-d - Verifică dacă o cale este un director.
•	echo - Afișează un mesaj în terminal.
•	exit - Iese din script în cazul unor erori sau condiții speciale.
•	$(date) - Returneaza ora si data curenta.
3.3. Fluxul recursiv
Recursivitatea este esențială în această implementare.					 Funcția verifica_daca_exista_broken_links apelează recursiv aceleași funcții pe subdirectoare, asigurându-se astfel că întreaga structură de directoare este verificată pentru link-uri rupte. Recursivitatea se oprește doar atunci când directorul  este parcurs in intregime.
4. Exemple de utilizare
4.1. Exemplu simplu
./check_broken_links.sh /path/to/directory
Acesta va verifica toate link-urile simbolice din directorul /path/to/directory, fără a urma link-urile simbolice către directoare.
4.2. Exemplu cu flag-ul --follow-symlinks
./check_broken_links.sh /path/to/directory --follow-symlinks
Acesta va verifica toate link-urile simbolice din directorul /path/to/directory și, dacă întâlnește un link simbolic către un director, va urma acele link-uri și va verifica și directorul respectiv.
4.3. Exemplu de mesaj de eroare
./check_broken_links.sh /invalid/directory
Error: /invalid/directory nu e director
În cazul în care directorul specificat nu există, scriptul va afișa un mesaj de eroare și va opri execuția.
5. Observații suplimentare
•	Performanță: Scriptul funcționează eficient pentru directoare de dimensiuni moderate. Dacă este folosit pe directoare foarte mari sau pe sisteme cu multe link-uri simbolice, timpul de execuție poate fi semnificativ mai mare.
•	Compatibilitate: Scriptul este compatibil cu majoritatea distribuțiilor Linux, fiind scris în shell Bash, care este standard pe majoritatea sistemelor Linux.
•	Extensibilitate: Scriptul poate fi extins pentru a include funcționalități suplimentare, cum ar fi raportarea link-urilor simbolice valide sau verificarea link-urilor hard, dacă este necesar.
6. Concluzii
Această soluție permite verificarea eficientă a link-urilor simbolice rupte într-un sistem de fișiere Linux, cu posibilitatea de a urmări recursiv directoarele referite de link-uri simbolice. Implementarea recursivă asigură că întreaga ierarhie de directoare este analizată în profunzime, iar opțiunea de a urmări link-urile simbolice către directoare oferă flexibilitate utilizatorilor care doresc să examineze structuri mai complexe.
