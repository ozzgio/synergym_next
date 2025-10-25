// Reusable modal component
export default class Modal {
  constructor(triggerSelector, modalSelector, options = {}) {
    this.triggers = document.querySelectorAll(triggerSelector)
    this.modal = document.querySelector(modalSelector)
    this.options = {
      closeOnOutsideClick: true,
      closeOnEscape: true,
      focusTrap: true,
      ...options
    }
    
    this.init()
  }
  
  init() {
    if (!this.modal) return
    
    this.triggers.forEach(trigger => {
      trigger.addEventListener('click', (e) => {
        e.preventDefault()
        this.show()
      })
    })
    
    // Close buttons
    this.modal.querySelectorAll('[data-modal-close]').forEach(closeBtn => {
      closeBtn.addEventListener('click', () => this.hide())
    })
    
    if (this.options.closeOnOutsideClick) {
      this.modal.addEventListener('click', (e) => {
        if (e.target === this.modal) this.hide()
      })
    }
    
    if (this.options.closeOnEscape) {
      document.addEventListener('keydown', (e) => this.handleEscape(e))
    }
  }
  
  show() {
    this.modal.classList.remove('hidden')
    this.modal.setAttribute('aria-hidden', 'false')
    document.body.classList.add('overflow-hidden')
    
    if (this.options.focusTrap) {
      this.trapFocus()
    }
  }
  
  hide() {
    this.modal.classList.add('hidden')
    this.modal.setAttribute('aria-hidden', 'true')
    document.body.classList.remove('overflow-hidden')
    
    if (this.options.focusTrap) {
      this.removeFocusTrap()
    }
  }
  
  handleEscape(e) {
    if (e.key === 'Escape' && !this.modal.classList.contains('hidden')) {
      this.hide()
    }
  }
  
  trapFocus() {
    const focusableElements = this.modal.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    )
    
    if (focusableElements.length > 0) {
      this.firstFocusableElement = focusableElements[0]
      this.lastFocusableElement = focusableElements[focusableElements.length - 1]
      
      this.firstFocusableElement.focus()
      
      this.modal.addEventListener('keydown', (e) => this.handleTabKey(e))
    }
  }
  
  removeFocusTrap() {
    this.modal.removeEventListener('keydown', this.handleTabKey)
  }
  
  handleTabKey(e) {
    if (e.key === 'Tab') {
      if (e.shiftKey) {
        if (document.activeElement === this.firstFocusableElement) {
          this.lastFocusableElement.focus()
          e.preventDefault()
        }
      } else {
        if (document.activeElement === this.lastFocusableElement) {
          this.firstFocusableElement.focus()
          e.preventDefault()
        }
      }
    }
  }
  
  destroy() {
    this.triggers.forEach(trigger => {
      trigger.removeEventListener('click', this.show)
    })
    document.removeEventListener('keydown', this.handleEscape)
    this.removeFocusTrap()
  }
}