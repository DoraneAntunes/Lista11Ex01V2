      $set sourceformat"free"

      *>Divisão de identificação do programa
       identification division.
       program-id. "Lista11Ex01V2".
       author. "Dorane M Antunes".
       installation. "PC".
       date-written. 24/07/2020.
       date-compiled. 24/07/2020.



      *>Divisão para configuração do ambiente
       environment division.
       configuration section.
           special-names. decimal-point is comma.

      *>-----Declaração dos recursos externos
       input-output section.
       file-control.

           select arqTemp assign to "arqTemp.txt"
           organization is line sequential
           access mode is sequential
           file status is ws-fs-arqTemp.

       i-o-control.

      *>Declaração de variáveis
       data division.

      *>----Variaveis de arquivos
       file section.
       fd arqTemp.
       01 fd-temp.
          05 fd-dia                                pic  9(02).
          05 fd-temperatura                        pic 99,00(04).

      *>----Variaveis de trabalho
       working-storage section.

       77  ws-fs-arqTemp                           pic  9(02).

       01 ws-temp.
          05 ws-dia                                pic  9(02).
          05 ws-temperatura                        pic 99,00(04).

       77 ws-sair                                  pic  x(01).
          88  fechar                               value "X" "x".
          88  voltar                               value "V" "v".

       01  ws-menu.
           05 ws-cadastrar                         pic  x(01).
           05 ws-consultar                         pic  x(01).

       77 teste                          pic x(12) value 'Helo, world'.

      *>----Variaveis para comunicação entre programas
       linkage section.


      *>----Declaração de tela
       screen section.

       01 tela-menu.

           05 blank screen.
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair ".
           05 line 02 col 01 value "                                Tela Principal                               ".
           05 line 04 col 01 value "      MENU                                                                   ".
           05 line 07 col 01 value "        [ ]Cadastrar Temperaturas                                            ".
           05 line 08 col 01 value "        [ ]Consulta de Temperaturas                                          ".
           05 line 12 col 01 value "                                                                             ".

           05 sc-sair              line 01 col 71 pic x(01)
           using ws-sair           foreground-color 12.
           05 sc-cadastrar         line 07 col 10 pic x(01)
           using ws-cadastrar      foreground-color 15.
           05 sc-consulta          line 08 col 10 pic x(01)
           using ws-consultar      foreground-color 15.

       01 tela-consulta.

           05 blank screen.
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair ".
           05 line 02 col 01 value "                         Consultando as Temperaturas                         ".
           05 line 04 col 01 value "                                                                             ".
           05 line 07 col 01 value " Dia         :                                                               ".
           05 line 08 col 01 value " Temperaturas:                                                               ".
           05 line 12 col 01 value " Deseja consultar mais uma temperatura? Aperte enter                         ".


           05 sc-sair              line 01 col 71 pic x(01)
           using ws-sair           foreground-color 12.
           05 sc-dia               line 07 col 16 pic 9(02)
           using ws-dia            foreground-color 15.
           05 sc-temp              line 08 col 16 pic 9(04)
           using ws-temperatura    foreground-color 15.


      *>Declaração do corpo do programa
       procedure division.


           perform inicializa.
           perform processamento.
           perform finaliza.

      *>------------------------------------------------------------------------
      *>  Procedimentos de inicialização
      *>------------------------------------------------------------------------
       inicializa section.

           .
       inicializa-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Processamento principal
      *>------------------------------------------------------------------------
       processamento section.


           move space to ws-sair
           perform until fechar

               display tela-menu
               accept  tela-menu

               if ws-cadastrar = "X"
               or ws-cadastrar = "x" then
                   perform cadastra-temp
               end-if

               if ws-consultar = "x"
               or ws-consultar = "X" then
                   perform consultar-temp

               end-if

           end-perform


           .
       processamento-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Rotina de consulta de temperatura  - lê o arquivo
      *>------------------------------------------------------------------------
       consultar-temp section.

           open input arqTemp
           if  ws-fs-arqTemp <> 0 then
               display "File Status ao abrir input arquivo: " ws-fs-arqTemp
           end-if


          perform until voltar

              read arqTemp
                  if  ws-fs-arqTemp <> 0
                  and ws-fs-arqTemp <> 10 then
                      display "File Status ao escrever arquivo: " ws-fs-arqTemp
                  end-if

                      move fd-temp                        to ws-temp

                      display tela-consulta
                      accept tela-consulta

          end-perform
               initialize ws-menu

           close arqTemp
           if ws-fs-arqTemp <> 0 then
               display "File Status ao fechar arquivo: " ws-fs-arqTemp
           end-if


           .
       consultar-temp-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  Rotina de cadastro de temperatura  - escreve no arquivo
      *>------------------------------------------------------------------------
       cadastra-temp section.

           open extend arqTemp
           if ws-fs-arqTemp <> 0 then
               display "File Status ao abrir input arquivo: " ws-fs-arqTemp
           end-if

           perform until voltar
               display erase

               display "dia: "
               accept  ws-dia       *> dia a ser cadastrado pelo usuário

               display "temperatura: "
               accept ws-temperatura *> temperatura a ser cadastrada pelo usuário

               move  ws-temp       to  fd-temp  *> Salvar os arquivos
               write fd-temp                    *> Escreve os dados no arquivo
               if ws-fs-arqTemp <> 0 then
                   display "File Status ao escrever arquivo: " ws-fs-arqTemp
               end-if

               display "Deseja cadastrar mais um dia? 'S' ou 'V'oltar"
               accept ws-sair


           end-perform

           close arqTemp
           if ws-fs-arqTemp <> 0 then
               display "File Status ao fechar arquivo: " ws-fs-arqTemp
           end-if
           .
       cadastra-temp-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Finalização
      *>------------------------------------------------------------------------
       finaliza section.

           Stop run
           .
       finaliza-exit.
           exit.


