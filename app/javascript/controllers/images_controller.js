import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
   /* 静的プロパティを定義（data-{controller}-target で指定したターゲット名） */
   static targets = ["select", "preview", "image_box", "drop", "error"]

   imageSizeOver(file){
      const fileSize = (file.size)/1024
      if(fileSize > 10000){
        return true
      }else{
        return false
      }
   }

   /* 画像ドラッグ時の処理（ドラッグ&ドロップ） */
    dragover(e) {
      e.preventDefault()
      // dragover したときに drop_area の色を変える
      this.dropTarget.classList.remove("bg-gray-50")
      this.dropTarget.classList.add("bg-gray-200")
    }

    dragleave(e) {
      e.preventDefault()
      // dragleave したときに drop_area の色を元に戻す
      this.dropTarget.classList.remove("bg-gray-200")
      this.dropTarget.classList.add("bg-gray-50")
    }

    dropImages(e){
      e.preventDefault()
      // drop した後に drop_area の色を元に戻す
      this.dropTarget.classList.remove("bg-gray-200")
      this.dropTarget.classList.add("bg-gray-50")

      this.errorTarget.textContent = ""
      const uploadedFilesCount = this.previewTarget.querySelectorAll(".image-box").length
      const files = e.dataTransfer.files
      if(files.length + uploadedFilesCount > 3){
        this.errorTarget.textContent = "画像アップロード上限は最大3枚です。"
      }else{
        for(const file of files){
          if(this.imageSizeOver(file)){
            this.errorTarget.textContent = "ファイルサイズの上限(1枚あたり10MB)を超えている画像はアップロードできません。"
          }else{
            this.uploadImage(file)
          }
        }
      }
      this.selectTarget.value = ""
    }


   /* 画像選択時の処理 */
   selectImages(){
    this.errorTarget.textContent = ""
    const uploadedFilesCount = this.previewTarget.querySelectorAll(".image-box").length
    const files = this.selectTargets[0].files
    if(files.length + uploadedFilesCount > 3){
      this.errorTarget.textContent = "画像アップロード上限は最大3枚です。"
    }else{
      for(const file of files){
        if(this.imageSizeOver(file)){
          this.errorTarget.textContent = "ファイルサイズの上限(1枚あたり10MB)を超えている画像はアップロードできません。"
        }else{
          this.uploadImage(file)
        }
      }
    }
    this.selectTarget.value = ""
   }
 
   /* 画像アップロード */
   uploadImage(file){
     const csrfToken = document.getElementsByName('csrf-token')[0].content
     const formData = new FormData()
     formData.append("image", file)
     const options = {
       method: 'POST',
       headers: {
         'X-CSRF-Token': csrfToken
       },
       body: formData
     }
     /* fetchで画像ファイルをitemコントローラー(upload_imageアクション)に送信 */
     fetch("/items/upload_image", options) 
       .then(response => response.json())
       .then(data => {
         this.previewImage(file, data.id)
       })
       .catch((error) => {
         console.error(error);
         this.errorTarget.textContent = "画像のアップロードに失敗しました。";
       });
   }
 
   /* 画像プレビュー */
   previewImage(file, id){
     const preview = this.previewTarget
     const fileReader = new FileReader()
     const setAttr = (element, obj)=>{
       Object.keys(obj).forEach((key)=>{
         element.setAttribute(key, obj[key])
       })
     }
     fileReader.readAsDataURL(file)
     fileReader.onload = (function () {
       const img = new Image()
       const imgBox = document.createElement("div")
       const imgInnerBox = document.createElement("div")
       const deleteBtn = document.createElement("a")
       const hiddenField = document.createElement("input")
       const imgBoxAttr = {
         "class" : "image-box inline-flex mx-1 mb-5",
         "data-controller" : "images",
         "data-images-target" : "image_box",
       }
       const imgInnerBoxAttr = {
         "class" : "text-center"
       }
       const deleteBtnAttr = {
         "class" : "link cursor-pointer",
         "data-action" : "click->images#deleteImage"
       }
       const hiddenFieldAttr = {
         "name" : "item[images][]",
         "style" : "none",
         "type" : "hidden",
         "value" : id,
       }
       setAttr(imgBox, imgBoxAttr)
       setAttr(imgInnerBox, imgInnerBoxAttr)
       setAttr(deleteBtn, deleteBtnAttr)
       setAttr(hiddenField, hiddenFieldAttr)
 
       deleteBtn.textContent = "削除"
 
       imgBox.appendChild(imgInnerBox)
       imgInnerBox.appendChild(img)
       imgInnerBox.appendChild(deleteBtn)
       imgInnerBox.appendChild(hiddenField)
       img.src = this.result
       img.width = 100;
        
       preview.appendChild(imgBox)
     })
   }
 
   /* プレビュー画像の削除 */
   deleteImage(){
     this.image_boxTarget.remove()
   }

}
