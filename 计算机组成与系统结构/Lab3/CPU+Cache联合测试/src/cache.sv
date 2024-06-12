module cache #(
    parameter  LINE_ADDR_LEN = 3, // line内地址长度，决定了每个line具有2^3个word
    parameter  SET_ADDR_LEN  = 3, // 组地址长度，决定了一共有2^3=8组
    parameter  TAG_ADDR_LEN  = 6, // tag长度
    parameter  WAY_CNT       = 3  // 组相连度，决定了每组中有多少路line，在直接映射型cache中该参数没用，注意不是地址长度而是路的个数
)(
    input  clk, rst,
    output miss,               // 对CPU发出的miss信号
    input  [31:0] addr,        // 读写请求地址
    input  rd_req,             // 读请求信号
    output reg [31:0] rd_data, // 读出的数据，一次读一个word
    input  wr_req,             // 写请求信号
    input  [31:0] wr_data      // 要写入的数据，一次写一个word
);

    localparam MEM_ADDR_LEN    = TAG_ADDR_LEN + SET_ADDR_LEN;                           // 计算主存地址长度 MEM_ADDR_LEN，主存大小=2^MEM_ADDR_LEN个line
    localparam UNUSED_ADDR_LEN = 32 - TAG_ADDR_LEN - SET_ADDR_LEN - LINE_ADDR_LEN - 2 ; // 计算未使用的地址的长度

    localparam LINE_SIZE       = 1 << LINE_ADDR_LEN  ;         // 计算 line 中 word 的数量，即 2^LINE_ADDR_LEN 个word 每 line
    localparam SET_SIZE        = 1 << SET_ADDR_LEN   ;         // 计算一共有多少组，即 2^SET_ADDR_LEN 个组

    reg [            31:0] cache_mem  [SET_SIZE][WAY_CNT][LINE_SIZE]; // SET_SIZE个组，每组WAY_CNT条路，每路一个line，每line有LINE_SIZE个word
    reg [TAG_ADDR_LEN-1:0] cache_tags [SET_SIZE][WAY_CNT];            // 每条路（即每个line）一个TAG
    reg                    valid      [SET_SIZE][WAY_CNT];            // 每条路（即每个line）一个valid(有效位)
    reg                    dirty      [SET_SIZE][WAY_CNT];            // 每条路（即每个line）一个dirty(脏位)

    wire [              2-1 :0]   word_addr;                   // 将输入地址addr拆分成5个部分
    wire [  LINE_ADDR_LEN-1 :0]   line_addr;
    wire [   SET_ADDR_LEN-1 :0]    set_addr;
    wire [   TAG_ADDR_LEN-1 :0]    tag_addr;
    wire [UNUSED_ADDR_LEN-1 :0] unused_addr;

    enum  {IDLE, SWAP_OUT, SWAP_IN, SWAP_IN_OK} cache_stat;    // cache 状态机的状态定义
                                                               // IDLE代表就绪，SWAP_OUT代表正在换出，SWAP_IN代表正在换入，SWAP_IN_OK代表换入后进行一周期的写入cache操作。

    reg [   SET_ADDR_LEN-1 :0] mem_rd_set_addr = 0;
    reg [   TAG_ADDR_LEN-1 :0] mem_rd_tag_addr = 0;
    wire[   MEM_ADDR_LEN-1 :0] mem_rd_addr = {mem_rd_tag_addr, mem_rd_set_addr}; //主存读用的地址
    reg [   MEM_ADDR_LEN-1 :0] mem_wr_addr = 0;                                  //主存写用的地址

    reg  [31:0] mem_wr_line [LINE_SIZE];  //主存写传输数据
    wire [31:0] mem_rd_line [LINE_SIZE];  //主存读传输数据

    wire mem_gnt;      // 主存响应读写的握手信号，当mem_gnt==1时表示命中主存

    assign {unused_addr, tag_addr, set_addr, line_addr, word_addr} = addr;  // 拆分 32bit ADDR

    /* 该部分为直接映射时所用的命中判断
    reg cache_hit = 1'b0;
    always @ (*) begin             // 判断 输入的address 是否在 cache 中命中
        if( valid[set_addr] && cache_tags[set_addr] == tag_addr )   // 如果 cache line有效，并且tag与输入地址中的tag相等，则命中
            cache_hit = 1'b1;
        else
            cache_hit = 1'b0;   
    end
    */

    /* 组相连cache则需要在组内并行的判断每路line是否命中 */
    reg [WAY_CNT-1 :0] cache_hit = 0;    // 热独码，如果命中，则cache_hit会有一位为1；如果未命中，则全为0
    reg [WAY_CNT-1 :0] way_hit   = 0;    // 若命中，记录该路的位置，位宽肯定不会超过WAY_CNT
    always @ (*) begin
        for(integer i=0; i<WAY_CNT; i++) begin
            cache_hit[i] = (valid[set_addr][i] && cache_tags[set_addr][i] == tag_addr)? 1'b1 : 1'b0;
            way_hit = (cache_hit[i])? i : way_hit; // 如果命中，记录下该路的位置编号；否则保持不变
        end
    end

    /*这里定义替换策略所需的中间变量*/
    /*********************************************************************************************/
    /* 1.FIFO策略 *//*
    reg [  WAY_CNT-1 :0] FIFO_way   [SET_SIZE][WAY_CNT]; // 每个SET都有自己的FIFO顺序，用数组来代替链表进行记录。数组每个元素对应一路，按照被替换的优先级排列
                                                         // 应该是个循环链表，head即最先进入的那一路，tail即最后进入的那一路
                                                         // [WAY_CNT-1 : 0]用作指针指向链表的下一个节点，即记录下一路的编号
    reg [  WAY_CNT-1 :0] FIFO_count [SET_SIZE]; // 每个SET一个计数器，判断是否所有cache line都有填满
    reg [  WAY_CNT-1 :0] FIFO_head  [SET_SIZE]; // 链表头指针，记录链表第一个节点对应的那一路的编号
    reg [  WAY_CNT-1 :0] FIFO_tail  [SET_SIZE]; // 链表尾指针，记录链表最后一个节点对应的那一路的编号
    /*********************************************************************************************/
    /* 2. LRU策略 */
    reg [2*WAY_CNT-1 :0] LRU_way   [SET_SIZE][WAY_CNT]; // 每个SET都有自己的LRU顺序，用数组来代替链表进行记录。数组每个元素对应一路，按照被替换的优先级排列
                                                        // 每当有一路被访问，将该路移到链表末尾，即在链表中删除对应节点，并将该节点移动到链表末尾
                                                        // 因为删除节点涉及到将上一节点指针指向下一节点，必须用双向链表
                                                        // head即最久未访问的那一路，tail即最近访问的那一路
                                                        // [2*WAY_CNT-1 : WAY_CNT]用作指针指向链表的上一个节点
                                                        // [WAY_CNT-1 : 0]用作指针指向链表的下一个节点
    reg [  WAY_CNT-1 :0] LRU_count [SET_SIZE]; // 每个SET一个计数器，判断是否所有cache line都有填满
    reg [  WAY_CNT-1 :0] LRU_head  [SET_SIZE]; // 链表头指针，记录链表第一个节点对应的那一路的编号
    reg [  WAY_CNT-1 :0] LRU_tail  [SET_SIZE]; // 链表尾指针，记录链表最后一个节点对应的那一路的编号
    /*********************************************************************************************/

    /* cache状态机 */
    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            // 状态机复位
            cache_stat <= IDLE; // 默认复位为就绪状态
            for(integer i=0; i<SET_SIZE; i++) begin
                for(integer j=0; j<WAY_CNT; j++) begin
                    dirty[i][j] <= 1'b0;
                    valid[i][j] <= 1'b0;
                end
            end
            for(integer k=0; k<LINE_SIZE; k++) begin
                mem_wr_line[k] <= 0;
            end
            mem_wr_addr <= 0;
            {mem_rd_tag_addr, mem_rd_set_addr} <= 0; // 本质是mem_rd_addr <= 0，但mem_rd_addr是wire，所以只能这样写
            rd_data <= 0;
            

            /*给不同替换策略对应的中间变量赋初值*/
            /*********************************************************************************************/
            /* 1.FIFO *//*
            for(integer i=0; i<SET_SIZE; i++) begin
                FIFO_count[i] <= 0;
                FIFO_head[i]  <= 0;
                FIFO_tail[i]  <= 0;
                for(integer j=0; j<WAY_CNT; j++) begin
                    FIFO_way[i][j] <= 0;
                end
            end
            /*********************************************************************************************/
            /* 2. LRU策略 */
            for(integer i=0; i<SET_SIZE; i++) begin
                LRU_count[i] <= 0;
                LRU_head[i]  <= 0;
                LRU_tail[i]  <= 0;
                for(integer j=0; j<WAY_CNT; j++) begin
                    LRU_way[i][j] <= 0;
                end
            end
            /*********************************************************************************************/

        end 
        else begin
            case(cache_stat)
                IDLE: begin
                    if(|cache_hit) begin // 如果cache命中，则必然有且仅有一个cache_hit_way==1，否则全0，所以用按位与

                        if(rd_req) begin      // 如果cache命中，并且是读请求，
                            rd_data <= cache_mem[set_addr][way_hit][line_addr];   //则直接从cache中取出要读的数据
                        end 
                        else if(wr_req) begin // 如果cache命中，并且是写请求，
                            cache_mem[set_addr][way_hit][line_addr] <= wr_data;   // 则直接向cache中写入数据
                            dirty[set_addr][way_hit] <= 1'b1;                     // 写数据的同时置脏位                   
                        end

                        /*********************************************************************************************/
                        /* 2. LRU策略：cache命中时需要更新链表顺序 */

                        // 从链表中删除被访问的节点
                        if(LRU_count[set_addr] > 1 && way_hit != LRU_tail[set_addr]) begin // 链表必须大于1个节点，同时不是被访问的不是尾节点，才有更新的必要
                                                                                           // 0个节点：不可能命中  1个节点：即访问尾节点，没有必要更新
                            if(way_hit == LRU_head[set_addr]) begin // 如果被访问的是首节点，即删去首节点
                                LRU_head[set_addr] <= LRU_way[set_addr][LRU_head[set_addr]][WAY_CNT-1 : 0]; // 头指针指向下一节点
                            end
                            else begin
                                // previous_way = LRU_way[set_addr][way_hit][2*WAY_CNT-1 : WAY_CNT]
                                // next_way     = LRU_way[set_addr][way_hit][WAY_CNT-1 : 0]
                                // LRU_way[set_addr][previous_way][WAY_CNT-1 : 0] <= next_way
                                LRU_way[set_addr][LRU_way[set_addr][way_hit][2*WAY_CNT-1 : WAY_CNT]][WAY_CNT-1 : 0] 
                                    <= LRU_way[set_addr][way_hit][WAY_CNT-1 : 0];
                            end
                        end

                        // 将被访问的节点添加到链表末尾
                        LRU_way[set_addr][LRU_tail[set_addr]][WAY_CNT-1 : 0] <= way_hit; // 原先的尾节点的下一节点指向该节点
                        LRU_way[set_addr][way_hit][2*WAY_CNT-1 : WAY_CNT] <= LRU_tail[set_addr]; // 该节点的上一节点为原尾节点
                        LRU_tail[set_addr] <= way_hit; // 尾指针指向该节点

                        /*********************************************************************************************/

                    end 
                    else begin
                        if(wr_req | rd_req) begin   // 如果 cache 未命中，并且有读写请求，则需要进行换入
                            
                            /*这里有替换策略选择问题*/
                            /*********************************************************************************************/
                            /* 1. FIFO策略 *//*
                            if(FIFO_count[set_addr] < WAY_CNT) begin // 该set未填满，直接换入，同时扩展链表
                                
                                cache_stat <= SWAP_IN; // 转换为 换入 状态

                                FIFO_way[set_addr][FIFO_count[set_addr]][WAY_CNT-1 : 0] 
                                    <= (FIFO_count[set_addr] == WAY_CNT - 1)? FIFO_head[set_addr] : FIFO_count[set_addr] + 1; // 指针指向下一路，循环链表
                                FIFO_tail[set_addr]  <= FIFO_count[set_addr];        // 链表尾指针更新
                                FIFO_count[set_addr] <= FIFO_count[set_addr] + 1'b1; // 计数器加一

                            end
                            else begin // 该set填满
                                
                                if(dirty[set_addr][FIFO_head[set_addr]]) begin // 要被换入的cache line脏，则要先换出
                                    cache_stat  <= SWAP_OUT; // 转换为 换出 状态
                                    mem_wr_addr <= {cache_tags[set_addr][FIFO_head[set_addr]], set_addr}; // 取出头指针指向那一路的数据
                                    mem_wr_line <= cache_mem[set_addr][FIFO_head[set_addr]];
                                end
                                else // 不脏，直接换入
                                    cache_stat  <= SWAP_IN; // 转换为 换入 状态                              

                                // 更新链表，头指针指向下一节点，当前头指针指向的节点变为尾节点
                                FIFO_head[set_addr] <= FIFO_way[set_addr][FIFO_head[set_addr]][WAY_CNT-1 : 0]; // 头指针指向下一节点，即当前头节点的指针
                                FIFO_tail[set_addr] <= FIFO_head[set_addr]; //尾指针更新为当前的节点

                            end
                            /*********************************************************************************************/
                            /* 2. LRU策略 */
                            if(LRU_count[set_addr] < WAY_CNT) begin // 该set未填满，直接换入，同时扩展链表，新节点应该加在tail之后

                                cache_stat <= SWAP_IN; // 转换为 换入 状态

                                LRU_way[set_addr][LRU_count[set_addr]][2*WAY_CNT-1 : WAY_CNT] <= LRU_tail[set_addr]; // 上一节点是尾节点（对于第一个节点，无所谓其上一个节点）
                                LRU_way[set_addr][LRU_count[set_addr]][WAY_CNT-1 : 0] <= LRU_count[set_addr] + 1'b1; // 未填满，下一节点一定是下一条路
                                LRU_tail[set_addr]  <= LRU_count[set_addr];        // 链表尾指针更新
                                LRU_count[set_addr] <= LRU_count[set_addr] + 1'b1; // 计数器加一

                            end
                            else begin // 该set填满

                                if(dirty[set_addr][LRU_head[set_addr]]) begin // 要被换入的cache line脏，则要先换出
                                    cache_stat  <= SWAP_OUT; // 转换为 换出 状态
                                    mem_wr_addr <= {cache_tags[set_addr][LRU_head[set_addr]], set_addr}; // 取出头指针指向那一路的数据
                                    mem_wr_line <= cache_mem[set_addr][LRU_head[set_addr]];
                                end
                                else // 不脏，直接换入
                                    cache_stat  <= SWAP_IN; // 转换为 换入 状态

                                // 更新链表，头指针指向下一节点，当前头指针指向的节点变为尾节点
                                LRU_head[set_addr] <= LRU_way[set_addr][LRU_head[set_addr]][WAY_CNT-1 : 0]; // 头指针指向下一节点
                                LRU_way[set_addr][LRU_tail[set_addr]][WAY_CNT-1 : 0] <= LRU_head[set_addr]; // 原先的尾节点的下一节点指向该节点
                                LRU_way[set_addr][LRU_head[set_addr]][2*WAY_CNT-1 : WAY_CNT] <= LRU_tail[set_addr]; // 该节点的上一节点为原尾节点
                                LRU_tail[set_addr] <= LRU_head[set_addr]; //尾指针更新为当前的节点

                            end
                            /*********************************************************************************************/

                            {mem_rd_tag_addr, mem_rd_set_addr} <= {tag_addr, set_addr}; //因为要换入，所以mem_rd要设定值

                        end
                    end
                end
                SWAP_OUT: begin
                    if(mem_gnt) begin           // 如果主存握手信号有效，说明换出成功，跳到下一状态
                        cache_stat <= SWAP_IN;
                    end
                end
                SWAP_IN: begin
                    if(mem_gnt) begin           // 如果主存握手信号有效，说明换入成功，跳到下一状态
                        cache_stat <= SWAP_IN_OK;
                    end
                end
                SWAP_IN_OK: begin               // 上一个周期换入成功，这周期将主存读出的line写入cache，并更新tag，置高valid，置低dirty
                    cache_stat <= IDLE;        // 回到就绪状态

                    /*********************************************************************************************/
                    /* 1. FIFO策略 *//*
                    for(integer i=0; i<LINE_SIZE; i++)  
                        cache_mem[mem_rd_set_addr][FIFO_tail[set_addr]][i] <= mem_rd_line[i]; // 换入到尾节点
                    cache_tags[mem_rd_set_addr][FIFO_tail[set_addr]] <= mem_rd_tag_addr;
                    valid     [mem_rd_set_addr][FIFO_tail[set_addr]] <= 1'b1;
                    dirty     [mem_rd_set_addr][FIFO_tail[set_addr]] <= 1'b0;
                    /*********************************************************************************************/
                    /* 2. LRU策略 */
                    for(integer i=0; i<LINE_SIZE; i++)  
                        cache_mem[mem_rd_set_addr][LRU_tail[set_addr]][i] <= mem_rd_line[i]; // 换入到尾节点
                    cache_tags[mem_rd_set_addr][LRU_tail[set_addr]] <= mem_rd_tag_addr;
                    valid     [mem_rd_set_addr][LRU_tail[set_addr]] <= 1'b1;
                    dirty     [mem_rd_set_addr][LRU_tail[set_addr]] <= 1'b0;
                    /*********************************************************************************************/

                end
            endcase
        end
    end

    wire mem_rd_req = (cache_stat == SWAP_IN ); // 主存读请求信号（换入）
    wire mem_wr_req = (cache_stat == SWAP_OUT); // 主存写请求信号（换出）
    wire [   MEM_ADDR_LEN-1 :0] mem_addr = mem_rd_req ? mem_rd_addr : ( mem_wr_req ? mem_wr_addr : 0);

    assign miss = (rd_req | wr_req) & ~((|cache_hit) && cache_stat==IDLE) ; // 当有读写请求时，如果cache不处于就绪(IDLE)状态，或者未命中，则miss=1

    main_mem #(     // 主存，每次读写以line 为单位
        .LINE_ADDR_LEN  ( LINE_ADDR_LEN          ),
        .ADDR_LEN       ( MEM_ADDR_LEN           )
    ) main_mem_instance (
        .clk            ( clk                    ),
        .rst            ( rst                    ),
        .gnt            ( mem_gnt                ),
        .addr           ( mem_addr               ),
        .rd_req         ( mem_rd_req             ),
        .rd_line        ( mem_rd_line            ),
        .wr_req         ( mem_wr_req             ),
        .wr_line        ( mem_wr_line            )
    );

endmodule





