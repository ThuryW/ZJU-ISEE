#测试用的指令流中需要包含的指令包括SLLI、SRLI、SRAI、ADD、SUB、SLL、SLT、SLTU、XOR、SRL、SRA、OR、AND、ADDI、SLTI、SLTIU、XORI、ORI、ANDI、LUI、AUIPC

## addi add sub ## 
addi:
    addi x10, x0, 1   # x10=1
add:
    add x11, x10, x10 # x11=2
sub:
    sub x12, x0, x11  # x12=-2

## and andi or ori xor xori ##
and:
    and x13, x10, x10 # 1&1=1 x13=1
    and x13, x10, x0  # 1&0=0 x13=0
    and x13, x0, x10  # 0&1=0 x13=0
    and x13, x0, x0   # 0&0=0 x13=0
andi:
    andi x13, x10, 1  # 1&1=1 x13=1
or:
    or x14, x10, x10  # 1+1=1 x14=1
    or x14, x10, x0   # 1+0=1 x14=1
    or x14, x0, x10   # 0+1=1 x14=1
    or x14, x0, x0    # 0+0=0 x14=0
ori:
    ori x14, x0, 1    # 0+1=1 x14=1
xor:
    xor x15, x10, x10 # 1^1=0 x15=0
    xor x15, x10, x0  # 1^0=1 x15=1
    xor x15, x0, x10  # 0^1=1 x15=1
    xor x15, x0, x0   # 0^0=0 x15=0
xori:
    xori x15, x10, 0  # 1^0=1 x15=1

## LUI AUIPC ##
lui:
    lui x16, 8   # x16=8*2^12=32768
auipc:
    auipc x17, 8 # x17=32768+PC

## SLL SLLI SRL SRLI SRA SRAI##
slli:
    slli x18, x10, 2  # x18=1*4=4
sll:
    sll x18, x10, x18 # x18=1*16=16
srli:
    srli x18, x18, 1  # x18=16/2=8
srl:
    srl x18, x18, x10 # x18=8/2=4
srai:
    srai x18, x12, 1  # x18=-2/2=-1
sra:
    sra x18, x12, x10 # x18=-2/2=-1

## SLT SLTU SLTI SLTIU ##
slt:
    slt x19, x0, x10   #  0<1  x19=1
    slt x19, x18, x12  # -1>-2 x19=0
    slt x19, x18, x0   # -1<0  x19=1
    slt x19, x10, x12  #  1>-2 x19=0
slti:
    slti x19, x0, 2    # 0<2  x19=1
sltu:
    sltu x19, x18, x12 # x19=1
sltiu:
    sltiu x19, x18, 0  # x19=0






