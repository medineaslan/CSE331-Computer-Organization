.data

	newLine: .asciiz "\n"
	whiteSpace : .asciiz " " 
	FileName: .asciiz "input.txt"
	MyFile : .space 1024 #Dosyadan okuduðum tüm karakterleri tutmak için
	UnionSet : .space 256 #Evrensel küme (X)
	AllSubSets : .space 1024 #Tüm alt kümeleri tutmak için
	NumberOfIntersect : .space 256
		
.text

	main:

		#Dosya açma
		li $v0, 13 
		la $a0, FileName
		li $a1, 0 #Reading için dosya açma
		syscall
		move $s0, $v0 
	
		#Dosya okuma
		li $v0, 14 
		move $a0, $s0 
		la $a1, MyFile #Input adresi
		la $a2, 512 
		syscall
			
		la $s0, MyFile	
		
		addi $t2, $zero, 1
		addi $t4, $zero, 1
		addi $t5, $zero, 0
		addi $t6, $zero, 0
		addi $t7, $zero, 0
		addi $t8, $zero, 0
		addi $s5, $zero, 0
		addi $t9, $zero, 0
		addi $s7, $zero, 1
		addi $s3, $zero, 0
		addi $s4, $zero, 0
		
		ParseMyFile :
			lb $t0, 0($s0)		
			add $s0, $s0 , 1	#Adresi arttýrma
			beq $t0, '(', InitUnionSet #Union Set baþlangýcý
			beq $t0, '{', InitAllSubSets #Tüm alt kümeleri barýndýrýr.
			beq $t0, '.', CalculateCommonElement
		
			j ParseMyFile
	
		InitUnionSet: #Ýlk satýrda evrensel kümeyi ifade eder ve oradaki karakterler UnionSet içerisine atýlýr.
			lb $t0, 0($s0)
			add $s0, $s0 , 1
			beq $t0, ')', printNewline	
			sb $t0 , UnionSet($t7)
			lb $a0, UnionSet($t7)
			addi $t7, $t7, 1
			
			li $v0, 11
			syscall
			
			j InitUnionSet
			
		InitAllSubSets: #Evrensel küme dýþýndaki kümelerin AllSubSets içerisine atamasý yapýlýr.
		
			lb $t1, 0($s0)
			add $s0, $s0, 1
			beq $t1, '}', printNewline
			sb $t1, AllSubSets($t8) 
			lb $a0, AllSubSets($t8)
			addi $t8, $t8, 1
			
			li $v0, 11
			syscall
			
			j InitAllSubSets
			
		CalculateCommonElement: #Sets have the number of elements that intersect with the union set.
			
			lb $t3, AllSubSets($t5)
			add $t5, $t5, 1
			
			beq $t3, ',', increaseCount
			beq $t3, '*', NewSet
			beq $t3, '.', LastSet
			
			bgt $t4, $t2, CalculateMax #max intersection number is checked

			j CalculateCommonElement
		
		increaseCount: #Count is increased when common element is found.
		
			addi $t4, $t4, 1
			
			j CalculateCommonElement
			
		NewSet:
		
			addi $s7, $s7, 1 #Keeps the number of sets.
			
			sb $t4, NumberOfIntersect($t6)
			
			add $t6, $t6, 1

			addi $t4, $zero, 1
			
			j CalculateCommonElement
			
		LastSet:
	
			sb $t4, NumberOfIntersect($t6) #The number of intersections for the last set is also considered.
			add $t6, $t6, 1
			
			lb $t9, NumberOfIntersect($s5)
			add $s5, $s5, 1
			
			li $v0, 1 #Printing number of intersects.
			add $a0, $zero, $t9
			syscall 
			
			li $v0, 4
			la $a0, whiteSpace
			syscall

			beq $s5, $s7, myEndLoop
			
			j LastSet
		
		CalculateMax: #Kesiþim sayýsý en fazla olan kümeyi bulur.
			
			addi $t2, $t4, 0
			add $s4, $zero, $s7
			
			j CalculateCommonElement
			
		printNewline: #Printing newline.
			li $v0, 4
			la $a0, newLine
			syscall
			
			j ParseMyFile
		
		myEndLoop:
						
			li $v0, 4
			la $a0, newLine
			syscall
			
			li $v0, 1 #En fazla ortak elemanýn bulunduðu kümenin kaçýncý küme olduðunu bastýrýr.
			add $a0, $zero, $s4
			syscall
	
			li $v0, 10	#Ending program
			syscall
			
			
