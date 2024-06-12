## 文件夹目录

> **0_SingleCycleLab** Verilog源代码
> 
> > **1_CPUCore_src** 单周期CPU core的verilog参考代码
> > 
> > **2_Simulation** 仿真用testBench代码及测试文件
> 
> **1_PipelineLab** Verilog源代码  
> 
> > **1_CPUCore_src** 四级流水线CPU core的verilog参考代码  
> > **2_Simulation** 仿真用testBench代码及测试文件  
> 
> **2_BRAMInputFileGenerator** 脚本文件，利用汇编文件生成对应的16进制指令流文件
> 
> **3_CacheLab** Lab3所需的verilog代码和单元测试文件，详情见文件夹readme 
> 
> **4_ProjectDesignFiles** 包含CPU的流水线模块设计图 
> **5_DetailDocuments** 包含Lab1、Lab2和Lab3共三次实验的具体要求以及相关参考资料 



## 实验平台

Vivado 2017.4 

实验可使用的FPGA型号参考如下，也可自行设置合适的FPGA进行实验

    xc7a12ticsg325-1L、xa7a50tcpg236-2l 等



## 实验内容与要求

本次实验总共分为三个Lab，分别实现RV31I单周期CPU（Lab1）、RV31I四级流水线CPU（Lab2）与带缓存的RV31I四级流水线CPU（Lab3）。

四级流水线的设计可参考文献《Near-Threshold_RISC-V_Core_With_DSP_Extensions_for_Scalable_IoT_Endpoint_Devices》（在**5_DetailDocuments**中已给出），我们所提供的代码框架实现的是五级流水线中“MEM阶段”与“WB阶段”两个阶段的合并，你也可以自行设计新的四级流水线，并在报告中说明。

RV31I单周期CPU（Lab1）与RV31I四级流水线CPU（Lab2）的Verilog代码框架在**0_SingleCycleLab**与**1_PipelineLab**已经给出，你可以参考该框架内容进行补充完成设计，也可以根据自己的理解进行新的代码设计实现所需功能即可。关于带缓存的RV31I四级流水线CPU（Lab3），请基于你所完成的四级流水线CPU进行设计，cache的代码也在**3_CacheLab**给出，你可以在此基础上进行修改，也可以自行设计实现。

实验报告请分为Lab1、Lab2以及Lab3三个报告。由于Lab3的实验分为两个阶段，请将两个实验阶段的报告整合在一起，因此    Lab3的报告的内容应包含cache实验报告（cache的实现和独立测试）与带cache的四级流水线CPU实验报告（其中需要包含Lab1、Lab2和Lab3三个CPU的性能等对比分析），具体的要求详见**5_DetailDocuments**文档。



## 其他事项

大作业为1-2人一组，每个组上交一份大作业（代码和实验报告全部打包上交）即可。

**作业提交时间节点**：

    Lab1：2023年4月16日（春学期第7周）

    Lab2：2023年5月14日（夏学期第3周）

    Lab3：2023年6月18日（夏学期第8周）

**关于创新性**：上述为大作业实验的基本要求，我们鼓励大家对自己的CPU添加更多的指令或功能、考虑提升CPU的性能等并进行实现，或者有好的想法也可以在实验报告中进行描述。如有其他问题，可联系助教。
