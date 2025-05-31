import { codeSamples } from "code_samples"
import { Controller } from "@hotwired/stimulus"

console.log("Banner controller loading...");

export default class extends Controller {
  static targets = ["counter", "codeContent"]

  connect() {
    console.log("Banner controller connected");
    this.initializeCounters()
    // Only initialize code typing if the target exists
    if (this.hasCodeContentTarget) {
      this.initializeCodeTyping()
    }
  }

  initializeCounters() {
    this.counterTargets.forEach(counter => {
      const target = parseInt(counter.getAttribute("data-target"))
      const duration = 2000 // 2 seconds
      const step = target / (duration / 16) // 60fps
      let current = 0

      const updateCounter = () => {
        current += step
        if (current < target) {
          counter.textContent = Math.ceil(current)
          if (counter.getAttribute("data-target") === "98") {
            counter.textContent += "%"
          }
          requestAnimationFrame(updateCounter)
        } else {
          counter.textContent = target
          if (counter.getAttribute("data-target") === "98") {
            counter.textContent += "%"
          }
        }
      }

      // Start counting when element is in viewport
      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            requestAnimationFrame(updateCounter)
            observer.unobserve(entry.target)
          }
        })
      }, { threshold: 0.5 })

      observer.observe(counter)
    })
  }

  initializeCodeTyping() {
    const sample = codeSamples[Math.floor(Math.random() * codeSamples.length)]
    let currentIndex = 0
    let currentLine = 0
    let currentChar = 0
    let isTyping = true

    const typeNextChar = () => {
      if (!isTyping) return

      if (currentLine >= sample.length) {
        isTyping = false
        return
      }

      const line = sample[currentLine]
      if (currentChar === 0) {
        this.codeContentTarget.innerHTML += '<div class="line"></div>'
      }

      const currentLineElement = this.codeContentTarget.lastElementChild
      const char = line[currentChar]
      
      if (char) {
        const span = document.createElement('span')
        span.textContent = char
        
        // Apply syntax highlighting
        if (char === '/' && line[currentChar + 1] === '/') {
          span.className = 'comment'
        } else if (char === '"' || char === "'") {
          span.className = 'string'
        } else if (/[0-9]/.test(char)) {
          span.className = 'number'
        } else if (['function', 'const', 'let', 'var', 'return', 'if', 'else'].includes(line.slice(currentChar).split(' ')[0])) {
          span.className = 'keyword'
        } else if (char === '(' && currentChar > 0) {
          span.className = 'function'
        }
        
        currentLineElement.appendChild(span)
      }

      currentChar++
      if (currentChar >= line.length) {
        currentLine++
        currentChar = 0
      }

      setTimeout(typeNextChar, Math.random() * 50 + 20)
    }

    typeNextChar()
  }
} 