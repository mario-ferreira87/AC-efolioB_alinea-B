;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ; Início do bloco A vvvvvvvv não alterar para baixo vvvvvvvv
                ; zona de dados
                ORIG 8000h
resultadosA     TAB     16
resultadosB     TAB     16
resultadosC     TAB     16
resultadosD     TAB     16
                ; jogos de teste para a alínea B
Jogo1           STR     476,68,66,63,9,6,3,1,0
Jogo2           STR     476,469,156,78,39,13,3,0
Jogo3           STR     1547,119,102,83,27,1
Jogo4           STR     4389,4370,2185,87,80,40,5,1
Jogo5           STR     3990,570,30,10,2,0
Jogo6           STR     833,17,0
Jogo7           STR     798,399,392,196,49,7,1
Jogo8           STR     1254,114,112,110,108,54,27,9,6,4,2,1
Jogo9           STR     884,68,34,32,16,14,7,1
Jogo10          STR     180,60,56,28,4,2,1
Jogo11          STR     1001,143,132,66,6,3,0
Jogo12          STR     931,912,910,455,91,1
Jogo13          STR     34,17,1
Jogo14          STR     1862,1813,906,453,1
Jogo15          STR     1020,510,255,51,1
Jogo16          STR     3762,3759,537,31,1
                ; colocar jogos
Jogos           STR Jogo1,Jogo2,Jogo3,Jogo4,Jogo5,Jogo6,Jogo7,Jogo8,Jogo9,Jogo10,Jogo11,Jogo12,Jogo13,Jogo14,Jogo15,Jogo16,0
                ; números de teste para a alínea C e D
Numeros         STR 476,66,5179,34,77,24,40,12,1155,6175,2520,1716,1377,7225,7,5,0
                ; zona para retornar as jogadas
jogadas         TAB     16
                ; zona para colocar os números primos 
                ; os jogos não podem ter números superiores ao maior primo
maxNumeros      EQU     1024
primos          TAB     maxNumeros

                        ; Final do bloco A ^^^^^^^^^ não alterar para cima ^^^^^^^^^
                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; Início do bloco B vvvvvvvv não alterar para baixo vvvvvvvv
                        ; zona do código
                ORIG 0000h

                ; inicialização do stack
Inicio:         MOV R1, fd1fh
                MOV SP, R1
                
                
                ; TESTE alinea A
                MOV R1, maxNumeros
                CALL PrimeirosPrimos     
                MOV R2, resultadosA
                MOV R4, 16               
CicloA:         DEC R1
                MOV R5, M[R1+primos]
                MOV M[R2], R5
                INC R2
                DEC R4
                BR.NZ CicloA
FimA:           Nop
                
                ; TESTE alinea B
                MOV R1, Jogos
                MOV R4, R0               
CicloB:         MOV R2, M[R1]
                CMP R2, R0
                BR.Z FimB
                PUSH R1
                PUSH R4
                CALL ValidarJogoPrimo    
                POP R4
                MOV M[R4+resultadosB], R1
                POP R1
                INC R4
                INC R1
                BR CicloB
FimB:           Nop               
                

                ; TESTE alinea C
                MOV R5, Numeros
                MOV R4, R0               
CicloC:         MOV R2, jogadas
                MOV R1, M[R5]
                CMP R1, R0
                BR.Z FimC
                PUSH R4
                PUSH R5
                CALL JogadasJogoPrimo
                POP R5
                POP R4
                MOV M[R4+resultadosC], R0
CicloC2:        DEC R1
                BR.N CicloC3
                MOV R3, M[R1+jogadas]
                ADD M[R4+resultadosC], R3
                BR CicloC2
CicloC3:        INC R5                  
                INC R4
                BR CicloC
FimC:           Nop

                ; TESTE alinea D
                MOV R5, Numeros
                MOV R4, R0              
CicloD:         MOV R1, M[R5]
                CMP R1, R0
                BR.Z FimD
                PUSH R4
                PUSH R5
                CALL JogoArtificialPrimo
                POP R5
                POP R4
                MOV M[R4+resultadosD], R1
                INC R5                  
                INC R4
                BR CicloD
FimD:           JMP Fim
                        ; Final do bloco B ^^^^^^^^^ não alterar para cima ^^^^^^^^^
                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; função PrimeirosPrimos solicitada na alínea A        ;
                        ; Entrada: R1 - número de primos pretendido            ; 
                        ; primos - endereço do local onde guardar os números   ;
                        ; Saída: resultado no endereço em R2                   ;
                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        
                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; Utilização do código do Exemplo 10 - Números Primos  ;
                        ; e adaptado à funcionalidade do programa              ;
                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        
                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ;     Utilização dos registos                                      ;
                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; R1 - número em consideração para primo                           ;
                        ; R2 - índice do primo até onde se tem que testar a divisão        ;
                        ; R3 - número com o quadrado de primo[R2], para actualização de R2 ;
                        ; R4 - número de primos encontrados                                ;
                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                            ; o número 1 não é considerado primo, apenas o 2 o será
PrimeirosPrimos:            MOV R1, 1

                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; até 4 não se testa a divisão, dado que 4 é o quadrado; 
                        ; de 2, o primeiro número primo                        ;
                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            
                            MOV R2, R0 
                        
                            ; o quadrado do primeiro número primo
                            MOV R3, 4 
                            
                            MOV R4, R0
                        
                            ; início do teste se o número R1 é primo ou não
ProxNum:                    INC R1

                            ; verificar se se atingiu o quadrado do primo até onde se testa
                            CMP R1, R3 

                            BR.N VerificarPrimo ; não, então prosseguir

                            ; actualizar o número até onde se testa, o primo[R2]
                            INC R2 

                            ; em R3 fica o quadrado do primo em teste
                            MOV R3, M[R2+primos] 
                            MOV R6, R3
                            MUL R6, R3 

                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; notar que se o quadrado ultrapassar os 16 bits, este algoritmo não funciona
                        ; apenas se considera que os primos cabem em 16 bits
                        ; o número actual em R1 não é primo, é quadrado de primo[R2], 
                        ; pelo que se pode passar para o próximo
                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                            BR ProxNum 

                            ; R5=0 a R2, com o índice dos primos testar a divisão
VerificarPrimo:             MOV R5, R0 

                            ; o próprio primo[R2] não é necessário, já que R1 é menor que primo[R2]^2
ContLoop:                   CMP R5, R2 

                            ; ainda aqui está e R5==R2, então este número é primo
                            BR.NN NovoPrimo 

                            ; dividir R1 por primo[R5], copiar R1 para R6
                            MOV R6, R1 

                            ; copiar primo[R5] para R7 para fazer divisão
                            MOV R7, M[R5+primos] 
                            DIV R6, R7

                            ; se a divisão der resto de zero...
                            CMP R7, R0 

                            ; divisivel! não é primo, passar para o próximo número
                            BR.Z ProxNum 

                            ; testar os restantes primos, até R2
                            INC R5 
                            BR ContLoop

NovoPrimo:                  MOV M[R4+primos], R1
                            INC R4
                            CMP R4, maxNumeros
                            BR.N ProxNum
        
                            MOV R1, maxNumeros

                RET
                
                
                
ValidarJogoPrimo:    MOV R1, R0

                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ; função ValidarJogoPrimo solicitada na alínea B               ;
                ; Entrada: R2 - endereço com as jogadas                        ;
                ; primos - endereço com os primeiros números primos            ;
                ; Saída: R1 - número de jogadas válidas                        ;
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ; Utilização de registos:                                      ;
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ; R1 - Número de jogadas válidas                               ;
                ; R2 - Endereço onde estão as jogadas                          ;
                ; R3 - Valor de K                                              ; 
                ; R4 - Valor de W                                              ;
                ; R5 - Memória de K                                            ;
                ; R6 - Memória de W                                            ;
                ; R7 - Memórias diversas                                       ;
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          
               
CicloSTRJogo:   MOV R3, M[R2]        ; Valor de K
                CMP R3, 0            ; verifica se K é 0
                JMP.Z FimCiclo       ; K=0 termina
                CMP R3, 1            ; verifica se K é 1
                JMP.Z FimCiclo       ; K=1 termina
                
                MOV R4, M[R2+1]      ; Valor de W
                                
                ; Primeira Condição K/W               
                MOV R5, R3           ; R5 como Memória de K
                MOV R6, R4           ; R6 como Memória de W
                DIV R5, R6           ; K/W
                MOV R7, R5           ; Guarda no R7 o valor da divisão
                
                CMP R6, R0           ; Para verificar o resto da divisão
                BR.Z VerificaPrimo   ; Resto diferente de zero, passa para segunda condição
                
                ; Segunda Condição K-W
                MOV R5, R3           ; R5 como Memória de K
                SUB R5, R4           ; R5=K-W
                MOV R7, R5           ; R7 Guarda resultado da Subtração          
                DIV R3, R5           ; K/(K-W)
                CMP R5, R0           ; Para verificar o resto da divisão
                BR.NZ FimCiclo       ; Resto diferente de zero, termina
                           
VerificaPrimo:  MOV R4, R0           ; Inicializar variável para percorrer primos

CicloPrimo: CMP R7, M[R4+primos]     ; Verifica se está na lista
                BR.Z PrimoNaLista    ; Se encontrou, incrementa R1                  
                INC R4               ; Próxima posição da lista de primos
                CMP R4, maxNumeros   ; Para verificar se chegou ao fim da lista
                BR.NZ CicloPrimo     ; Não é o fim, volta ao inicio da procura
                JMP FimCiclo         ; Acabou e não encontrou termina
                
PrimoNaLista:   INC R1               ; Soma Contador
              
                INC R2               ; Próxima posição da STR              
                JMP CicloSTRJogo

FimCiclo:       RET
                
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ; função JogadasJogoPrimo solicitada na alínea C
                ; Entrada: R1 - número K a processar
                ;          R2 - endereço no qual as jogadas devem ser colocadas
                ;          primos - endereço com os primeiros números primos
                ; Saída: R1 - número de jogadas; resultado no endereço R2
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
JogadasJogoPrimo:       MOV R1, R0
                                        

                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ; função JogoArtificialPrimo solicitada na alínea D
                ; Entrada: R1 - número K a processar
                ;          primos - endereço com os primeiros números primos
                ; Saída: R1 - valor W, com a jogada para K 
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
JogoArtificialPrimo:       MOV R1, R0
                RET


                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ; Início do bloco C vvvvvvvv não alterar para baixo vvvvvvvv
                ; última instrução, não alterar
Fim:            JMP Fim        
                ; Final do bloco C ^^^^^^^^^ não alterar para cima ^^^^^^^^^
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
