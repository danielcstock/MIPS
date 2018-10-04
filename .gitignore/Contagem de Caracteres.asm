.data
	arq: .asciiz 		"arquivo.txt"
	err: .asciiz 		"Arquivo não encontrado"
	buffer: .space 10000	# Tamanho máximo lido do file descriptor	
	
.text
	li $v0, 13		# Código para leitura de arquivos
	la $a0, arq		# Atribuição da variável com o nome do arquivo
	li $a1, 0		# Modo de abertura: Somente Leitura
	syscall			# Tentativa de abertura do arquivo
				# $v0 recebe um valor negativo se há falha na abertura
				# $v0 recebe o file descriptor se tem sucesso na abertura
	bgez $v0, funcao	# Se ($v0 >= 0) vá para funcao
	jal fechar_arquivo	# Chama a função fechar_arquivo()
	la $a0, err		# Atribuição da variável com a mensagem de erro
	li $v0, 4		# Código para impressão de string
	syscall			# Imprime o erro
	j encerra_programa	# Vai para encerra_programa

funcao:
	move $a0, $v0		# $a0 <= file descriptor
	li $v0, 14		# Código para leitura do file descriptor
	la $a1, buffer		# Buffer de leitura
	li $a2, 10000		# Número máximo de caracteres para leitura
	syscall			# Realiza a leitura do file descriptor
				# $v0 recebe um valor positivo que representa o número de caracteres lidos
				# $v0 recebe 0 se o arquivo acaba (EOF)
				# $v0 recebe um valor negativo se não consegue ler o file descriptor
	move $a0, $v0		# $a0 <= $v0
	li $v0, 1		# Código para impressão de inteiros	
	syscall			# Impressão dos caracteres lidos
	jal fechar_arquivo	# Chama a função fechar_arquivo()
	j encerra_programa	# Vai para encerra_programa
				
fechar_arquivo:
	li $v0, 16		# Código para fechar o arquivo
	syscall			# Fecha o arquivo em $a0
	jr $ra			# Retorna para a chamada da função fechar_arquivo()

encerra_programa:
	li $v0, 10		# Código para encerramento do programa
	syscall			# Encerra o programa	
