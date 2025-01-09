# DdddOcr AHK封装
### 简介
使用AHK封装的[DdddOcr](https://github.com/sml2h3/ddddocr)，可用于识别验证码和目标检测。  
### 使用
本仓库只包含AHK封装代码，依赖脚本同目录下的`ddddocr.dll`。  
可克隆[86maid/ddddocr](https://github.com/86maid/ddddocr)自行编译，或直接下载编译好的[二进制文件](https://github.com/Tebayaki/ddddocr-ahk/releases)。  
  
##### 识别验证码:  
![](img/ocr_1.jpg)
```autohotkey
ocr := DdddOcr()
image := FileRead("example.jpg", "RAW")
result := ocr.classification(image)
MsgBox(result)
```
##### 检测目标位置:  
![](img/detection_1.jpg)
```autohotkey
det := DdddOcrDetection()
image := FileRead("example.jpg", "RAW")
result := det.detection(image)
for bbox in result
    MsgBox(Format("目标{1}: x1: {2}, y1: {3}, x2: {4}, y2: {5}", A_Index, bbox.x1, bbox.y1, bbox.x2, bbox.y2))
```
##### 识别滑块坑位:  
![](img/slide_target_1.png)
![](img/slide_background_1.jpg)
```autohotkey
det := DdddOcrSlideMatch()
bbox := det.slide_match("target.png", "background.png")
MsgBox(Format("坑位: x1: {1}, y1: {2}, x2: {3}, y2: {4}", bbox.x1, bbox.y1, bbox.x2, bbox.y2))
```
更多使用方法和疑问可参考本仓库的demo以及ddddocr的[使用文档](https://github.com/86maid/ddddocr?tab=readme-ov-file#%E4%BD%BF%E7%94%A8%E6%96%87%E6%A1%A3)。  