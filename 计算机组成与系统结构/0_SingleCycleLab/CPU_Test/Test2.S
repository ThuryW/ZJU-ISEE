#测试用的指令流中需要包含的指令包括JALR、LB、LH、LW、LBU、LHU、SB、SH、SW、BEQ、BNE、BLT、BLTU、BGE、BGEU、JAL

## BEQ BNE BLT BLTU BGE BGEU ##
### 如果指令不正确则会令x3=1 ###
beq_test:
    addi x10, x0, 1  # x10=1
    add x11, x10, x0 # x11=1
    beq x11, x10, bne_test
    addi x3, x0, 1

bne_test:
    bne x11, x0, blt_test
    addi x3, x0, 1

blt_test:
    blt x0, x11, bge_test1
    addi x3, x0, 1

bge_test1:
    bge x11, x10, bge_test2 
    addi x3, x0, 1

bge_test2:
    bge x11, x0, bltu_test
    addi x3, x0, 1

bltu_test:
    addi x11, x0, -1 # x11=-1
    bltu x0, x11, bgeu_test
    addi x3, x0, 1

bgeu_test:
    bgeu x11, x10, jal_test
    addi x3, x0, 1

## JAL JALR ##
### 如果指令不正确则会令x3=1 ###
jal_test:
    jal x12, jalr_test
    addi x3, x0, 1

jalr_test:
    jalr x13, x12, 12
    addi x3, x0, 1   
    addi x11, x0, -2 # x11=-2 如果jalr指令执行正确则会跳转执行这一条

## SB SH SW LB LH LW LBU LHU ##
sw:
    auipc ra, 0
    sw x11, 0(ra)   # 将-2存入0(ra)
sh:
    sh x11, 6(ra)   # 将-2存入6(ra)
sb:
    sb x11, 10(ra)  # 将-2存入10(ra)
lw:
    lw x14, 0(ra)   # 有符号load x14=-2
lh:
    lh x15, 6(ra)   # 有符号load x15=-2
lhu:
    lhu x15, 6(ra)  # 无符号load 16bit表示的-2，x15=2^16-2=65534
lb:
    lb x16, 10(ra)  # 有符号load x16=-2
lbu:
    lbu x16, 10(ra) # 无符号load 8bit表示的-2，x16=256-2=254
