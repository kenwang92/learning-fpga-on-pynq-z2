<p align="center">
  <a href="" rel="noopener">
 <img width=200px height=200px src="readme_img\a-lovely-fpga-board.png" alt="Project logo"></a>
</p>

<h3 align="center"> ⚒️ FPGA自學紀錄</h3>

## 📝 Table of Contents

- [📝 Table of Contents](#-table-of-contents)
- [🧐 About ](#-about-)
- [🏁 Getting Started ](#-getting-started-)
  - [注意：必須接上網路線，否則125Mhz晶震會定期重置（已知影響：HDMI、VGA畫面閃爍）](#注意必須接上網路線否則125mhz晶震會定期重置已知影響hdmivga畫面閃爍)
- [🎥Online Tutorial](#online-tutorial)
  - [💯 Tips](#-tips)
- [🦖 TODO ](#-todo-)
- [📚 Prerequisites](#-prerequisites)
- [🎈 Usage ](#-usage-)
- [🚀 Deployment ](#-deployment-)
- [✍️ Authors ](#️-authors-)

## 🧐 About <a name = "about"></a>

起因於想要手搓CPU，不小心跳入FPGA這個大坑，板子使用二手的Pynq-Z2，主控是amd zynq xc7z020，其他板子亦可跟著影片自學，需修改.xdc文件

## 🏁 Getting Started <a name = "getting_started"></a>

### 注意：必須接上網路線，否則125Mhz晶震會定期重置（已知影響：HDMI、VGA畫面閃爍）
此項目保存FPGA自學過程的verilog檔案，盡量用網路上的免費教學影片學習，建議自學者依照以下步驟

1. 完整看完教學(先不要動手寫)
2. 依照腦中對於影片的理解寫出程式碼，可將時序圖使用[Snipaste](https://apps.microsoft.com/detail/9p1wxpkb68kx?hl=zh-TW&gl=TW)貼至視窗頂層邊看邊寫
3. 寫testbench測試功能是否和時序圖相同
4. 比較影片裡的寫法和自己寫的有哪些不同，嘗試自己理解其中差異
5. 使用gemini讀取範例和自己寫的檔案分析差異

## 🎥Online Tutorial
1. [【【零基础轻松学习FPGA】小梅哥Xilinx FPGA基础入门到项目应用培训教程（2024全新课程已上线）】]( https://www.bilibili.com/video/BV1va411c7Dz/?p=71&share_source=copy_web&vd_source=92ad2fc45b572c7e252e58c47b9b68f3)
---
### 💯 Tips
- 已經完成功能的模組，如果要更改，請複製檔案並在檔名標注或是內部註釋寫上改了什麼，否則全部學完容易搞混檔案內容，自己寫的檔名可以寫成XXX_hw.v，表示自己寫的，也讓ai能快速理解檔案用途，不用另外說明檔案內容

- 盡可能多的寫上註釋，註釋表示你對於各個功能的理解，幫助學習也立於後續修改功能
- 想想看某處功能為什麼用組合邏輯or時序邏輯

## 🦖 TODO <a name = "TODO"></a>
- [] 將每個project拿出來仔細解析原理
- [] 基於project延伸

## 📚 Prerequisites
- 需先學習數位邏輯(知道邏輯閘or,and...、進位、D型正反器等)、任一程式語言(了解基本的ifelse等)

## 🎈 Usage <a name="usage"></a>

- `XXX\XXX.srcs\sources_1\new\XXX.v`是各個模組的實現
- `XXX\XXX.srcs\sim_1\new\XXX_tb.v`是testbench(模組在這裡例化並測試)
- `XXX\XXX.srcs\constrs_1\new\XXX.xdc`是引腳分配(要看著板子的datasheet更改腳位編號)
- `XXX\XXX.xpr`是專案檔案，用不同板子需修改此處
<img src="readme_img/where_is_setting.png" width="200" alt="圖片描述">
<img src="readme_img/where_is_proj_dev.png" width="300" alt="圖片描述">

## 🚀 Deployment <a name = "deployment"></a>
要開箱即用請下載Vivado 2025.2，版本不同可能導致ip無法使用，需重新生成(對ip右鍵點擊`Upgrade IP...`)

<img src="readme_img\upgradeIP.png" width="300" alt="圖片描述">

## ✍️ Authors <a name = "authors"></a>

- [@kenwang92](https://github.com/kenwang92)

See also the list of [contributors](https://github.com/kylelobo/The-Documentation-Compendium/contributors) who participated in this project.