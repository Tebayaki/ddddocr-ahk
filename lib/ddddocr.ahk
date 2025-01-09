#Requires AutoHotkey v2.0
/************************************************************************
 * @description ddddocr ahk wrapper
 * @author Tebayaki
 * @version 1.0
 ***********************************************************************/

class DdddOcrDll {
    __New() {
        if !this.Ptr := DllCall("LoadLibraryW", "str", A_LineFile "\..\ddddocr.dll", "ptr")
            throw OSError(, -1)
    }
    __Delete() {
        if this.Ptr
            DllCall("FreeLibrary", "ptr", this)
    }
}

class DdddOcrBase {
    __dll := DdddOcrDll()
    Ptr := unset

    __Delete() {
        if this.Ptr
            DllCall("ddddocr\free_ddddocr", "ptr", this)
    }

    classification(image, png_fix := false) {
        if image is String
            image := FileRead(image, "RAW")
        ocrStr := DllCall("ddddocr\classification", "ptr", this, "ptr", image, "uptr", image.Size, "char", png_fix, "ptr")
        return this.__free_string(ocrStr)
    }

    classification_probability(image, png_fix := false) {
        if image is String
            image := FileRead(image, "RAW")
        if probability := DllCall("ddddocr\classification_probability", "ptr", this, "ptr", image, "uptr", image.Size, "char", png_fix, "ptr") {
            ocrStr := DllCall("ddddocr\get_character_probability_text", "ptr", probability, "ptr")
            DllCall("ddddocr\free_character_probability", "ptr", probability)
            return this.__free_string(ocrStr)
        }
    }

    classification_crop(image, x, y, w, h) {
        if image is String
            image := FileRead(image, "RAW")
        ocrStr := DllCall("ddddocr\classification_crop", "ptr", this, "ptr", image, "uptr", image.Size, "uint", x, "uint", y, "uint", w, "uint", h, "ptr")
        return this.__free_string(ocrStr)
    }

    set_ranges(text) {
        DllCall("ddddocr\set_ranges", "ptr", this, "ptr", __utf8(text))

        static __utf8(str) {
            buf := Buffer(StrPut(str, "utf-8"))
            StrPut(str, buf, "utf-8")
            return buf
        }
    }

    detection(image) {
        if image is String
            image := FileRead(image, "RAW")
        if bbox_vec := DllCall("ddddocr\detection", "ptr", this, "ptr", image, "uptr", image.Size, "ptr") {
            len := DllCall("ddddocr\get_bbox_vec_len", "ptr", bbox_vec, "uptr")
            bbox_arr := []
            buf := Buffer(16)
            loop len {
                DllCall("ddddocr\get_bbox_vec_index", "ptr", bbox_vec, "uptr", A_Index - 1, "ptr", buf)
                bbox_arr.Push({
                    x1: NumGet(buf, 0, "uint"),
                    y1: NumGet(buf, 4, "uint"),
                    x2: NumGet(buf, 8, "uint"),
                    y2: NumGet(buf, 12, "uint"),
                })
            }
            DllCall("ddddocr\free_bbox_vec", "ptr", bbox_vec)
            return bbox_arr
        }
    }

    __free_string(ocrStr) {
        if ocrStr {
            str := StrGet(ocrStr, "utf-8")
            DllCall("ddddocr\free_string", "ptr", ocrStr)
            return str
        }
    }
}

class DdddOcr extends DdddOcrBase {
    __New() {
        if !this.Ptr := DllCall("ddddocr\init_classification", "ptr")
            throw Error("Initialization failure", -1)
    }
}

class DdddOcrOld extends DdddOcrBase {
    __New() {
        if !this.Ptr := DllCall("ddddocr\init_classification_old", "ptr")
            throw Error("Initialization failure", -1)
    }
}

class DdddOcrDetection extends DdddOcrBase {
    __New() {
        if !this.Ptr := DllCall("ddddocr\init_detection", "ptr")
            throw Error("Initialization failure", -1)
    }
}

class DdddOcrSlideMatch {
    __dll := DdddOcrDll()

    slide_match(target_image, background_image) {
        return this.__match_method("slide_match")(target_image, background_image)
    }

    simple_slide_match(target_image, background_image) {
        return this.__match_method("simple_slide_match")(target_image, background_image)
    }

    slide_comparison(target_image, background_image) {
        return this.__match_method("slide_comparison")(target_image, background_image)
    }

    __match_method(method) {
        return fn
        fn(target_image, background_image) {
            if target_image is String
                target_image := FileRead(target_image, "RAW")
            if background_image is String
                background_image := FileRead(background_image, "RAW")
            slide_bbox := Buffer(20)
            if result := DllCall("ddddocr\" method, "ptr", target_image, "uptr", target_image.Size, "ptr", background_image, "uptr", background_image.Size, "ptr", slide_bbox, "int") {
                return {
                    target_y: NumGet(slide_bbox, 0, "uint"),
                    x1: NumGet(slide_bbox, 4, "uint"),
                    y1: NumGet(slide_bbox, 8, "uint"),
                    x2: NumGet(slide_bbox, 12, "uint"),
                    y2: NumGet(slide_bbox, 16, "uint"),
                }
            }
        }
    }
}

class DdddOcrWithModelCharset extends DdddOcrBase {
    __New(model, charset) {
        if model is String
            model := FileRead(model, "RAW")
        if charset is String
            charset := FileRead(charset, "RAW")
        if !this.Ptr := DllCall("ddddocr\with_model_charset", "ptr", model, "uptr", model.Size, "ptr", charset, "uptr", charset.Size, "ptr")
            throw Error("Initialization failure", -1)
    }
}