`timescale 1ns/100ps
//correct read result:
//000000a3000000d20000000c000000b7000000f10000007e0000009f0000002700000007000000b40000007c00000033000000550000007e0000005d00000046000000540000002a0000009f000000b6000000fc00000005000000c7000000a0000000500000008e000000720000006b0000003700000096000000dc0000001b000000150000007100000034000000cb0000004d000000f8000000dc0000005900000058000000d4000000be000000c000000088000000da00000044000000b800000031000000e7000000d0000000380000002d000000cb00000051000000ca0000009c0000007c000000ce0000004400000090000000870000006e00000087

module cache_tb();

`define DATA_COUNT (64)
`define RDWR_COUNT (6*`DATA_COUNT)

reg wr_cycle           [`RDWR_COUNT];
reg rd_cycle           [`RDWR_COUNT];
reg [31:0] addr_rom    [`RDWR_COUNT];
reg [31:0] wr_data_rom [`RDWR_COUNT];
reg [31:0] validation_data [`DATA_COUNT];

initial begin
    // 64 sequence write cycles
    rd_cycle[    0] = 1'b0;  wr_cycle[    0] = 1'b1;  addr_rom[    0]='h00000000;  wr_data_rom[    0]='h0000007d;
    rd_cycle[    1] = 1'b0;  wr_cycle[    1] = 1'b1;  addr_rom[    1]='h00000004;  wr_data_rom[    1]='h000000b0;
    rd_cycle[    2] = 1'b0;  wr_cycle[    2] = 1'b1;  addr_rom[    2]='h00000008;  wr_data_rom[    2]='h00000053;
    rd_cycle[    3] = 1'b0;  wr_cycle[    3] = 1'b1;  addr_rom[    3]='h0000000c;  wr_data_rom[    3]='h000000cc;
    rd_cycle[    4] = 1'b0;  wr_cycle[    4] = 1'b1;  addr_rom[    4]='h00000010;  wr_data_rom[    4]='h000000c9;
    rd_cycle[    5] = 1'b0;  wr_cycle[    5] = 1'b1;  addr_rom[    5]='h00000014;  wr_data_rom[    5]='h0000002e;
    rd_cycle[    6] = 1'b0;  wr_cycle[    6] = 1'b1;  addr_rom[    6]='h00000018;  wr_data_rom[    6]='h000000f4;
    rd_cycle[    7] = 1'b0;  wr_cycle[    7] = 1'b1;  addr_rom[    7]='h0000001c;  wr_data_rom[    7]='h000000b3;
    rd_cycle[    8] = 1'b0;  wr_cycle[    8] = 1'b1;  addr_rom[    8]='h00000020;  wr_data_rom[    8]='h000000d8;
    rd_cycle[    9] = 1'b0;  wr_cycle[    9] = 1'b1;  addr_rom[    9]='h00000024;  wr_data_rom[    9]='h000000b4;
    rd_cycle[   10] = 1'b0;  wr_cycle[   10] = 1'b1;  addr_rom[   10]='h00000028;  wr_data_rom[   10]='h000000c3;
    rd_cycle[   11] = 1'b0;  wr_cycle[   11] = 1'b1;  addr_rom[   11]='h0000002c;  wr_data_rom[   11]='h000000ce;
    rd_cycle[   12] = 1'b0;  wr_cycle[   12] = 1'b1;  addr_rom[   12]='h00000030;  wr_data_rom[   12]='h00000055;
    rd_cycle[   13] = 1'b0;  wr_cycle[   13] = 1'b1;  addr_rom[   13]='h00000034;  wr_data_rom[   13]='h0000000b;
    rd_cycle[   14] = 1'b0;  wr_cycle[   14] = 1'b1;  addr_rom[   14]='h00000038;  wr_data_rom[   14]='h00000058;
    rd_cycle[   15] = 1'b0;  wr_cycle[   15] = 1'b1;  addr_rom[   15]='h0000003c;  wr_data_rom[   15]='h00000093;
    rd_cycle[   16] = 1'b0;  wr_cycle[   16] = 1'b1;  addr_rom[   16]='h00000040;  wr_data_rom[   16]='h0000000c;
    rd_cycle[   17] = 1'b0;  wr_cycle[   17] = 1'b1;  addr_rom[   17]='h00000044;  wr_data_rom[   17]='h000000d5;
    rd_cycle[   18] = 1'b0;  wr_cycle[   18] = 1'b1;  addr_rom[   18]='h00000048;  wr_data_rom[   18]='h0000006a;
    rd_cycle[   19] = 1'b0;  wr_cycle[   19] = 1'b1;  addr_rom[   19]='h0000004c;  wr_data_rom[   19]='h000000b6;
    rd_cycle[   20] = 1'b0;  wr_cycle[   20] = 1'b1;  addr_rom[   20]='h00000050;  wr_data_rom[   20]='h00000028;
    rd_cycle[   21] = 1'b0;  wr_cycle[   21] = 1'b1;  addr_rom[   21]='h00000054;  wr_data_rom[   21]='h0000009f;
    rd_cycle[   22] = 1'b0;  wr_cycle[   22] = 1'b1;  addr_rom[   22]='h00000058;  wr_data_rom[   22]='h000000d1;
    rd_cycle[   23] = 1'b0;  wr_cycle[   23] = 1'b1;  addr_rom[   23]='h0000005c;  wr_data_rom[   23]='h00000052;
    rd_cycle[   24] = 1'b0;  wr_cycle[   24] = 1'b1;  addr_rom[   24]='h00000060;  wr_data_rom[   24]='h00000050;
    rd_cycle[   25] = 1'b0;  wr_cycle[   25] = 1'b1;  addr_rom[   25]='h00000064;  wr_data_rom[   25]='h00000049;
    rd_cycle[   26] = 1'b0;  wr_cycle[   26] = 1'b1;  addr_rom[   26]='h00000068;  wr_data_rom[   26]='h00000090;
    rd_cycle[   27] = 1'b0;  wr_cycle[   27] = 1'b1;  addr_rom[   27]='h0000006c;  wr_data_rom[   27]='h000000f6;
    rd_cycle[   28] = 1'b0;  wr_cycle[   28] = 1'b1;  addr_rom[   28]='h00000070;  wr_data_rom[   28]='h00000092;
    rd_cycle[   29] = 1'b0;  wr_cycle[   29] = 1'b1;  addr_rom[   29]='h00000074;  wr_data_rom[   29]='h000000ec;
    rd_cycle[   30] = 1'b0;  wr_cycle[   30] = 1'b1;  addr_rom[   30]='h00000078;  wr_data_rom[   30]='h00000097;
    rd_cycle[   31] = 1'b0;  wr_cycle[   31] = 1'b1;  addr_rom[   31]='h0000007c;  wr_data_rom[   31]='h00000100;
    rd_cycle[   32] = 1'b0;  wr_cycle[   32] = 1'b1;  addr_rom[   32]='h00000080;  wr_data_rom[   32]='h00000054;
    rd_cycle[   33] = 1'b0;  wr_cycle[   33] = 1'b1;  addr_rom[   33]='h00000084;  wr_data_rom[   33]='h00000085;
    rd_cycle[   34] = 1'b0;  wr_cycle[   34] = 1'b1;  addr_rom[   34]='h00000088;  wr_data_rom[   34]='h000000ec;
    rd_cycle[   35] = 1'b0;  wr_cycle[   35] = 1'b1;  addr_rom[   35]='h0000008c;  wr_data_rom[   35]='h0000002b;
    rd_cycle[   36] = 1'b0;  wr_cycle[   36] = 1'b1;  addr_rom[   36]='h00000090;  wr_data_rom[   36]='h000000ae;
    rd_cycle[   37] = 1'b0;  wr_cycle[   37] = 1'b1;  addr_rom[   37]='h00000094;  wr_data_rom[   37]='h000000d0;
    rd_cycle[   38] = 1'b0;  wr_cycle[   38] = 1'b1;  addr_rom[   38]='h00000098;  wr_data_rom[   38]='h000000b0;
    rd_cycle[   39] = 1'b0;  wr_cycle[   39] = 1'b1;  addr_rom[   39]='h0000009c;  wr_data_rom[   39]='h00000081;
    rd_cycle[   40] = 1'b0;  wr_cycle[   40] = 1'b1;  addr_rom[   40]='h000000a0;  wr_data_rom[   40]='h0000002e;
    rd_cycle[   41] = 1'b0;  wr_cycle[   41] = 1'b1;  addr_rom[   41]='h000000a4;  wr_data_rom[   41]='h000000d4;
    rd_cycle[   42] = 1'b0;  wr_cycle[   42] = 1'b1;  addr_rom[   42]='h000000a8;  wr_data_rom[   42]='h000000be;
    rd_cycle[   43] = 1'b0;  wr_cycle[   43] = 1'b1;  addr_rom[   43]='h000000ac;  wr_data_rom[   43]='h000000d8;
    rd_cycle[   44] = 1'b0;  wr_cycle[   44] = 1'b1;  addr_rom[   44]='h000000b0;  wr_data_rom[   44]='h00000054;
    rd_cycle[   45] = 1'b0;  wr_cycle[   45] = 1'b1;  addr_rom[   45]='h000000b4;  wr_data_rom[   45]='h00000029;
    rd_cycle[   46] = 1'b0;  wr_cycle[   46] = 1'b1;  addr_rom[   46]='h000000b8;  wr_data_rom[   46]='h00000044;
    rd_cycle[   47] = 1'b0;  wr_cycle[   47] = 1'b1;  addr_rom[   47]='h000000bc;  wr_data_rom[   47]='h000000c1;
    rd_cycle[   48] = 1'b0;  wr_cycle[   48] = 1'b1;  addr_rom[   48]='h000000c0;  wr_data_rom[   48]='h00000089;
    rd_cycle[   49] = 1'b0;  wr_cycle[   49] = 1'b1;  addr_rom[   49]='h000000c4;  wr_data_rom[   49]='h000000d5;
    rd_cycle[   50] = 1'b0;  wr_cycle[   50] = 1'b1;  addr_rom[   50]='h000000c8;  wr_data_rom[   50]='h000000b9;
    rd_cycle[   51] = 1'b0;  wr_cycle[   51] = 1'b1;  addr_rom[   51]='h000000cc;  wr_data_rom[   51]='h0000007c;
    rd_cycle[   52] = 1'b0;  wr_cycle[   52] = 1'b1;  addr_rom[   52]='h000000d0;  wr_data_rom[   52]='h000000a0;
    rd_cycle[   53] = 1'b0;  wr_cycle[   53] = 1'b1;  addr_rom[   53]='h000000d4;  wr_data_rom[   53]='h000000cb;
    rd_cycle[   54] = 1'b0;  wr_cycle[   54] = 1'b1;  addr_rom[   54]='h000000d8;  wr_data_rom[   54]='h00000054;
    rd_cycle[   55] = 1'b0;  wr_cycle[   55] = 1'b1;  addr_rom[   55]='h000000dc;  wr_data_rom[   55]='h0000008e;
    rd_cycle[   56] = 1'b0;  wr_cycle[   56] = 1'b1;  addr_rom[   56]='h000000e0;  wr_data_rom[   56]='h00000082;
    rd_cycle[   57] = 1'b0;  wr_cycle[   57] = 1'b1;  addr_rom[   57]='h000000e4;  wr_data_rom[   57]='h00000052;
    rd_cycle[   58] = 1'b0;  wr_cycle[   58] = 1'b1;  addr_rom[   58]='h000000e8;  wr_data_rom[   58]='h00000076;
    rd_cycle[   59] = 1'b0;  wr_cycle[   59] = 1'b1;  addr_rom[   59]='h000000ec;  wr_data_rom[   59]='h00000052;
    rd_cycle[   60] = 1'b0;  wr_cycle[   60] = 1'b1;  addr_rom[   60]='h000000f0;  wr_data_rom[   60]='h00000090;
    rd_cycle[   61] = 1'b0;  wr_cycle[   61] = 1'b1;  addr_rom[   61]='h000000f4;  wr_data_rom[   61]='h0000000e;
    rd_cycle[   62] = 1'b0;  wr_cycle[   62] = 1'b1;  addr_rom[   62]='h000000f8;  wr_data_rom[   62]='h00000096;
    rd_cycle[   63] = 1'b0;  wr_cycle[   63] = 1'b1;  addr_rom[   63]='h000000fc;  wr_data_rom[   63]='h00000096;
    // 192 random read and write cycles
    rd_cycle[   64] = 1'b0;  wr_cycle[   64] = 1'b1;  addr_rom[   64]='h000000ec;  wr_data_rom[   64]='h0000008c;
    rd_cycle[   65] = 1'b0;  wr_cycle[   65] = 1'b1;  addr_rom[   65]='h00000038;  wr_data_rom[   65]='h000000f1;
    rd_cycle[   66] = 1'b1;  wr_cycle[   66] = 1'b0;  addr_rom[   66]='h000000c4;  wr_data_rom[   66]='h00000000;
    rd_cycle[   67] = 1'b0;  wr_cycle[   67] = 1'b1;  addr_rom[   67]='h00000070;  wr_data_rom[   67]='h00000037;
    rd_cycle[   68] = 1'b1;  wr_cycle[   68] = 1'b0;  addr_rom[   68]='h00000010;  wr_data_rom[   68]='h00000000;
    rd_cycle[   69] = 1'b0;  wr_cycle[   69] = 1'b1;  addr_rom[   69]='h0000002c;  wr_data_rom[   69]='h000000f0;
    rd_cycle[   70] = 1'b1;  wr_cycle[   70] = 1'b0;  addr_rom[   70]='h0000001c;  wr_data_rom[   70]='h00000000;
    rd_cycle[   71] = 1'b1;  wr_cycle[   71] = 1'b0;  addr_rom[   71]='h000000f0;  wr_data_rom[   71]='h00000000;
    rd_cycle[   72] = 1'b0;  wr_cycle[   72] = 1'b1;  addr_rom[   72]='h00000004;  wr_data_rom[   72]='h000000d2;
    rd_cycle[   73] = 1'b1;  wr_cycle[   73] = 1'b0;  addr_rom[   73]='h00000064;  wr_data_rom[   73]='h00000000;
    rd_cycle[   74] = 1'b0;  wr_cycle[   74] = 1'b1;  addr_rom[   74]='h000000a0;  wr_data_rom[   74]='h00000058;
    rd_cycle[   75] = 1'b1;  wr_cycle[   75] = 1'b0;  addr_rom[   75]='h00000018;  wr_data_rom[   75]='h00000000;
    rd_cycle[   76] = 1'b1;  wr_cycle[   76] = 1'b0;  addr_rom[   76]='h00000028;  wr_data_rom[   76]='h00000000;
    rd_cycle[   77] = 1'b0;  wr_cycle[   77] = 1'b1;  addr_rom[   77]='h000000e8;  wr_data_rom[   77]='h00000036;
    rd_cycle[   78] = 1'b0;  wr_cycle[   78] = 1'b1;  addr_rom[   78]='h00000074;  wr_data_rom[   78]='h0000000d;
    rd_cycle[   79] = 1'b0;  wr_cycle[   79] = 1'b1;  addr_rom[   79]='h00000084;  wr_data_rom[   79]='h000000a3;
    rd_cycle[   80] = 1'b1;  wr_cycle[   80] = 1'b0;  addr_rom[   80]='h00000080;  wr_data_rom[   80]='h00000000;
    rd_cycle[   81] = 1'b0;  wr_cycle[   81] = 1'b1;  addr_rom[   81]='h0000007c;  wr_data_rom[   81]='h0000001b;
    rd_cycle[   82] = 1'b0;  wr_cycle[   82] = 1'b1;  addr_rom[   82]='h0000002c;  wr_data_rom[   82]='h00000033;
    rd_cycle[   83] = 1'b0;  wr_cycle[   83] = 1'b1;  addr_rom[   83]='h000000e0;  wr_data_rom[   83]='h0000009c;
    rd_cycle[   84] = 1'b1;  wr_cycle[   84] = 1'b0;  addr_rom[   84]='h00000044;  wr_data_rom[   84]='h00000000;
    rd_cycle[   85] = 1'b0;  wr_cycle[   85] = 1'b1;  addr_rom[   85]='h000000d0;  wr_data_rom[   85]='h0000002d;
    rd_cycle[   86] = 1'b1;  wr_cycle[   86] = 1'b0;  addr_rom[   86]='h000000c4;  wr_data_rom[   86]='h00000000;
    rd_cycle[   87] = 1'b0;  wr_cycle[   87] = 1'b1;  addr_rom[   87]='h0000006c;  wr_data_rom[   87]='h000000f3;
    rd_cycle[   88] = 1'b1;  wr_cycle[   88] = 1'b0;  addr_rom[   88]='h0000006c;  wr_data_rom[   88]='h00000000;
    rd_cycle[   89] = 1'b0;  wr_cycle[   89] = 1'b1;  addr_rom[   89]='h000000b0;  wr_data_rom[   89]='h00000037;
    rd_cycle[   90] = 1'b1;  wr_cycle[   90] = 1'b0;  addr_rom[   90]='h0000001c;  wr_data_rom[   90]='h00000000;
    rd_cycle[   91] = 1'b1;  wr_cycle[   91] = 1'b0;  addr_rom[   91]='h0000009c;  wr_data_rom[   91]='h00000000;
    rd_cycle[   92] = 1'b0;  wr_cycle[   92] = 1'b1;  addr_rom[   92]='h0000001c;  wr_data_rom[   92]='h000000fc;
    rd_cycle[   93] = 1'b1;  wr_cycle[   93] = 1'b0;  addr_rom[   93]='h00000044;  wr_data_rom[   93]='h00000000;
    rd_cycle[   94] = 1'b0;  wr_cycle[   94] = 1'b1;  addr_rom[   94]='h0000009c;  wr_data_rom[   94]='h000000d1;
    rd_cycle[   95] = 1'b0;  wr_cycle[   95] = 1'b1;  addr_rom[   95]='h0000005c;  wr_data_rom[   95]='h000000be;
    rd_cycle[   96] = 1'b0;  wr_cycle[   96] = 1'b1;  addr_rom[   96]='h000000b0;  wr_data_rom[   96]='h000000bf;
    rd_cycle[   97] = 1'b1;  wr_cycle[   97] = 1'b0;  addr_rom[   97]='h00000018;  wr_data_rom[   97]='h00000000;
    rd_cycle[   98] = 1'b0;  wr_cycle[   98] = 1'b1;  addr_rom[   98]='h00000034;  wr_data_rom[   98]='h0000007e;
    rd_cycle[   99] = 1'b1;  wr_cycle[   99] = 1'b0;  addr_rom[   99]='h00000090;  wr_data_rom[   99]='h00000000;
    rd_cycle[  100] = 1'b0;  wr_cycle[  100] = 1'b1;  addr_rom[  100]='h0000000c;  wr_data_rom[  100]='h00000090;
    rd_cycle[  101] = 1'b1;  wr_cycle[  101] = 1'b0;  addr_rom[  101]='h000000ec;  wr_data_rom[  101]='h00000000;
    rd_cycle[  102] = 1'b1;  wr_cycle[  102] = 1'b0;  addr_rom[  102]='h00000014;  wr_data_rom[  102]='h00000000;
    rd_cycle[  103] = 1'b0;  wr_cycle[  103] = 1'b1;  addr_rom[  103]='h0000005c;  wr_data_rom[  103]='h000000a0;
    rd_cycle[  104] = 1'b0;  wr_cycle[  104] = 1'b1;  addr_rom[  104]='h0000009c;  wr_data_rom[  104]='h00000017;
    rd_cycle[  105] = 1'b0;  wr_cycle[  105] = 1'b1;  addr_rom[  105]='h0000009c;  wr_data_rom[  105]='h00000059;
    rd_cycle[  106] = 1'b0;  wr_cycle[  106] = 1'b1;  addr_rom[  106]='h000000e8;  wr_data_rom[  106]='h000000f0;
    rd_cycle[  107] = 1'b0;  wr_cycle[  107] = 1'b1;  addr_rom[  107]='h00000044;  wr_data_rom[  107]='h00000015;
    rd_cycle[  108] = 1'b1;  wr_cycle[  108] = 1'b0;  addr_rom[  108]='h00000098;  wr_data_rom[  108]='h00000000;
    rd_cycle[  109] = 1'b0;  wr_cycle[  109] = 1'b1;  addr_rom[  109]='h00000058;  wr_data_rom[  109]='h000000c7;
    rd_cycle[  110] = 1'b1;  wr_cycle[  110] = 1'b0;  addr_rom[  110]='h000000b8;  wr_data_rom[  110]='h00000000;
    rd_cycle[  111] = 1'b0;  wr_cycle[  111] = 1'b1;  addr_rom[  111]='h00000068;  wr_data_rom[  111]='h00000029;
    rd_cycle[  112] = 1'b1;  wr_cycle[  112] = 1'b0;  addr_rom[  112]='h000000c4;  wr_data_rom[  112]='h00000000;
    rd_cycle[  113] = 1'b0;  wr_cycle[  113] = 1'b1;  addr_rom[  113]='h00000018;  wr_data_rom[  113]='h000000b6;
    rd_cycle[  114] = 1'b1;  wr_cycle[  114] = 1'b0;  addr_rom[  114]='h000000c4;  wr_data_rom[  114]='h00000000;
    rd_cycle[  115] = 1'b1;  wr_cycle[  115] = 1'b0;  addr_rom[  115]='h000000a4;  wr_data_rom[  115]='h00000000;
    rd_cycle[  116] = 1'b0;  wr_cycle[  116] = 1'b1;  addr_rom[  116]='h000000f8;  wr_data_rom[  116]='h0000006e;
    rd_cycle[  117] = 1'b1;  wr_cycle[  117] = 1'b0;  addr_rom[  117]='h0000002c;  wr_data_rom[  117]='h00000000;
    rd_cycle[  118] = 1'b1;  wr_cycle[  118] = 1'b0;  addr_rom[  118]='h00000018;  wr_data_rom[  118]='h00000000;
    rd_cycle[  119] = 1'b0;  wr_cycle[  119] = 1'b1;  addr_rom[  119]='h000000b0;  wr_data_rom[  119]='h00000057;
    rd_cycle[  120] = 1'b1;  wr_cycle[  120] = 1'b0;  addr_rom[  120]='h000000ac;  wr_data_rom[  120]='h00000000;
    rd_cycle[  121] = 1'b0;  wr_cycle[  121] = 1'b1;  addr_rom[  121]='h00000000;  wr_data_rom[  121]='h0000001f;
    rd_cycle[  122] = 1'b1;  wr_cycle[  122] = 1'b0;  addr_rom[  122]='h00000018;  wr_data_rom[  122]='h00000000;
    rd_cycle[  123] = 1'b0;  wr_cycle[  123] = 1'b1;  addr_rom[  123]='h00000044;  wr_data_rom[  123]='h000000fe;
    rd_cycle[  124] = 1'b0;  wr_cycle[  124] = 1'b1;  addr_rom[  124]='h000000fc;  wr_data_rom[  124]='h00000087;
    rd_cycle[  125] = 1'b0;  wr_cycle[  125] = 1'b1;  addr_rom[  125]='h00000094;  wr_data_rom[  125]='h00000053;
    rd_cycle[  126] = 1'b0;  wr_cycle[  126] = 1'b1;  addr_rom[  126]='h0000003c;  wr_data_rom[  126]='h00000097;
    rd_cycle[  127] = 1'b1;  wr_cycle[  127] = 1'b0;  addr_rom[  127]='h00000044;  wr_data_rom[  127]='h00000000;
    rd_cycle[  128] = 1'b0;  wr_cycle[  128] = 1'b1;  addr_rom[  128]='h00000000;  wr_data_rom[  128]='h000000a3;
    rd_cycle[  129] = 1'b1;  wr_cycle[  129] = 1'b0;  addr_rom[  129]='h00000064;  wr_data_rom[  129]='h00000000;
    rd_cycle[  130] = 1'b0;  wr_cycle[  130] = 1'b1;  addr_rom[  130]='h000000ac;  wr_data_rom[  130]='h000000c0;
    rd_cycle[  131] = 1'b1;  wr_cycle[  131] = 1'b0;  addr_rom[  131]='h000000a8;  wr_data_rom[  131]='h00000000;
    rd_cycle[  132] = 1'b1;  wr_cycle[  132] = 1'b0;  addr_rom[  132]='h00000088;  wr_data_rom[  132]='h00000000;
    rd_cycle[  133] = 1'b0;  wr_cycle[  133] = 1'b1;  addr_rom[  133]='h00000010;  wr_data_rom[  133]='h000000b4;
    rd_cycle[  134] = 1'b0;  wr_cycle[  134] = 1'b1;  addr_rom[  134]='h000000e8;  wr_data_rom[  134]='h000000ce;
    rd_cycle[  135] = 1'b0;  wr_cycle[  135] = 1'b1;  addr_rom[  135]='h000000e4;  wr_data_rom[  135]='h0000007c;
    rd_cycle[  136] = 1'b0;  wr_cycle[  136] = 1'b1;  addr_rom[  136]='h00000078;  wr_data_rom[  136]='h000000dc;
    rd_cycle[  137] = 1'b1;  wr_cycle[  137] = 1'b0;  addr_rom[  137]='h000000d8;  wr_data_rom[  137]='h00000000;
    rd_cycle[  138] = 1'b0;  wr_cycle[  138] = 1'b1;  addr_rom[  138]='h00000088;  wr_data_rom[  138]='h000000e0;
    rd_cycle[  139] = 1'b1;  wr_cycle[  139] = 1'b0;  addr_rom[  139]='h000000ec;  wr_data_rom[  139]='h00000000;
    rd_cycle[  140] = 1'b1;  wr_cycle[  140] = 1'b0;  addr_rom[  140]='h00000070;  wr_data_rom[  140]='h00000000;
    rd_cycle[  141] = 1'b1;  wr_cycle[  141] = 1'b0;  addr_rom[  141]='h0000003c;  wr_data_rom[  141]='h00000000;
    rd_cycle[  142] = 1'b1;  wr_cycle[  142] = 1'b0;  addr_rom[  142]='h00000030;  wr_data_rom[  142]='h00000000;
    rd_cycle[  143] = 1'b0;  wr_cycle[  143] = 1'b1;  addr_rom[  143]='h000000ec;  wr_data_rom[  143]='h0000009e;
    rd_cycle[  144] = 1'b0;  wr_cycle[  144] = 1'b1;  addr_rom[  144]='h00000018;  wr_data_rom[  144]='h0000009f;
    rd_cycle[  145] = 1'b1;  wr_cycle[  145] = 1'b0;  addr_rom[  145]='h000000bc;  wr_data_rom[  145]='h00000000;
    rd_cycle[  146] = 1'b1;  wr_cycle[  146] = 1'b0;  addr_rom[  146]='h00000010;  wr_data_rom[  146]='h00000000;
    rd_cycle[  147] = 1'b0;  wr_cycle[  147] = 1'b1;  addr_rom[  147]='h00000010;  wr_data_rom[  147]='h00000013;
    rd_cycle[  148] = 1'b0;  wr_cycle[  148] = 1'b1;  addr_rom[  148]='h00000084;  wr_data_rom[  148]='h0000003c;
    rd_cycle[  149] = 1'b0;  wr_cycle[  149] = 1'b1;  addr_rom[  149]='h00000080;  wr_data_rom[  149]='h00000015;
    rd_cycle[  150] = 1'b1;  wr_cycle[  150] = 1'b0;  addr_rom[  150]='h000000c0;  wr_data_rom[  150]='h00000000;
    rd_cycle[  151] = 1'b0;  wr_cycle[  151] = 1'b1;  addr_rom[  151]='h00000048;  wr_data_rom[  151]='h00000059;
    rd_cycle[  152] = 1'b0;  wr_cycle[  152] = 1'b1;  addr_rom[  152]='h00000008;  wr_data_rom[  152]='h00000070;
    rd_cycle[  153] = 1'b1;  wr_cycle[  153] = 1'b0;  addr_rom[  153]='h000000b8;  wr_data_rom[  153]='h00000000;
    rd_cycle[  154] = 1'b0;  wr_cycle[  154] = 1'b1;  addr_rom[  154]='h0000006c;  wr_data_rom[  154]='h0000006b;
    rd_cycle[  155] = 1'b1;  wr_cycle[  155] = 1'b0;  addr_rom[  155]='h000000d0;  wr_data_rom[  155]='h00000000;
    rd_cycle[  156] = 1'b1;  wr_cycle[  156] = 1'b0;  addr_rom[  156]='h0000002c;  wr_data_rom[  156]='h00000000;
    rd_cycle[  157] = 1'b0;  wr_cycle[  157] = 1'b1;  addr_rom[  157]='h00000064;  wr_data_rom[  157]='h0000008e;
    rd_cycle[  158] = 1'b0;  wr_cycle[  158] = 1'b1;  addr_rom[  158]='h00000010;  wr_data_rom[  158]='h000000f1;
    rd_cycle[  159] = 1'b0;  wr_cycle[  159] = 1'b1;  addr_rom[  159]='h00000094;  wr_data_rom[  159]='h0000004b;
    rd_cycle[  160] = 1'b1;  wr_cycle[  160] = 1'b0;  addr_rom[  160]='h0000006c;  wr_data_rom[  160]='h00000000;
    rd_cycle[  161] = 1'b0;  wr_cycle[  161] = 1'b1;  addr_rom[  161]='h000000d8;  wr_data_rom[  161]='h0000003a;
    rd_cycle[  162] = 1'b0;  wr_cycle[  162] = 1'b1;  addr_rom[  162]='h00000098;  wr_data_rom[  162]='h000000dc;
    rd_cycle[  163] = 1'b0;  wr_cycle[  163] = 1'b1;  addr_rom[  163]='h00000054;  wr_data_rom[  163]='h0000007f;
    rd_cycle[  164] = 1'b1;  wr_cycle[  164] = 1'b0;  addr_rom[  164]='h000000fc;  wr_data_rom[  164]='h00000000;
    rd_cycle[  165] = 1'b0;  wr_cycle[  165] = 1'b1;  addr_rom[  165]='h000000ec;  wr_data_rom[  165]='h00000044;
    rd_cycle[  166] = 1'b1;  wr_cycle[  166] = 1'b0;  addr_rom[  166]='h000000e0;  wr_data_rom[  166]='h00000000;
    rd_cycle[  167] = 1'b0;  wr_cycle[  167] = 1'b1;  addr_rom[  167]='h000000bc;  wr_data_rom[  167]='h0000006a;
    rd_cycle[  168] = 1'b1;  wr_cycle[  168] = 1'b0;  addr_rom[  168]='h00000030;  wr_data_rom[  168]='h00000000;
    rd_cycle[  169] = 1'b1;  wr_cycle[  169] = 1'b0;  addr_rom[  169]='h000000a8;  wr_data_rom[  169]='h00000000;
    rd_cycle[  170] = 1'b1;  wr_cycle[  170] = 1'b0;  addr_rom[  170]='h00000060;  wr_data_rom[  170]='h00000000;
    rd_cycle[  171] = 1'b0;  wr_cycle[  171] = 1'b1;  addr_rom[  171]='h000000c4;  wr_data_rom[  171]='h000000e7;
    rd_cycle[  172] = 1'b0;  wr_cycle[  172] = 1'b1;  addr_rom[  172]='h00000038;  wr_data_rom[  172]='h00000023;
    rd_cycle[  173] = 1'b1;  wr_cycle[  173] = 1'b0;  addr_rom[  173]='h00000028;  wr_data_rom[  173]='h00000000;
    rd_cycle[  174] = 1'b1;  wr_cycle[  174] = 1'b0;  addr_rom[  174]='h00000014;  wr_data_rom[  174]='h00000000;
    rd_cycle[  175] = 1'b0;  wr_cycle[  175] = 1'b1;  addr_rom[  175]='h00000084;  wr_data_rom[  175]='h00000071;
    rd_cycle[  176] = 1'b0;  wr_cycle[  176] = 1'b1;  addr_rom[  176]='h000000b4;  wr_data_rom[  176]='h000000d4;
    rd_cycle[  177] = 1'b0;  wr_cycle[  177] = 1'b1;  addr_rom[  177]='h000000bc;  wr_data_rom[  177]='h00000046;
    rd_cycle[  178] = 1'b1;  wr_cycle[  178] = 1'b0;  addr_rom[  178]='h0000005c;  wr_data_rom[  178]='h00000000;
    rd_cycle[  179] = 1'b1;  wr_cycle[  179] = 1'b0;  addr_rom[  179]='h00000018;  wr_data_rom[  179]='h00000000;
    rd_cycle[  180] = 1'b0;  wr_cycle[  180] = 1'b1;  addr_rom[  180]='h00000044;  wr_data_rom[  180]='h000000f9;
    rd_cycle[  181] = 1'b1;  wr_cycle[  181] = 1'b0;  addr_rom[  181]='h0000008c;  wr_data_rom[  181]='h00000000;
    rd_cycle[  182] = 1'b0;  wr_cycle[  182] = 1'b1;  addr_rom[  182]='h000000d8;  wr_data_rom[  182]='h00000051;
    rd_cycle[  183] = 1'b1;  wr_cycle[  183] = 1'b0;  addr_rom[  183]='h00000060;  wr_data_rom[  183]='h00000000;
    rd_cycle[  184] = 1'b0;  wr_cycle[  184] = 1'b1;  addr_rom[  184]='h000000c0;  wr_data_rom[  184]='h00000055;
    rd_cycle[  185] = 1'b0;  wr_cycle[  185] = 1'b1;  addr_rom[  185]='h000000b0;  wr_data_rom[  185]='h00000088;
    rd_cycle[  186] = 1'b0;  wr_cycle[  186] = 1'b1;  addr_rom[  186]='h00000044;  wr_data_rom[  186]='h0000002a;
    rd_cycle[  187] = 1'b0;  wr_cycle[  187] = 1'b1;  addr_rom[  187]='h000000dc;  wr_data_rom[  187]='h000000ca;
    rd_cycle[  188] = 1'b1;  wr_cycle[  188] = 1'b0;  addr_rom[  188]='h000000a4;  wr_data_rom[  188]='h00000000;
    rd_cycle[  189] = 1'b1;  wr_cycle[  189] = 1'b0;  addr_rom[  189]='h000000cc;  wr_data_rom[  189]='h00000000;
    rd_cycle[  190] = 1'b0;  wr_cycle[  190] = 1'b1;  addr_rom[  190]='h00000028;  wr_data_rom[  190]='h0000007c;
    rd_cycle[  191] = 1'b0;  wr_cycle[  191] = 1'b1;  addr_rom[  191]='h00000090;  wr_data_rom[  191]='h00000071;
    rd_cycle[  192] = 1'b1;  wr_cycle[  192] = 1'b0;  addr_rom[  192]='h000000d8;  wr_data_rom[  192]='h00000000;
    rd_cycle[  193] = 1'b1;  wr_cycle[  193] = 1'b0;  addr_rom[  193]='h0000007c;  wr_data_rom[  193]='h00000000;
    rd_cycle[  194] = 1'b1;  wr_cycle[  194] = 1'b0;  addr_rom[  194]='h00000084;  wr_data_rom[  194]='h00000000;
    rd_cycle[  195] = 1'b0;  wr_cycle[  195] = 1'b1;  addr_rom[  195]='h00000090;  wr_data_rom[  195]='h0000004d;
    rd_cycle[  196] = 1'b0;  wr_cycle[  196] = 1'b1;  addr_rom[  196]='h0000008c;  wr_data_rom[  196]='h000000cb;
    rd_cycle[  197] = 1'b1;  wr_cycle[  197] = 1'b0;  addr_rom[  197]='h00000044;  wr_data_rom[  197]='h00000000;
    rd_cycle[  198] = 1'b0;  wr_cycle[  198] = 1'b1;  addr_rom[  198]='h00000054;  wr_data_rom[  198]='h000000b4;
    rd_cycle[  199] = 1'b1;  wr_cycle[  199] = 1'b0;  addr_rom[  199]='h000000a4;  wr_data_rom[  199]='h00000000;
    rd_cycle[  200] = 1'b1;  wr_cycle[  200] = 1'b0;  addr_rom[  200]='h0000006c;  wr_data_rom[  200]='h00000000;
    rd_cycle[  201] = 1'b1;  wr_cycle[  201] = 1'b0;  addr_rom[  201]='h00000058;  wr_data_rom[  201]='h00000000;
    rd_cycle[  202] = 1'b0;  wr_cycle[  202] = 1'b1;  addr_rom[  202]='h000000cc;  wr_data_rom[  202]='h00000038;
    rd_cycle[  203] = 1'b0;  wr_cycle[  203] = 1'b1;  addr_rom[  203]='h00000014;  wr_data_rom[  203]='h0000007e;
    rd_cycle[  204] = 1'b1;  wr_cycle[  204] = 1'b0;  addr_rom[  204]='h00000078;  wr_data_rom[  204]='h00000000;
    rd_cycle[  205] = 1'b1;  wr_cycle[  205] = 1'b0;  addr_rom[  205]='h00000094;  wr_data_rom[  205]='h00000000;
    rd_cycle[  206] = 1'b1;  wr_cycle[  206] = 1'b0;  addr_rom[  206]='h00000054;  wr_data_rom[  206]='h00000000;
    rd_cycle[  207] = 1'b1;  wr_cycle[  207] = 1'b0;  addr_rom[  207]='h000000a4;  wr_data_rom[  207]='h00000000;
    rd_cycle[  208] = 1'b1;  wr_cycle[  208] = 1'b0;  addr_rom[  208]='h00000088;  wr_data_rom[  208]='h00000000;
    rd_cycle[  209] = 1'b0;  wr_cycle[  209] = 1'b1;  addr_rom[  209]='h000000b4;  wr_data_rom[  209]='h00000048;
    rd_cycle[  210] = 1'b1;  wr_cycle[  210] = 1'b0;  addr_rom[  210]='h00000068;  wr_data_rom[  210]='h00000000;
    rd_cycle[  211] = 1'b1;  wr_cycle[  211] = 1'b0;  addr_rom[  211]='h00000058;  wr_data_rom[  211]='h00000000;
    rd_cycle[  212] = 1'b1;  wr_cycle[  212] = 1'b0;  addr_rom[  212]='h000000a0;  wr_data_rom[  212]='h00000000;
    rd_cycle[  213] = 1'b1;  wr_cycle[  213] = 1'b0;  addr_rom[  213]='h000000dc;  wr_data_rom[  213]='h00000000;
    rd_cycle[  214] = 1'b0;  wr_cycle[  214] = 1'b1;  addr_rom[  214]='h000000f4;  wr_data_rom[  214]='h00000087;
    rd_cycle[  215] = 1'b1;  wr_cycle[  215] = 1'b0;  addr_rom[  215]='h0000009c;  wr_data_rom[  215]='h00000000;
    rd_cycle[  216] = 1'b0;  wr_cycle[  216] = 1'b1;  addr_rom[  216]='h00000020;  wr_data_rom[  216]='h00000007;
    rd_cycle[  217] = 1'b1;  wr_cycle[  217] = 1'b0;  addr_rom[  217]='h0000001c;  wr_data_rom[  217]='h00000000;
    rd_cycle[  218] = 1'b1;  wr_cycle[  218] = 1'b0;  addr_rom[  218]='h0000004c;  wr_data_rom[  218]='h00000000;
    rd_cycle[  219] = 1'b0;  wr_cycle[  219] = 1'b1;  addr_rom[  219]='h000000bc;  wr_data_rom[  219]='h000000b8;
    rd_cycle[  220] = 1'b0;  wr_cycle[  220] = 1'b1;  addr_rom[  220]='h0000003c;  wr_data_rom[  220]='h00000046;
    rd_cycle[  221] = 1'b0;  wr_cycle[  221] = 1'b1;  addr_rom[  221]='h00000038;  wr_data_rom[  221]='h0000005d;
    rd_cycle[  222] = 1'b1;  wr_cycle[  222] = 1'b0;  addr_rom[  222]='h00000028;  wr_data_rom[  222]='h00000000;
    rd_cycle[  223] = 1'b1;  wr_cycle[  223] = 1'b0;  addr_rom[  223]='h0000006c;  wr_data_rom[  223]='h00000000;
    rd_cycle[  224] = 1'b1;  wr_cycle[  224] = 1'b0;  addr_rom[  224]='h00000000;  wr_data_rom[  224]='h00000000;
    rd_cycle[  225] = 1'b0;  wr_cycle[  225] = 1'b1;  addr_rom[  225]='h0000001c;  wr_data_rom[  225]='h00000027;
    rd_cycle[  226] = 1'b1;  wr_cycle[  226] = 1'b0;  addr_rom[  226]='h00000004;  wr_data_rom[  226]='h00000000;
    rd_cycle[  227] = 1'b1;  wr_cycle[  227] = 1'b0;  addr_rom[  227]='h00000084;  wr_data_rom[  227]='h00000000;
    rd_cycle[  228] = 1'b0;  wr_cycle[  228] = 1'b1;  addr_rom[  228]='h00000054;  wr_data_rom[  228]='h00000005;
    rd_cycle[  229] = 1'b1;  wr_cycle[  229] = 1'b0;  addr_rom[  229]='h00000034;  wr_data_rom[  229]='h00000000;
    rd_cycle[  230] = 1'b1;  wr_cycle[  230] = 1'b0;  addr_rom[  230]='h00000034;  wr_data_rom[  230]='h00000000;
    rd_cycle[  231] = 1'b0;  wr_cycle[  231] = 1'b1;  addr_rom[  231]='h000000c0;  wr_data_rom[  231]='h00000031;
    rd_cycle[  232] = 1'b0;  wr_cycle[  232] = 1'b1;  addr_rom[  232]='h00000050;  wr_data_rom[  232]='h0000001a;
    rd_cycle[  233] = 1'b1;  wr_cycle[  233] = 1'b0;  addr_rom[  233]='h00000010;  wr_data_rom[  233]='h00000000;
    rd_cycle[  234] = 1'b0;  wr_cycle[  234] = 1'b1;  addr_rom[  234]='h00000074;  wr_data_rom[  234]='h00000096;
    rd_cycle[  235] = 1'b1;  wr_cycle[  235] = 1'b0;  addr_rom[  235]='h00000084;  wr_data_rom[  235]='h00000000;
    rd_cycle[  236] = 1'b1;  wr_cycle[  236] = 1'b0;  addr_rom[  236]='h00000054;  wr_data_rom[  236]='h00000000;
    rd_cycle[  237] = 1'b0;  wr_cycle[  237] = 1'b1;  addr_rom[  237]='h000000b4;  wr_data_rom[  237]='h0000003f;
    rd_cycle[  238] = 1'b1;  wr_cycle[  238] = 1'b0;  addr_rom[  238]='h00000004;  wr_data_rom[  238]='h00000000;
    rd_cycle[  239] = 1'b1;  wr_cycle[  239] = 1'b0;  addr_rom[  239]='h000000dc;  wr_data_rom[  239]='h00000000;
    rd_cycle[  240] = 1'b0;  wr_cycle[  240] = 1'b1;  addr_rom[  240]='h00000048;  wr_data_rom[  240]='h0000009f;
    rd_cycle[  241] = 1'b0;  wr_cycle[  241] = 1'b1;  addr_rom[  241]='h00000094;  wr_data_rom[  241]='h000000f8;
    rd_cycle[  242] = 1'b1;  wr_cycle[  242] = 1'b0;  addr_rom[  242]='h000000bc;  wr_data_rom[  242]='h00000000;
    rd_cycle[  243] = 1'b0;  wr_cycle[  243] = 1'b1;  addr_rom[  243]='h000000b4;  wr_data_rom[  243]='h000000da;
    rd_cycle[  244] = 1'b0;  wr_cycle[  244] = 1'b1;  addr_rom[  244]='h00000008;  wr_data_rom[  244]='h0000000c;
    rd_cycle[  245] = 1'b0;  wr_cycle[  245] = 1'b1;  addr_rom[  245]='h00000088;  wr_data_rom[  245]='h00000034;
    rd_cycle[  246] = 1'b1;  wr_cycle[  246] = 1'b0;  addr_rom[  246]='h000000c8;  wr_data_rom[  246]='h00000000;
    rd_cycle[  247] = 1'b1;  wr_cycle[  247] = 1'b0;  addr_rom[  247]='h00000004;  wr_data_rom[  247]='h00000000;
    rd_cycle[  248] = 1'b1;  wr_cycle[  248] = 1'b0;  addr_rom[  248]='h0000002c;  wr_data_rom[  248]='h00000000;
    rd_cycle[  249] = 1'b0;  wr_cycle[  249] = 1'b1;  addr_rom[  249]='h000000c8;  wr_data_rom[  249]='h000000d0;
    rd_cycle[  250] = 1'b0;  wr_cycle[  250] = 1'b1;  addr_rom[  250]='h0000000c;  wr_data_rom[  250]='h000000b7;
    rd_cycle[  251] = 1'b1;  wr_cycle[  251] = 1'b0;  addr_rom[  251]='h000000d0;  wr_data_rom[  251]='h00000000;
    rd_cycle[  252] = 1'b0;  wr_cycle[  252] = 1'b1;  addr_rom[  252]='h00000068;  wr_data_rom[  252]='h00000072;
    rd_cycle[  253] = 1'b0;  wr_cycle[  253] = 1'b1;  addr_rom[  253]='h00000050;  wr_data_rom[  253]='h000000fc;
    rd_cycle[  254] = 1'b0;  wr_cycle[  254] = 1'b1;  addr_rom[  254]='h00000040;  wr_data_rom[  254]='h00000054;
    rd_cycle[  255] = 1'b1;  wr_cycle[  255] = 1'b0;  addr_rom[  255]='h000000c0;  wr_data_rom[  255]='h00000000;
    // 64 silence cycles
    rd_cycle[  256] = 1'b0;  wr_cycle[  256] = 1'b0;  addr_rom[  256]='h00000000;  wr_data_rom[  256]='h00000000;
    rd_cycle[  257] = 1'b0;  wr_cycle[  257] = 1'b0;  addr_rom[  257]='h00000000;  wr_data_rom[  257]='h00000000;
    rd_cycle[  258] = 1'b0;  wr_cycle[  258] = 1'b0;  addr_rom[  258]='h00000000;  wr_data_rom[  258]='h00000000;
    rd_cycle[  259] = 1'b0;  wr_cycle[  259] = 1'b0;  addr_rom[  259]='h00000000;  wr_data_rom[  259]='h00000000;
    rd_cycle[  260] = 1'b0;  wr_cycle[  260] = 1'b0;  addr_rom[  260]='h00000000;  wr_data_rom[  260]='h00000000;
    rd_cycle[  261] = 1'b0;  wr_cycle[  261] = 1'b0;  addr_rom[  261]='h00000000;  wr_data_rom[  261]='h00000000;
    rd_cycle[  262] = 1'b0;  wr_cycle[  262] = 1'b0;  addr_rom[  262]='h00000000;  wr_data_rom[  262]='h00000000;
    rd_cycle[  263] = 1'b0;  wr_cycle[  263] = 1'b0;  addr_rom[  263]='h00000000;  wr_data_rom[  263]='h00000000;
    rd_cycle[  264] = 1'b0;  wr_cycle[  264] = 1'b0;  addr_rom[  264]='h00000000;  wr_data_rom[  264]='h00000000;
    rd_cycle[  265] = 1'b0;  wr_cycle[  265] = 1'b0;  addr_rom[  265]='h00000000;  wr_data_rom[  265]='h00000000;
    rd_cycle[  266] = 1'b0;  wr_cycle[  266] = 1'b0;  addr_rom[  266]='h00000000;  wr_data_rom[  266]='h00000000;
    rd_cycle[  267] = 1'b0;  wr_cycle[  267] = 1'b0;  addr_rom[  267]='h00000000;  wr_data_rom[  267]='h00000000;
    rd_cycle[  268] = 1'b0;  wr_cycle[  268] = 1'b0;  addr_rom[  268]='h00000000;  wr_data_rom[  268]='h00000000;
    rd_cycle[  269] = 1'b0;  wr_cycle[  269] = 1'b0;  addr_rom[  269]='h00000000;  wr_data_rom[  269]='h00000000;
    rd_cycle[  270] = 1'b0;  wr_cycle[  270] = 1'b0;  addr_rom[  270]='h00000000;  wr_data_rom[  270]='h00000000;
    rd_cycle[  271] = 1'b0;  wr_cycle[  271] = 1'b0;  addr_rom[  271]='h00000000;  wr_data_rom[  271]='h00000000;
    rd_cycle[  272] = 1'b0;  wr_cycle[  272] = 1'b0;  addr_rom[  272]='h00000000;  wr_data_rom[  272]='h00000000;
    rd_cycle[  273] = 1'b0;  wr_cycle[  273] = 1'b0;  addr_rom[  273]='h00000000;  wr_data_rom[  273]='h00000000;
    rd_cycle[  274] = 1'b0;  wr_cycle[  274] = 1'b0;  addr_rom[  274]='h00000000;  wr_data_rom[  274]='h00000000;
    rd_cycle[  275] = 1'b0;  wr_cycle[  275] = 1'b0;  addr_rom[  275]='h00000000;  wr_data_rom[  275]='h00000000;
    rd_cycle[  276] = 1'b0;  wr_cycle[  276] = 1'b0;  addr_rom[  276]='h00000000;  wr_data_rom[  276]='h00000000;
    rd_cycle[  277] = 1'b0;  wr_cycle[  277] = 1'b0;  addr_rom[  277]='h00000000;  wr_data_rom[  277]='h00000000;
    rd_cycle[  278] = 1'b0;  wr_cycle[  278] = 1'b0;  addr_rom[  278]='h00000000;  wr_data_rom[  278]='h00000000;
    rd_cycle[  279] = 1'b0;  wr_cycle[  279] = 1'b0;  addr_rom[  279]='h00000000;  wr_data_rom[  279]='h00000000;
    rd_cycle[  280] = 1'b0;  wr_cycle[  280] = 1'b0;  addr_rom[  280]='h00000000;  wr_data_rom[  280]='h00000000;
    rd_cycle[  281] = 1'b0;  wr_cycle[  281] = 1'b0;  addr_rom[  281]='h00000000;  wr_data_rom[  281]='h00000000;
    rd_cycle[  282] = 1'b0;  wr_cycle[  282] = 1'b0;  addr_rom[  282]='h00000000;  wr_data_rom[  282]='h00000000;
    rd_cycle[  283] = 1'b0;  wr_cycle[  283] = 1'b0;  addr_rom[  283]='h00000000;  wr_data_rom[  283]='h00000000;
    rd_cycle[  284] = 1'b0;  wr_cycle[  284] = 1'b0;  addr_rom[  284]='h00000000;  wr_data_rom[  284]='h00000000;
    rd_cycle[  285] = 1'b0;  wr_cycle[  285] = 1'b0;  addr_rom[  285]='h00000000;  wr_data_rom[  285]='h00000000;
    rd_cycle[  286] = 1'b0;  wr_cycle[  286] = 1'b0;  addr_rom[  286]='h00000000;  wr_data_rom[  286]='h00000000;
    rd_cycle[  287] = 1'b0;  wr_cycle[  287] = 1'b0;  addr_rom[  287]='h00000000;  wr_data_rom[  287]='h00000000;
    rd_cycle[  288] = 1'b0;  wr_cycle[  288] = 1'b0;  addr_rom[  288]='h00000000;  wr_data_rom[  288]='h00000000;
    rd_cycle[  289] = 1'b0;  wr_cycle[  289] = 1'b0;  addr_rom[  289]='h00000000;  wr_data_rom[  289]='h00000000;
    rd_cycle[  290] = 1'b0;  wr_cycle[  290] = 1'b0;  addr_rom[  290]='h00000000;  wr_data_rom[  290]='h00000000;
    rd_cycle[  291] = 1'b0;  wr_cycle[  291] = 1'b0;  addr_rom[  291]='h00000000;  wr_data_rom[  291]='h00000000;
    rd_cycle[  292] = 1'b0;  wr_cycle[  292] = 1'b0;  addr_rom[  292]='h00000000;  wr_data_rom[  292]='h00000000;
    rd_cycle[  293] = 1'b0;  wr_cycle[  293] = 1'b0;  addr_rom[  293]='h00000000;  wr_data_rom[  293]='h00000000;
    rd_cycle[  294] = 1'b0;  wr_cycle[  294] = 1'b0;  addr_rom[  294]='h00000000;  wr_data_rom[  294]='h00000000;
    rd_cycle[  295] = 1'b0;  wr_cycle[  295] = 1'b0;  addr_rom[  295]='h00000000;  wr_data_rom[  295]='h00000000;
    rd_cycle[  296] = 1'b0;  wr_cycle[  296] = 1'b0;  addr_rom[  296]='h00000000;  wr_data_rom[  296]='h00000000;
    rd_cycle[  297] = 1'b0;  wr_cycle[  297] = 1'b0;  addr_rom[  297]='h00000000;  wr_data_rom[  297]='h00000000;
    rd_cycle[  298] = 1'b0;  wr_cycle[  298] = 1'b0;  addr_rom[  298]='h00000000;  wr_data_rom[  298]='h00000000;
    rd_cycle[  299] = 1'b0;  wr_cycle[  299] = 1'b0;  addr_rom[  299]='h00000000;  wr_data_rom[  299]='h00000000;
    rd_cycle[  300] = 1'b0;  wr_cycle[  300] = 1'b0;  addr_rom[  300]='h00000000;  wr_data_rom[  300]='h00000000;
    rd_cycle[  301] = 1'b0;  wr_cycle[  301] = 1'b0;  addr_rom[  301]='h00000000;  wr_data_rom[  301]='h00000000;
    rd_cycle[  302] = 1'b0;  wr_cycle[  302] = 1'b0;  addr_rom[  302]='h00000000;  wr_data_rom[  302]='h00000000;
    rd_cycle[  303] = 1'b0;  wr_cycle[  303] = 1'b0;  addr_rom[  303]='h00000000;  wr_data_rom[  303]='h00000000;
    rd_cycle[  304] = 1'b0;  wr_cycle[  304] = 1'b0;  addr_rom[  304]='h00000000;  wr_data_rom[  304]='h00000000;
    rd_cycle[  305] = 1'b0;  wr_cycle[  305] = 1'b0;  addr_rom[  305]='h00000000;  wr_data_rom[  305]='h00000000;
    rd_cycle[  306] = 1'b0;  wr_cycle[  306] = 1'b0;  addr_rom[  306]='h00000000;  wr_data_rom[  306]='h00000000;
    rd_cycle[  307] = 1'b0;  wr_cycle[  307] = 1'b0;  addr_rom[  307]='h00000000;  wr_data_rom[  307]='h00000000;
    rd_cycle[  308] = 1'b0;  wr_cycle[  308] = 1'b0;  addr_rom[  308]='h00000000;  wr_data_rom[  308]='h00000000;
    rd_cycle[  309] = 1'b0;  wr_cycle[  309] = 1'b0;  addr_rom[  309]='h00000000;  wr_data_rom[  309]='h00000000;
    rd_cycle[  310] = 1'b0;  wr_cycle[  310] = 1'b0;  addr_rom[  310]='h00000000;  wr_data_rom[  310]='h00000000;
    rd_cycle[  311] = 1'b0;  wr_cycle[  311] = 1'b0;  addr_rom[  311]='h00000000;  wr_data_rom[  311]='h00000000;
    rd_cycle[  312] = 1'b0;  wr_cycle[  312] = 1'b0;  addr_rom[  312]='h00000000;  wr_data_rom[  312]='h00000000;
    rd_cycle[  313] = 1'b0;  wr_cycle[  313] = 1'b0;  addr_rom[  313]='h00000000;  wr_data_rom[  313]='h00000000;
    rd_cycle[  314] = 1'b0;  wr_cycle[  314] = 1'b0;  addr_rom[  314]='h00000000;  wr_data_rom[  314]='h00000000;
    rd_cycle[  315] = 1'b0;  wr_cycle[  315] = 1'b0;  addr_rom[  315]='h00000000;  wr_data_rom[  315]='h00000000;
    rd_cycle[  316] = 1'b0;  wr_cycle[  316] = 1'b0;  addr_rom[  316]='h00000000;  wr_data_rom[  316]='h00000000;
    rd_cycle[  317] = 1'b0;  wr_cycle[  317] = 1'b0;  addr_rom[  317]='h00000000;  wr_data_rom[  317]='h00000000;
    rd_cycle[  318] = 1'b0;  wr_cycle[  318] = 1'b0;  addr_rom[  318]='h00000000;  wr_data_rom[  318]='h00000000;
    rd_cycle[  319] = 1'b0;  wr_cycle[  319] = 1'b0;  addr_rom[  319]='h00000000;  wr_data_rom[  319]='h00000000;
    // 64 sequence read cycles
    rd_cycle[  320] = 1'b1;  wr_cycle[  320] = 1'b0;  addr_rom[  320]='h00000000;  wr_data_rom[  320]='h00000000;
    rd_cycle[  321] = 1'b1;  wr_cycle[  321] = 1'b0;  addr_rom[  321]='h00000004;  wr_data_rom[  321]='h00000000;
    rd_cycle[  322] = 1'b1;  wr_cycle[  322] = 1'b0;  addr_rom[  322]='h00000008;  wr_data_rom[  322]='h00000000;
    rd_cycle[  323] = 1'b1;  wr_cycle[  323] = 1'b0;  addr_rom[  323]='h0000000c;  wr_data_rom[  323]='h00000000;
    rd_cycle[  324] = 1'b1;  wr_cycle[  324] = 1'b0;  addr_rom[  324]='h00000010;  wr_data_rom[  324]='h00000000;
    rd_cycle[  325] = 1'b1;  wr_cycle[  325] = 1'b0;  addr_rom[  325]='h00000014;  wr_data_rom[  325]='h00000000;
    rd_cycle[  326] = 1'b1;  wr_cycle[  326] = 1'b0;  addr_rom[  326]='h00000018;  wr_data_rom[  326]='h00000000;
    rd_cycle[  327] = 1'b1;  wr_cycle[  327] = 1'b0;  addr_rom[  327]='h0000001c;  wr_data_rom[  327]='h00000000;
    rd_cycle[  328] = 1'b1;  wr_cycle[  328] = 1'b0;  addr_rom[  328]='h00000020;  wr_data_rom[  328]='h00000000;
    rd_cycle[  329] = 1'b1;  wr_cycle[  329] = 1'b0;  addr_rom[  329]='h00000024;  wr_data_rom[  329]='h00000000;
    rd_cycle[  330] = 1'b1;  wr_cycle[  330] = 1'b0;  addr_rom[  330]='h00000028;  wr_data_rom[  330]='h00000000;
    rd_cycle[  331] = 1'b1;  wr_cycle[  331] = 1'b0;  addr_rom[  331]='h0000002c;  wr_data_rom[  331]='h00000000;
    rd_cycle[  332] = 1'b1;  wr_cycle[  332] = 1'b0;  addr_rom[  332]='h00000030;  wr_data_rom[  332]='h00000000;
    rd_cycle[  333] = 1'b1;  wr_cycle[  333] = 1'b0;  addr_rom[  333]='h00000034;  wr_data_rom[  333]='h00000000;
    rd_cycle[  334] = 1'b1;  wr_cycle[  334] = 1'b0;  addr_rom[  334]='h00000038;  wr_data_rom[  334]='h00000000;
    rd_cycle[  335] = 1'b1;  wr_cycle[  335] = 1'b0;  addr_rom[  335]='h0000003c;  wr_data_rom[  335]='h00000000;
    rd_cycle[  336] = 1'b1;  wr_cycle[  336] = 1'b0;  addr_rom[  336]='h00000040;  wr_data_rom[  336]='h00000000;
    rd_cycle[  337] = 1'b1;  wr_cycle[  337] = 1'b0;  addr_rom[  337]='h00000044;  wr_data_rom[  337]='h00000000;
    rd_cycle[  338] = 1'b1;  wr_cycle[  338] = 1'b0;  addr_rom[  338]='h00000048;  wr_data_rom[  338]='h00000000;
    rd_cycle[  339] = 1'b1;  wr_cycle[  339] = 1'b0;  addr_rom[  339]='h0000004c;  wr_data_rom[  339]='h00000000;
    rd_cycle[  340] = 1'b1;  wr_cycle[  340] = 1'b0;  addr_rom[  340]='h00000050;  wr_data_rom[  340]='h00000000;
    rd_cycle[  341] = 1'b1;  wr_cycle[  341] = 1'b0;  addr_rom[  341]='h00000054;  wr_data_rom[  341]='h00000000;
    rd_cycle[  342] = 1'b1;  wr_cycle[  342] = 1'b0;  addr_rom[  342]='h00000058;  wr_data_rom[  342]='h00000000;
    rd_cycle[  343] = 1'b1;  wr_cycle[  343] = 1'b0;  addr_rom[  343]='h0000005c;  wr_data_rom[  343]='h00000000;
    rd_cycle[  344] = 1'b1;  wr_cycle[  344] = 1'b0;  addr_rom[  344]='h00000060;  wr_data_rom[  344]='h00000000;
    rd_cycle[  345] = 1'b1;  wr_cycle[  345] = 1'b0;  addr_rom[  345]='h00000064;  wr_data_rom[  345]='h00000000;
    rd_cycle[  346] = 1'b1;  wr_cycle[  346] = 1'b0;  addr_rom[  346]='h00000068;  wr_data_rom[  346]='h00000000;
    rd_cycle[  347] = 1'b1;  wr_cycle[  347] = 1'b0;  addr_rom[  347]='h0000006c;  wr_data_rom[  347]='h00000000;
    rd_cycle[  348] = 1'b1;  wr_cycle[  348] = 1'b0;  addr_rom[  348]='h00000070;  wr_data_rom[  348]='h00000000;
    rd_cycle[  349] = 1'b1;  wr_cycle[  349] = 1'b0;  addr_rom[  349]='h00000074;  wr_data_rom[  349]='h00000000;
    rd_cycle[  350] = 1'b1;  wr_cycle[  350] = 1'b0;  addr_rom[  350]='h00000078;  wr_data_rom[  350]='h00000000;
    rd_cycle[  351] = 1'b1;  wr_cycle[  351] = 1'b0;  addr_rom[  351]='h0000007c;  wr_data_rom[  351]='h00000000;
    rd_cycle[  352] = 1'b1;  wr_cycle[  352] = 1'b0;  addr_rom[  352]='h00000080;  wr_data_rom[  352]='h00000000;
    rd_cycle[  353] = 1'b1;  wr_cycle[  353] = 1'b0;  addr_rom[  353]='h00000084;  wr_data_rom[  353]='h00000000;
    rd_cycle[  354] = 1'b1;  wr_cycle[  354] = 1'b0;  addr_rom[  354]='h00000088;  wr_data_rom[  354]='h00000000;
    rd_cycle[  355] = 1'b1;  wr_cycle[  355] = 1'b0;  addr_rom[  355]='h0000008c;  wr_data_rom[  355]='h00000000;
    rd_cycle[  356] = 1'b1;  wr_cycle[  356] = 1'b0;  addr_rom[  356]='h00000090;  wr_data_rom[  356]='h00000000;
    rd_cycle[  357] = 1'b1;  wr_cycle[  357] = 1'b0;  addr_rom[  357]='h00000094;  wr_data_rom[  357]='h00000000;
    rd_cycle[  358] = 1'b1;  wr_cycle[  358] = 1'b0;  addr_rom[  358]='h00000098;  wr_data_rom[  358]='h00000000;
    rd_cycle[  359] = 1'b1;  wr_cycle[  359] = 1'b0;  addr_rom[  359]='h0000009c;  wr_data_rom[  359]='h00000000;
    rd_cycle[  360] = 1'b1;  wr_cycle[  360] = 1'b0;  addr_rom[  360]='h000000a0;  wr_data_rom[  360]='h00000000;
    rd_cycle[  361] = 1'b1;  wr_cycle[  361] = 1'b0;  addr_rom[  361]='h000000a4;  wr_data_rom[  361]='h00000000;
    rd_cycle[  362] = 1'b1;  wr_cycle[  362] = 1'b0;  addr_rom[  362]='h000000a8;  wr_data_rom[  362]='h00000000;
    rd_cycle[  363] = 1'b1;  wr_cycle[  363] = 1'b0;  addr_rom[  363]='h000000ac;  wr_data_rom[  363]='h00000000;
    rd_cycle[  364] = 1'b1;  wr_cycle[  364] = 1'b0;  addr_rom[  364]='h000000b0;  wr_data_rom[  364]='h00000000;
    rd_cycle[  365] = 1'b1;  wr_cycle[  365] = 1'b0;  addr_rom[  365]='h000000b4;  wr_data_rom[  365]='h00000000;
    rd_cycle[  366] = 1'b1;  wr_cycle[  366] = 1'b0;  addr_rom[  366]='h000000b8;  wr_data_rom[  366]='h00000000;
    rd_cycle[  367] = 1'b1;  wr_cycle[  367] = 1'b0;  addr_rom[  367]='h000000bc;  wr_data_rom[  367]='h00000000;
    rd_cycle[  368] = 1'b1;  wr_cycle[  368] = 1'b0;  addr_rom[  368]='h000000c0;  wr_data_rom[  368]='h00000000;
    rd_cycle[  369] = 1'b1;  wr_cycle[  369] = 1'b0;  addr_rom[  369]='h000000c4;  wr_data_rom[  369]='h00000000;
    rd_cycle[  370] = 1'b1;  wr_cycle[  370] = 1'b0;  addr_rom[  370]='h000000c8;  wr_data_rom[  370]='h00000000;
    rd_cycle[  371] = 1'b1;  wr_cycle[  371] = 1'b0;  addr_rom[  371]='h000000cc;  wr_data_rom[  371]='h00000000;
    rd_cycle[  372] = 1'b1;  wr_cycle[  372] = 1'b0;  addr_rom[  372]='h000000d0;  wr_data_rom[  372]='h00000000;
    rd_cycle[  373] = 1'b1;  wr_cycle[  373] = 1'b0;  addr_rom[  373]='h000000d4;  wr_data_rom[  373]='h00000000;
    rd_cycle[  374] = 1'b1;  wr_cycle[  374] = 1'b0;  addr_rom[  374]='h000000d8;  wr_data_rom[  374]='h00000000;
    rd_cycle[  375] = 1'b1;  wr_cycle[  375] = 1'b0;  addr_rom[  375]='h000000dc;  wr_data_rom[  375]='h00000000;
    rd_cycle[  376] = 1'b1;  wr_cycle[  376] = 1'b0;  addr_rom[  376]='h000000e0;  wr_data_rom[  376]='h00000000;
    rd_cycle[  377] = 1'b1;  wr_cycle[  377] = 1'b0;  addr_rom[  377]='h000000e4;  wr_data_rom[  377]='h00000000;
    rd_cycle[  378] = 1'b1;  wr_cycle[  378] = 1'b0;  addr_rom[  378]='h000000e8;  wr_data_rom[  378]='h00000000;
    rd_cycle[  379] = 1'b1;  wr_cycle[  379] = 1'b0;  addr_rom[  379]='h000000ec;  wr_data_rom[  379]='h00000000;
    rd_cycle[  380] = 1'b1;  wr_cycle[  380] = 1'b0;  addr_rom[  380]='h000000f0;  wr_data_rom[  380]='h00000000;
    rd_cycle[  381] = 1'b1;  wr_cycle[  381] = 1'b0;  addr_rom[  381]='h000000f4;  wr_data_rom[  381]='h00000000;
    rd_cycle[  382] = 1'b1;  wr_cycle[  382] = 1'b0;  addr_rom[  382]='h000000f8;  wr_data_rom[  382]='h00000000;
    rd_cycle[  383] = 1'b1;  wr_cycle[  383] = 1'b0;  addr_rom[  383]='h000000fc;  wr_data_rom[  383]='h00000000;
end

initial begin
    validation_data[    0] = 'h000000a3; 
    validation_data[    1] = 'h000000d2; 
    validation_data[    2] = 'h0000000c; 
    validation_data[    3] = 'h000000b7; 
    validation_data[    4] = 'h000000f1; 
    validation_data[    5] = 'h0000007e; 
    validation_data[    6] = 'h0000009f; 
    validation_data[    7] = 'h00000027; 
    validation_data[    8] = 'h00000007; 
    validation_data[    9] = 'h000000b4; 
    validation_data[   10] = 'h0000007c; 
    validation_data[   11] = 'h00000033; 
    validation_data[   12] = 'h00000055; 
    validation_data[   13] = 'h0000007e; 
    validation_data[   14] = 'h0000005d; 
    validation_data[   15] = 'h00000046; 
    validation_data[   16] = 'h00000054; 
    validation_data[   17] = 'h0000002a; 
    validation_data[   18] = 'h0000009f; 
    validation_data[   19] = 'h000000b6; 
    validation_data[   20] = 'h000000fc; 
    validation_data[   21] = 'h00000005; 
    validation_data[   22] = 'h000000c7; 
    validation_data[   23] = 'h000000a0; 
    validation_data[   24] = 'h00000050; 
    validation_data[   25] = 'h0000008e; 
    validation_data[   26] = 'h00000072; 
    validation_data[   27] = 'h0000006b; 
    validation_data[   28] = 'h00000037; 
    validation_data[   29] = 'h00000096; 
    validation_data[   30] = 'h000000dc; 
    validation_data[   31] = 'h0000001b; 
    validation_data[   32] = 'h00000015; 
    validation_data[   33] = 'h00000071; 
    validation_data[   34] = 'h00000034; 
    validation_data[   35] = 'h000000cb; 
    validation_data[   36] = 'h0000004d; 
    validation_data[   37] = 'h000000f8; 
    validation_data[   38] = 'h000000dc; 
    validation_data[   39] = 'h00000059; 
    validation_data[   40] = 'h00000058; 
    validation_data[   41] = 'h000000d4; 
    validation_data[   42] = 'h000000be; 
    validation_data[   43] = 'h000000c0; 
    validation_data[   44] = 'h00000088; 
    validation_data[   45] = 'h000000da; 
    validation_data[   46] = 'h00000044; 
    validation_data[   47] = 'h000000b8; 
    validation_data[   48] = 'h00000031; 
    validation_data[   49] = 'h000000e7; 
    validation_data[   50] = 'h000000d0; 
    validation_data[   51] = 'h00000038; 
    validation_data[   52] = 'h0000002d; 
    validation_data[   53] = 'h000000cb; 
    validation_data[   54] = 'h00000051; 
    validation_data[   55] = 'h000000ca; 
    validation_data[   56] = 'h0000009c; 
    validation_data[   57] = 'h0000007c; 
    validation_data[   58] = 'h000000ce; 
    validation_data[   59] = 'h00000044; 
    validation_data[   60] = 'h00000090; 
    validation_data[   61] = 'h00000087; 
    validation_data[   62] = 'h0000006e; 
    validation_data[   63] = 'h00000087; 

end


reg clk = 1'b1, rst = 1'b1;
initial #4 rst = 1'b0;
always  #1 clk = ~clk;

wire  miss;
wire [31:0] rd_data;
reg  [31:0] index = 0, wr_data = 0, addr = 0;
reg  rd_req = 1'b0, wr_req = 1'b0;
reg rd_req_ff = 1'b0, miss_ff = 1'b0;
reg [31:0] validation_count = 0;

always @ (posedge clk or posedge rst)
    if(rst) begin
        rd_req_ff <= 1'b0;
        miss_ff   <= 1'b0;
    end else begin
        rd_req_ff <= rd_req;
        miss_ff   <= miss;
    end

always @ (posedge clk or posedge rst)
    if(rst) begin
        validation_count <= 0;
    end else begin
        if(validation_count>=`DATA_COUNT) begin
            validation_count <= 'hffffffff;
        end else if(rd_req_ff && (index>(4*`DATA_COUNT))) begin
            if(~miss_ff) begin
                if(validation_data[validation_count]==rd_data)
                    validation_count <= validation_count+1;
                else
                    validation_count <= 0;
            end
        end else begin
            validation_count <= 0;
        end
    end

always @ (posedge clk or posedge rst)
    if(rst) begin
        index   <= 0;
        wr_data <= 0;
        addr    <= 0;
        rd_req  <= 1'b0;
        wr_req  <= 1'b0;
    end else begin
        if(~miss) begin
            if(index<`RDWR_COUNT) begin
                if(wr_cycle[index]) begin
                    rd_req  <= 1'b0;
                    wr_req  <= 1'b1;
                end else if(rd_cycle[index]) begin
                    wr_data <= 0;
                    rd_req  <= 1'b1;
                    wr_req  <= 1'b0;
                end else begin
                    wr_data <= 0;
                    rd_req  <= 1'b0;
                    wr_req  <= 1'b0;
                end
                wr_data <= wr_data_rom[index];
                addr    <= addr_rom[index];
                index <= index + 1;
            end else begin
                wr_data <= 0;
                addr    <= 0;
                rd_req  <= 1'b0;
                wr_req  <= 1'b0;
            end
        end
    end

cache #(
    .LINE_ADDR_LEN  ( 3             ),
    .SET_ADDR_LEN   ( 1             ),
    .TAG_ADDR_LEN   ( 12            ),
    .WAY_CNT        ( 3             )
) cache_test_instance (
    .clk            ( clk           ),
    .rst            ( rst           ),
    .miss           ( miss          ),
    .addr           ( addr          ),
    .rd_req         ( rd_req        ),
    .rd_data        ( rd_data       ),
    .wr_req         ( wr_req        ),
    .wr_data        ( wr_data       )
);

endmodule

