	.arch armv5t   										--arquitetura
	.fpu softvfp   
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"main.c"
	.section	.rodata
	.align	2
.LC0:
	.ascii	"file/meta.dat\000"							--caminho para meta.dat
	.align	2
.LC1:
	.ascii	"file/data.dat\000"							--caminho para data.dat
	.align	2
.LC2:
	.ascii	"r\000"										--r para o 2 atributo do fopen 'read only' 
	.align	2
.LC3:
	.ascii	"Nao foi possivel abrir o arquivo\000"		--se nao conseguir abrir meta.dat
	.align	2
.LC4:
	.ascii	"numero de campos: %d \012\000"
	.align	2
.LC5:
	.ascii	"Campo: %s\012\000"
	.align	2
.LC6:
	.ascii	"Tipo %s\012\000"
	.align	2
.LC7:
	.ascii	"Tamanho %d\012\000"
	.align	2
.LC8:
	.ascii	"r+\000"
	.align	2
.LC9:
	.ascii	"Nao foi possivel abrir arquivo\000"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {r4, fp, lr}		--lista de registradores a serem lidos
	add	fp, sp, #8  			--fp=sp+8
	sub	sp, sp, #60 			--sp=sp-60
	mov	r3, #0  			--r3=0
	str	r3, [fp, #-52] 			--(fp-52)=r3	(fp-52)<=FILE *mdb=NULL
	mov	r3, #0				--r3=0
	str	r3, [fp, #-48]			--fp-48=r3	(fp-48)<=FILE *db=NULL
	ldr	r3, .L28			--r3= .LC0 r3<=conteudo char *mdt
	str	r3, [fp, #-44]			--(fp-44)=r3 => char *mdt = (fp-44)
	ldr	r3, .L28+4			--r3= .LC1 r3<=conteudo char *data
	str	r3, [fp, #-40]			--(fp-40)=r3 => char *data =(fp-40)
	ldr	r0, [fp, #-44]			--r0=(fp-44) r0<= *mdt
	ldr	r1, .L28+8			--r1= .LC2  r1<=operação para abertura do arquivo 'r'
	bl	fopen				--function fopen(arq-name.*,format to open) in this case ("file/meta.dat","r") read-only
	str	r0, [fp, #-52]			--(fp-52)=r0 resultado do fopen é guardado no r0 e do r0 para o endereço (fp-52) *mdb
	ldr	r3, [fp, #-52]			--r3=(fp-52)	r3<=guarda o file meta.dat no r3
	cmp	r3, #0				--r3==NULL	r3<=verifica se o arquivo é NULL
	bne	.L2				--if not equal jump to L2
	ldr	r0, .L28+12			--r0= .LC3
	bl	puts				--imprime r0
.L2:
	mov	r3, #0				--r3=0
	str	r3, [fp, #-68]			--(fp-68)=r3	int a
	mov	r3, #0				--r3=0
	str	r3, [fp, #-64]			--(fp-64)=r3	int b
	mov	r3, #0				--r3=0
	str	r3, [fp, #-36]			--(fp-36)=r3	mttype *mt=NULL
	mov	r0, #52				--r0=52		tamanho de mttype
	bl	malloc				--alocação de memoria
	mov	r3, r0				--r3=r0
	str	r3, [fp, #-36]			--(fp-36)=r3	resultado do malloc movido r3<=r0 e guardado em (fp-36)
	mov	r3, #0				--r3=0
	str	r3, [fp, #-32]			--(fp-32)=r3	char *out=NULL
	mov	r0, #16				--r0=16		tamanho para malloc de (*char) * 4
	bl	malloc				--branch-link alocação de memoria
	mov	r3, r0				--r3=r0
	str	r3, [fp, #-32]			--(fp-32)=r3	armazena resultado do malloc no r3 e da um store para (fp-32)
	sub	r3, fp, #68			--r3=fp-68	armazena endereço do int a
	mov	r0, r3				--r0=r3		int a para r0
	mov	r1, #4				--r1=4		4 ou tamanho de int para r1
	mov	r2, #1				--r2=1		quantas vezes o tamanho sera lido para r2
	ldr	r3, [fp, #-52]			--r3=(fp-52)	carrega *mdb no r3
	bl	fread				--Função de leitura de arquivo r0 endereço a guardar, r1 tamanho do dado, r2 numero de vezes do tamanho ser carregado e r3 FILE *mdb
	ldr	r3, [fp, #-68]			--r3=(fp-68) carrega int a r3
	ldr	r0, .L28+16			--r0= .LC4	carrega numero de campos
	mov	r1, r3				--r1=r3		int a vai para r1
	bl	printf				--função printf imprimir numero de campos do meta.dat
	ldr	r2, [fp, #-68]			--r2=(fp-68)	r2= int a
	ldr	r3, [fp, #-36]			--r3=(fp-36) 	r3=mttype *mt ja alocado
	str	r2, [r3, #0]			--(r3+0)=r2	int a guardado no primeiro espaço do mttype *mt
	mov	r3, #0				--r3=0		r3=0
	str	r3, [fp, #-60]			--(fp-60)=r3	int i=0
	mov	r3, #0				--r3=0
	str	r3, [fp, #-56]			--(fp-56)=r3	int c
	mov	r3, #0				--r3=0
	str	r3, [fp, #-60]			--(fp-60)=r3	novamente i=0
	b	.L3				--jump to .L3	inicio do for
.L10:
	ldr	r3, [fp, #-60]			--r3=(fp-60)	int i =>r3
	mov	r3, r3, asl #2			--r3=r3 shift left 2x	int i*4
	ldr	r2, [fp, #-32]			--r2=(fp-32)	r2=inicio do char *out
	add	r4, r2, r3			--r4=r2+r3	r4=inicio do char *out + deslocamento (i*4)
	mov	r0, #8				--r0=8		tamanho de char * 8
	bl	malloc				--alocação de memoria r0
	mov	r3, r0				--r3=r0		resultado de malloc para r3
	str	r3, [r4, #0]			--(r4+0)=r3	r3 é guardado no endereço que está no r4
	ldr	r3, [fp, #-60]			--r3=(fp-60)	r3= int i
	cmp	r3, #3				--r3==3		if(i==3)
	ldrls	pc, [pc, r3, asl #2]		--se i <= 3 pc carrega um dos cases
	b	.L4				--jump to .L4
.L9:
	.word	.L5				--case 0
	.word	.L6				--case 1
	.word	.L7				--case 2
	.word	.L8				--case 3
.L5:
	mov	r3, #5				--r3=5    (i==0)c=5
	str	r3, [fp, #-56]			--(fp-56)=r3
	b	.L4				--branch to .L4
.L6:
	mov	r3, #6				--r3=6		(i==1)c=6
	str	r3, [fp, #-56]			--(fp-56)=r3
	b	.L4				--branch to .L4
.L7:
	mov	r3, #4				--r3=4		(i==2)c=4
	str	r3, [fp, #-56]			--(fp-56)=r3
	b	.L4				--branch to .L4
.L8:
	mov	r3, #6				--r3=6		(i==3)c=6
	str	r3, [fp, #-56]			--(fp-56)=r3
	mov	r0, r0	@ nop			--r0=r0 not operation
.L4:
	ldr	r3, [fp, #-60]			--r3=(fp-60) 	r3=int i
	mov	r3, r3, asl #2			--r3=r3 shift left 2x  	int i * 4
	ldr	r2, [fp, #-32]			--r2=(fp-32) 	r2=char **out
	add	r3, r2, r3			--r3=r2+r3  	r3=int i + char **out
	ldr	r2, [r3, #0]			--r2=(r3+0) 	r2 recebe char out[i*4]
	ldr	r3, [fp, #-56]			--r3=(fp-56) 	r3= int c
	mov	r0, r2				--r0=r2		char out[i] vai para r0
	mov	r1, #1				--r1=1		r1 recebe sizeof(char)
	mov	r2, r3				--r2=r3		r2 recebe int c tamanho de vezes que o tipo anterior sera lido
	ldr	r3, [fp, #-52]			--r3=(fp-52)	r3 recebe FILE *mdb
	bl	fread				--ler bits do arquivo meta.dat utiliza [r0, r1, r2, r3]
	ldr	r3, [fp, #-60]			--r3=(fp-60) r3 recebe int i
	mov	r3, r3, asl #2			--r3=r3 shift left 2x	 int i * 4
	ldr	r2, [fp, #-32]			--r2=(fp-32)	r2 recebe char out[i]
	add	r3, r2, r3			--r3=r2+r3	r3 recebe endereço de char out[i+1]
	ldr	r1, [r3, #0]			--r1=(r3+0)	r1 recebe da memoria conteudo de char out[i+1]
	ldr	ip, [fp, #-36]			--ip=(fp-36) ip recebe mttype *mt
	ldr	r2, [fp, #-60]			--r2=(fp-60) r2 recebe int i
	mov	r0, #4				--r0=4
	mov	r3, r2				--r3=r2 r3 recebe int i
	mov	r3, r3, asl #1			--r3=r3 shift left 1x r3= r3 * 2
	add	r3, r3, r2			--r3=r3+r2	r3 = i*2 + i
	mov	r3, r3, asl #2			--r3=r3 shift left 2x	r3= i*3 *4
	add	r3, ip, r3			--r3=ip+r3	r3 recebe mttype *mt
	add	r3, r3, r0			--r3=r3+r0	r3 desloca para mt->dt
	str	r1, [r3, #0]			--(r3+0)=r1	grava o conteudo do char out[i+1] em r1 para mt->dt[0].sname
	ldr	r0, [fp, #-36]			--r0=(fp-36)	r0 recebe mttype *mt
	ldr	r2, [fp, #-60]			--r2=(fp-60)	r2 recebe int i
	mov	r1, #4				--r1=4
	mov	r3, r2				--r3=r2		r3 recebe int i do r2
	mov	r3, r3, asl #1		--r3=r3 shift left 1x	r3 = i*2
	add	r3, r3, r2			--r3=r3+r2	r3 = i*2 + i
	mov	r3, r3, asl #2		--r3=r3 shift left 2x	r3 = i*3*4
	add	r3, r0, r3			--r3=r0+r3	r3 = i*12 + endereço mttype *mt
	add	r3, r3, r1			--r3=r3+r1	r3 = mt + i*12 + 4
	ldr	r3, [r3, #0]			--r3=(r3+0)	r3 = *mt->dt[i]
	ldr	r0, .L28+20			--r0= .LC5	r0 = traz a word de .LC5 para r0
	mov	r1, r3				--r1=r3		traz o conteudo de *mt->dt[i].sname para r1
	bl	printf				--imprimir dados do meta.dat utilizando  r0 e r1
	ldr	r3, [fp, #-60]			--r3=(fp-60)	r3 carrega int i
	mov	r3, r3, asl #2			--r3=r3 shift left 2x	r3=i*4
	ldr	r2, [fp, #-32]			--r2=(fp-32)	r2= char **out
	add	r3, r2, r3			--r3=r2+r3	r3= i*4+ inicio de **out
	ldr	r2, [r3, #0]			--r2=(r3+0)	r2= endereço de mt->dt[i].sname
	ldr	r3, [fp, #-56]			--r3=(fp-56)	r3= int c
	add	r3, r2, r3			--r3=r2+r3	r3= desloca ate mt->dt[i].type
	mov	r0, r3				--r0=r3		grava o endereço de mt->dt[i].type em r0
	mov	r1, #1				--r1=1		r1= sizeof(char)
	mov	r2, #1				--r2=1		r2=quantidade de r1 s
	ldr	r3, [fp, #-52]			--r3=(fp-52)	r3= grava FILE *mdb
	bl	fread				--ler dados do meta.dat, atributos do fread ->	(r0, r1, r2, r3)
	ldr	r3, [fp, #-60]			--r3=(fp-60)	carrega int i
	mov	r3, r3, asl #2			--r3=r3 shift left 2x	i*4
	ldr	r2, [fp, #-32]			--r2=(fp-32)	carrega char **out
	add	r3, r2, r3			--r3=r2+r3	faz deslocamento de **out + i*4 ou out[i]
	ldr	r2, [r3, #0]			--r2=(r3+0)	carrega o conteudo calculado pela anterior
	ldr	r3, [fp, #-56]			--r3=(fp-56)	carrega o int c
	add	r3, r2, r3			--r3=r2+r3	calcula o deslocamento para out[i]+ c
	ldrb	r1, [r3, #0]	@ zero_extendqisi2		--r1 carrega out[i] + c
	ldr	r0, [fp, #-36]					--r0 carrega mttype *mt
	ldr	r2, [fp, #-60]					--r2 carrega int i
	mov	r3, r2				--r3 carrega i
	mov	r3, r3, asl #1		--r3=r3 shift left 1x i*2
	add	r3, r3, r2			--r3=r3+r2	i*3
	mov	r3, r3, asl #2		--r3=r3 shift left 2x	i*12
	add	r3, r0, r3			--r3=r0+r3	deslocamento de *mt +i*12
	mov	r2, r1				--r2=r1		move out[i]+c para r2
	strb	r2, [r3, #8]			-- grava na memoria  o conteúdo de out[i]+c no mt->dt[i].type
	ldr	r2, [fp, #-60]			--r2 carrega int i
	mov	r3, r2				--r3=r2		r3=i
	mov	r3, r3, asl #1		--r3=r3 shift left 1x	r3=i*2
	add	r3, r3, r2			--r3=r3+r2	r3=i*3
	mov	r3, r3, asl #2		--r3=r3 shift left 2x	r3=i*12
	ldr	r2, [fp, #-36]			--r2 carrega mttype *mt
	add	r3, r2, r3			--r3=r2+r3	mt + i*12
	add	r3, r3, #8			--r3=r3+8	mt+ i*12 + 8 ==mt->dt[i].type
	ldr	r0, .L28+24			--r0 carrega 'tipo: ' da word .LC6
	mov	r1, r3				--r1=r3		r1 carrega o char do type
	bl	printf				--r0 e r1	imprime 'Tipo: ' do r0+ o character do tipo que está no r1
	sub	r3, fp, #64			--r3=fp-64	r3 carrega endereço de int b
	mov	r0, r3				--r0=r3		r0=endereço de int b
	mov	r1, #4				--r1=4		r1=sizeof(int)
	mov	r2, #1				--r2=1		r2=quantidade de r1s
	ldr	r3, [fp, #-52]			--r3 carrega FILE *mdb
	bl	fread				--ler do arquivo meta.dat (r0, r1, r2, r3)
	ldr	r1, [fp, #-64]			--r1 carrega int b lido pelo fread
	ldr	ip, [fp, #-36]			--ip carrega mttype *mt
	ldr	r2, [fp, #-60]			--r2 carrega int i
	mov	r0, #12				--r0=12
	mov	r3, r2				--r3=r2		r3= int i
	mov	r3, r3, asl #1		--r3=r3 shift left 1x	r3=i*2
	add	r3, r3, r2			--r3=r3+r2	r3=i*3
	mov	r3, r3, asl #2		--r3=r3 shift left 2x	r3=i*12
	add	r3, ip, r3			--r3=ip+r3	r3=i*12+ inicio do mt
	add	r3, r3, r0			--r3=r3+r0	r3=inicio de mt + i*12 +12
	str	r1, [r3, #0]			--grava no mt->dt[i].length o int b do r1
	ldr	r0, [fp, #-36]			--r0 carrega mttype *mt
	ldr	r2, [fp, #-60]			--r2 carrega int i
	mov	r1, #12				--r1=12
	mov	r3, r2				--r3=r2		r3= int i
	mov	r3, r3, asl #1		--r3=r3 shift left 1x	r3= i*2
	add	r3, r3, r2			--r3=r3+r2	r3= i*3
	mov	r3, r3, asl #2		--r3=r3 shift left 2x	r3= i*12
	add	r3, r0, r3			--r3=r0+r3	r3= i*12 + inicio de mt
	add	r3, r3, r1			--r3=r3+r1	r3= i*12 + inicio de mt + 12
	ldr	r3, [r3, #0]			--r3 carrega mt->dt[i].length
	ldr	r0, .L28+28			--carrega a word .LC7
	mov	r1, r3				--r1=r3	  mt->dt[i].length
	bl	printf				--imprime Tamanho com r0 e o numero do tamanho com r1
	ldr	r3, [fp, #-60]			--r3 carrega int i
	add	r3, r3, #1			--r3=r3+1 i++
	str	r3, [fp, #-60]			--int i gravado na memoria
.L3:
	ldr	r3, [fp, #-68]			--r3=int a
	ldr	r2, [fp, #-60]			--r2=int i
	cmp	r2, r3				--if(i<a)
	blt	.L10				--se e menor pula para .L10, final do loop
	ldr	r0, [fp, #-52]			--r0=FILE *mdb
	bl	fclose				--fechar o FILE *mdb ou meta.dat com r0
	ldr	r0, [fp, #-40]			--r0 recebe
	ldr	r1, .L28+32
	bl	fopen				--abrir o data.dat
	str	r0, [fp, #-48]			--resultado fopen para (fp-48)
	ldr	r3, [fp, #-48]			--r3=db
	cmp	r3, #0				--if(r3==NULL)
	bne	.L11				--if not equal jump to L11
	ldr	r0, .L28+36			--se e igual avisa que nao foi possivel abrir o arquivo
	bl	printf
.L11:
	ldr	r0, [fp, #-48]			--carrega FILE *db
	bl	fclose				--fecha arquivo
	mov	r3, #0				--r3=0
	str	r3, [fp, #-60]			--int i =0
	b	.L12
.L13:
	ldr	r3, [fp, #-60]			--r3 carrega int i
	mov	r3, r3, asl #2			--r3= i*4
	ldr	r2, [fp, #-32]			--carrega char **out
	add	r3, r2, r3			--desvio para out[i]
	ldr	r3, [r3, #0]			--carrega out[i] para r3
	mov	r0, r3				--move para r0
	bl	free				-- libera memoria de r0
	ldr	r3, [fp, #-60]			-- carrega int i
	add	r3, r3, #1			--int i=i+1
	str	r3, [fp, #-60]			--int i guardado na memoria
.L12:
	ldr	r3, [fp, #-60]			--r3 = int i
	cmp	r3, #3				--i<=3
	ble	.L13				--if true jump to .l13
	ldr	r0, [fp, #-32]			--carrega char **out
	bl	free				--libera char **out
	ldr	r0, [fp, #-36]			--r0 carrega inicio de mttype *mt
	bl	free				--libera memoria de mt
	mov	r3, #0				--r3=0
	mov	r0, r3				--r0=r3		return 0
	sub	sp, fp, #8			--sp=fp-8
	ldmfd	sp!, {r4, fp, pc}		--retorna para sistema operacional para encerar execução
.L16:
	.align	2
.L15:
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.word	.LC3
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC8
	.word	.LC9
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 4.7.3-12ubuntu1) 4.7.3"
	.section	.note.GNU-stack,"",%progbits
