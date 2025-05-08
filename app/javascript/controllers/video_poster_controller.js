import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["video"]

  connect() {
    if (this.hasVideoTarget) {
      this.videoTarget.addEventListener('loadeddata', this.checkFrame.bind(this))
    }
  }

  disconnect() {
    if (this.hasVideoTarget) {
      this.videoTarget.removeEventListener('loadeddata', this.checkFrame.bind(this))
    }
  }

  checkFrame() {
    const video = this.videoTarget
    const timestamps = [1, 2, 3] // The timestamps we want to try
    let currentIndex = 0

    const checkNextFrame = () => {
      if (currentIndex >= timestamps.length) {
        // If we've tried all timestamps and none worked, just use the first one
        video.currentTime = 1
        return
      }

      video.currentTime = timestamps[currentIndex]
      currentIndex++

      // Create a canvas to analyze the frame
      const canvas = document.createElement('canvas')
      canvas.width = video.videoWidth
      canvas.height = video.videoHeight
      const ctx = canvas.getContext('2d')
      ctx.drawImage(video, 0, 0, canvas.width, canvas.height)

      // Get the image data
      const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height)
      const data = imageData.data

      // Check if the frame is mostly black or empty
      let totalBrightness = 0
      for (let i = 0; i < data.length; i += 4) {
        // Calculate brightness using RGB values
        const brightness = (data[i] + data[i + 1] + data[i + 2]) / 3
        totalBrightness += brightness
      }
      const averageBrightness = totalBrightness / (data.length / 4)

      // If the frame is too dark (average brightness < 20), try the next timestamp
      if (averageBrightness < 20) {
        checkNextFrame()
      } else {
        // We found a good frame, set it as the poster
        video.poster = canvas.toDataURL()
      }
    }

    checkNextFrame()
  }
} 