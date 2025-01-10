#Include ../ddddocr.ahk

; 验证码识别
ocr := DdddOcr()
loop files "img/ocr_*.jpg", "F" {
    result := ocr.classification(A_LoopFilePath)
    show_ocr_result(A_LoopFilePath, result)
}

; 限定识别字符范围，准确度可能有一定程度的提升
ocr := DdddOcr()
; 只识别数字和字母
ocr.set_ranges("1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
loop files "img/ocr_*.jpg", "F" {
    result := ocr.classification_probability(A_LoopFilePath)
    show_ocr_result(A_LoopFilePath, result)
}

show_ocr_result(image, result) {
    ui := Gui()
    ui.SetFont("S20")
    ui.AddPicture(, image)
    ui.AddText(, result)
    ui.Show()
    WinWaitClose(ui)
    ui.Destroy()
}