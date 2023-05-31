## PARA QUE NOSSO PROCESSADOR TENHA UM BOM FUTURO e não vire um FRANKSTEIN, alguns padrões devem ser estabelecidos.

### 1. Padrão de escrita de variáveis
    Para todas as variáveis, usaremos apenas letras minúsculas na definição do que a variável irá fazer. Ex: load, reg etc.
    Caso as variáveis aparaceçam mais de uma vez, especificaremos com letras maiúsculas, no caso de haver dois loads ou dois registradores, por ex. Ex: loadA, loadB, regA, regB.
    Para nomes com duas palavras, usamos underline. Ex: Operação_Memória, Registrador_Banco.

### 2. Nome de Arquivos
    Sempre que dividirmos em FD, UC e TB, colocaremos essas especificações ao final do nome, para que UC, FD e TB de uma descrição fiquem todas juntas.

### 3. PROCESSADOR
    O que as variáveis significam:
        OP_MEM: diz se o processador irá trabalhar com uma operação  aritmética (soma,sub) ou de memória (load,store).
            - OP_MEM = 1: significa que estamos no estado de operação DE MEMÓRIA, então só load e store devem funcionar.
            - OP_MEM = 0: significa que estamos no estado de operação ARITMÉTICA.

        ADD_SUB: diz se a ULA irá realizar uma soma ou uma subtração.
            - ADD_SUB = 0: SOMA
            - ADD_SUB = 1: SUBTRAÇÃO

        WE_mem e WE_reg: Variáveis complementares que indicam quando há load e quando há store. Funcionam apenas quando OP_MEM = 1.
            - WE_mem = 1 e WE_reg = 0: LOAD
            - WE_mem = 0 e WE_reg = 1: STORE


### 4. INSTRUÇÕES DO PROCESSADOR (PALAVRA)
    OPCODE: 
        7bits - indica a operação que a instrução deve fazer. Exemplos: add,subtract,load,store etc.

        ADD/SUB - 0110011
        ADDI / SUBI - 0010011
        LOAD - 0000011
        STORE - 0100011

    FUNCT3:
        0110011:
            0 - ADD e SUB
        0


### 4. FUTURO DESSE README
    Para que todos saibam o que está acontecendo, é necessário que sempre que uma grande alteração for feita, seja colocado aqui. Por exemplo, criamos uma nova variável de "Estado".
    Nesse caso, é importante dizer o que cada estado dessa variável faz.
    Para não termos que ficar caçando o que foi modificado, todas as alterações devem ser colocadas em seus respectivos tópicos E TAMBÉM no próximo Tópico de ATUALIZAÇÃO MAIS RECENTE.


### 5. ATUALIZAÇÃO MAIS RECENTE
    Criação do README

### 6. PROBLEMAS E OBSERVAÇÕES
    - Nossa ULA tilta quando o resultado da negativo. (10 - 20 = 123123183123139)
    - Para fazermos uma operação de SOMA/SUB, temos que lembrar que WE_reg deve receber 1, para que haja escrita no registrador
    - Sempre que ativamos um load, temos que lembrar de desativá-lo após o uso. Por exemplo, se faço load da mem[1] no reg[2], então load[2] = 1. No entanto, se faço, logo depois load da mem 2 no reg 3, o load[2] ainda está ativo, o que faz com que tanto o reg[3] quanto o reg[2] recebam o valor da mem 2.
    
### 7. ATUALIZAÇÃO MAIS RECENTE
    - Ajustar always na UC -> assíncrono passagem de estado;
    - Ajustar o STORE;
    - Fazer BRANCH, AUIPC, JAL, JALR;
    - Ajustar estado de reset (state so deve receber o fetch - não inicializar as coisa)