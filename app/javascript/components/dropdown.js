// Reusable dropdown component
export default class Dropdown {
  constructor(buttonSelector, dropdownSelector, options = {}) {
    this.button = document.querySelector(buttonSelector)
    this.dropdown = document.querySelector(dropdownSelector)
    this.options = {
      closeOnOutsideClick: true,
      closeOnEscape: true,
      ...options
    }
    
    this.init()
  }
  
  init() {
    if (!this.button || !this.dropdown) return
    
    this.button.addEventListener('click', () => this.toggle())
    
    if (this.options.closeOnOutsideClick) {
      document.addEventListener('click', (e) => this.handleOutsideClick(e))
    }
    
    if (this.options.closeOnEscape) {
      document.addEventListener('keydown', (e) => this.handleEscape(e))
    }
  }
  
  toggle() {
    this.dropdown.classList.toggle('hidden')
    this.button.setAttribute('aria-expanded', 
      this.dropdown.classList.contains('hidden') ? 'false' : 'true'
    )
  }
  
  show() {
    this.dropdown.classList.remove('hidden')
    this.button.setAttribute('aria-expanded', 'true')
  }
  
  hide() {
    this.dropdown.classList.add('hidden')
    this.button.setAttribute('aria-expanded', 'false')
  }
  
  handleOutsideClick(e) {
    if (!this.button.contains(e.target) && !this.dropdown.contains(e.target)) {
      this.hide()
    }
  }
  
  handleEscape(e) {
    if (e.key === 'Escape' && !this.dropdown.classList.contains('hidden')) {
      this.hide()
      this.button.focus()
    }
  }
  
  destroy() {
    this.button.removeEventListener('click', this.toggle)
    document.removeEventListener('click', this.handleOutsideClick)
    document.removeEventListener('keydown', this.handleEscape)
  }
}