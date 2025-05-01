import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["error", "preview"]

  connect() {
    console.log("File upload controller connected")
  }

  validate(event) {
    const file = event.target.files[0]
    if (!file) return

    const maxSize = file.type.startsWith('video/') ? 50 * 1024 * 1024 : 5 * 1024 * 1024 // 50MB for videos, 5MB for images
    const validTypes = ['image/jpeg', 'image/png', 'image/gif', 'video/mp4', 'video/webm']

    if (!validTypes.includes(file.type)) {
      this.errorTarget.textContent = "Please upload a valid image (JPEG, PNG, GIF) or video (MP4, WebM) file"
      this.errorTarget.style.display = "block"
      event.target.value = ""
      return false
    }

    if (file.size > maxSize) {
      this.errorTarget.textContent = `File size exceeds the limit (${file.type.startsWith('video/') ? '50MB' : '5MB'})`
      this.errorTarget.style.display = "block"
      event.target.value = ""
      return false
    }

    this.errorTarget.style.display = "none"
    return true
  }

  preview(event) {
    const file = event.target.files[0]
    if (!file) return

    if (!this.validate(event)) return

    const reader = new FileReader()
    const previewContainer = this.previewTarget

    reader.onload = (e) => {
      // Clear the preview container
      previewContainer.innerHTML = ''
      
      if (file.type.startsWith('video/')) {
        const video = document.createElement('video')
        video.src = e.target.result
        video.controls = true
        video.autoplay = true
        video.muted = true
        video.style.width = '100%'
        video.style.height = 'auto'
        previewContainer.appendChild(video)
      } else {
        const img = document.createElement('img')
        img.src = e.target.result
        img.style.maxWidth = '100%'
        img.style.height = 'auto'
        previewContainer.appendChild(img)
      }
    }

    reader.onerror = (error) => {
      console.error('Error reading file:', error)
      this.errorTarget.textContent = "Error reading file. Please try again."
      this.errorTarget.style.display = "block"
    }

    reader.readAsDataURL(file)
  }
} 