import { Controller } from "@hotwired/stimulus"
import { codeSamples } from "../code_samples"

export default class extends Controller {
  static targets = ["counter", "codeContent"]

  connect() {
    this.initializeCounters()
    this.initializeCodeTyping()
  }

  initializeCounters() {
    this.counterTargets.forEach(counter => {
      const target = parseInt(counter.dataset.target)
      const duration = 2000 // 2 seconds
      const step = target / (duration / 16) // 60fps
      let current = 0

      const updateCounter = () => {
        current += step
        if (current < target) {
          counter.textContent = Math.round(current)
          requestAnimationFrame(updateCounter)
        } else {
          counter.textContent = target
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
    const codeElement = this.codeContentTarget
    if (!codeElement) return

    const code = codeSamples.gameExample
    codeElement.textContent = ''
    let index = 0

    const typeCode = () => {
      if (index < code.length) {
        const char = code[index]
        const span = document.createElement('span')
        
        // Apply syntax highlighting
        if (char === '/' && code[index + 1] === '/') {
          span.className = 'comment'
          span.textContent = code.slice(index, code.indexOf('\n', index) + 1)
          index = code.indexOf('\n', index) + 1
        } else if (char === '`') {
          span.className = 'string'
          const endIndex = code.indexOf('`', index + 1) + 1
          span.textContent = code.slice(index, endIndex)
          index = endIndex
        } else if (char === '"' || char === "'") {
          span.className = 'string'
          const endIndex = code.indexOf(char, index + 1) + 1
          span.textContent = code.slice(index, endIndex)
          index = endIndex
        } else if (/\d/.test(char)) {
          span.className = 'number'
          let endIndex = index + 1
          while (/\d/.test(code[endIndex])) endIndex++
          span.textContent = code.slice(index, endIndex)
          index = endIndex
        } else if (/\w/.test(char)) {
          const word = code.slice(index).match(/\w+/)[0]
          if (['const', 'return'].includes(word)) {
            span.className = 'keyword'
          } else if (['push', 'log'].includes(word)) {
            span.className = 'function'
          }
          span.textContent = word
          index += word.length
        } else {
          span.textContent = char
          index++
        }
        
        codeElement.appendChild(span)
        setTimeout(typeCode, Math.random() * 30 + 20)
      }
    }

    // Start typing when code window is in viewport
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          typeCode()
          observer.unobserve(entry.target)
        }
      })
    }, { threshold: 0.5 })

    observer.observe(codeElement.parentElement)
  }
} 