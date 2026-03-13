# Procesor MIPS Pipeline implementat în VHDL

Acest proiect reprezintă o implementare hardware a unui **procesor MIPS cu pipeline pe 5 stadii**, realizată în **VHDL**. Scopul proiectului este simularea și înțelegerea modului în care instrucțiunile sunt executate într-o arhitectură pipelined, precum și a interacțiunii dintre componentele principale ale procesorului.

## Descriere generală

Procesorul urmează arhitectura clasică **MIPS pipeline**, formată din următoarele 5 stadii:

1. **IF – Instruction Fetch**
2. **ID – Instruction Decode / Register Fetch**
3. **EX – Execute**
4. **MEM – Memory Access**
5. **WB – Write Back**

Prin folosirea pipeline-ului, mai multe instrucțiuni pot fi procesate simultan, fiecare aflându-se într-un stadiu diferit de execuție, ceea ce îmbunătățește performanța față de o implementare single-cycle.

## Funcționalități

- implementare a unui procesor MIPS pipelined pe 5 stadii
- proiect realizat integral în VHDL
- structură modulară, ușor de testat și extins
- simularea fluxului instrucțiunilor prin fiecare stadiu
- utilizarea registrelor de pipeline între etape
- proiect orientat spre studiu și înțelegerea arhitecturii calculatoarelor

## Arhitectură

Procesorul este compus din mai multe componente principale:

- **Program Counter (PC)**
- **Instruction Memory**
- **Register File**
- **ALU**
- **Data Memory**
- **Control Unit**
- **Sign Extension Unit**
- **Multiplexoare (MUX)**
- **Registre de pipeline**
  - IF/ID
  - ID/EX
  - EX/MEM
  - MEM/WB

Aceste componente colaborează pentru a executa instrucțiunile într-un mod pipelined.

## Instrucțiuni suportate

În funcție de implementare, procesorul poate suporta instrucțiuni de bază din setul MIPS, precum:

- `add`
- `sub`
- `and`
- `or`
- `slt`
- `lw`
- `sw`
- `beq`

## Tehnologii utilizate

- **VHDL**
- **Vivado**
- concepte de arhitectura calculatoarelor
- proiectare de sisteme digitale

## Mod de funcționare

Fiecare instrucțiune trece prin cele 5 stadii ale pipeline-ului:

### 1. Instruction Fetch (IF)
Instrucțiunea este citită din memoria de instrucțiuni folosind valoarea curentă a program counter-ului.

### 2. Instruction Decode (ID)
Instrucțiunea este decodificată, se citesc registrele sursă și se generează semnalele de control necesare.

### 3. Execute (EX)
ALU efectuează operațiile aritmetice și logice, calculează adrese sau evaluează condiții pentru instrucțiuni de branch.

### 4. Memory Access (MEM)
Memoria de date este accesată pentru instrucțiuni de tip load/store.

### 5. Write Back (WB)
Rezultatul final este scris înapoi în register file.

Între aceste stadii sunt utilizate registre de pipeline pentru a stoca datele și semnalele de control dintre etape.

## Simulare și testare

Pentru testarea proiectului:

1. Deschide proiectul în simulatorul VHDL utilizat.
2. Compilează toate fișierele sursă.
3. Rulează testbench-ul.
4. Analizează formele de undă (waveforms) pentru a verifica comportamentul pipeline-ului.

Obiectivele simulării includ:

- verificarea trecerii instrucțiunilor prin toate stadiile pipeline-ului
- validarea operațiilor efectuate de ALU
- verificarea citirii și scrierii în registre
- verificarea accesului la memoria de date
- observarea comportamentului instrucțiunilor de branch (dacă sunt implementate)

## Posibile îmbunătățiri

Proiectul poate fi extins prin adăugarea unor funcționalități precum:

- **unitate de detecție a hazardurilor (hazard detection unit)**
- **unitate de forwarding**
- **branch prediction**
- suport pentru mai multe instrucțiuni MIPS
- testbench mai complex pentru acoperire mai bună
- implementare pe FPGA

## Obiective de învățare

Prin realizarea acestui proiect au fost aprofundate următoarele concepte:

- proiectarea unui procesor pipelined
- descriere hardware folosind VHDL
- interacțiunea dintre datapath și unitatea de control
- paralelism la nivel de instrucțiune
- simularea și depanarea sistemelor digitale
