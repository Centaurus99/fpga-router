# FPGA-ROUTER

一个四口千兆线速转发 IPv6 路由器，支持 RIPng 路由协议。

在基于 XC7A200T FPGA 的硬件路由器实验板上实现。

实验框架来自 [tanlabs](https://github.com/thu-cs-lab/tanlabs)，参阅：[TanLabs.md](./TanLabs.md)

## 特性

### 硬件部分

- 八级流水线查询转发表，实现四口千兆线速转发
- 硬件资源充分利用，能够同时存储截至 2022 年 9 月的全球共 164419 条 IPv6 路由表项
- 硬件实现的 ND 协议支持
- CPU 实现具有运行 uCore 教学操作系统的能力：
  - 支持完整的 RV32I 指令
  - 指令缓存与分支预测加速运行
  - 支持中断和异常、页表、虚拟地址以及 S 态
- 支持 DMA 数据交互
- Checksum Offload

### 软件部分

- 基于 Tree Bitmap 优化的路由表算法，配合内存动态分配器，大大优化对存储资源的使用
- RIPng 协议的完整支持
- 部分 ICMPv6 协议支持
- 简易的 Profiler

### 功能特色

- 支持串口交互维护路由表
- 支持通过 VGA 显示路由表维护 GUI（与大容量转发表不兼容）
- 支持从 Flash 载入固件
- 用于调试的运行状态指示（队列长度显示、丢包显示、错误代码显示）

## 目录

- `tanlabs`：硬件路由器实验代码
- `firmware`：运行在CPU上的软件（固件）
- `vgacode`：VGA 相关工具
- `asmcode`：硬件部分用到的汇编代码和二进制代码
- `doc`：文档与汇报资料
- `ibert_7series_gtp_1.25G_ex`：1.25Gbps的IBERT测试工具
- `ibert_7series_gtp_6.25G_ex`：6.25Gbps的IBERT测试工具
- `figures`：仅供参考的图片
