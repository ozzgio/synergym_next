// Enhanced form handling component
export default class Form {
  constructor(formSelector, options = {}) {
    this.form = document.querySelector(formSelector)
    this.options = {
      validateOnBlur: true,
      validateOnChange: false,
      submitOnEnter: true,
      showValidationErrors: true,
      ...options
    }
    
    this.validators = {}
    this.init()
  }
  
  init() {
    if (!this.form) return
    
    this.form.addEventListener('submit', (e) => this.handleSubmit(e))
    
    if (this.options.validateOnBlur) {
      this.form.querySelectorAll('input, select, textarea').forEach(field => {
        field.addEventListener('blur', () => this.validateField(field))
      })
    }
    
    if (this.options.validateOnChange) {
      this.form.querySelectorAll('input, select, textarea').forEach(field => {
        field.addEventListener('input', () => this.validateField(field))
      })
    }
  }
  
  addValidator(fieldName, validatorFn) {
    this.validators[fieldName] = validatorFn
  }
  
  validateField(field) {
    const fieldName = field.name
    const value = field.value.trim()
    const validator = this.validators[fieldName]
    
    if (!validator) return true
    
    const result = validator(value)
    this.showFieldValidation(field, result)
    
    return result.valid
  }
  
  showFieldValidation(field, result) {
    const errorElement = field.parentNode.querySelector('.field-error')
    
    if (result.valid) {
      field.classList.remove('border-red-500')
      field.classList.add('border-green-500')
      
      if (errorElement) {
        errorElement.remove()
      }
    } else {
      field.classList.remove('border-green-500')
      field.classList.add('border-red-500')
      
      if (this.options.showValidationErrors) {
        if (!errorElement) {
          const errorDiv = document.createElement('div')
          errorDiv.className = 'field-error text-red-500 text-sm mt-1'
          field.parentNode.appendChild(errorDiv)
        }
        
        const errorElement = field.parentNode.querySelector('.field-error')
        errorElement.textContent = result.message
      }
    }
  }
  
  validateForm() {
    let isValid = true
    
    this.form.querySelectorAll('input, select, textarea').forEach(field => {
      if (!this.validateField(field)) {
        isValid = false
      }
    })
    
    return isValid
  }
  
  handleSubmit(e) {
    if (!this.validateForm()) {
      e.preventDefault()
      return false
    }
    
    // Custom submit handling can be added here
    if (this.options.onSubmit) {
      e.preventDefault()
      this.options.onSubmit(this.form)
    }
  }
  
  reset() {
    this.form.reset()
    this.form.querySelectorAll('input, select, textarea').forEach(field => {
      field.classList.remove('border-red-500', 'border-green-500')
      const errorElement = field.parentNode.querySelector('.field-error')
      if (errorElement) errorElement.remove()
    })
  }
  
  destroy() {
    this.form.removeEventListener('submit', this.handleSubmit)
    this.form.querySelectorAll('input, select, textarea').forEach(field => {
      field.removeEventListener('blur', this.validateField)
      field.removeEventListener('input', this.validateField)
    })
  }
}

// Common validation functions
export const Validators = {
  required: (message = 'This field is required') => (value) => ({
    valid: value.length > 0,
    message
  }),
  
  email: (message = 'Please enter a valid email address') => (value) => ({
    valid: /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value),
    message
  }),
  
  minLength: (min, message) => (value) => ({
    valid: value.length >= min,
    message: message || `Must be at least ${min} characters`
  }),
  
  maxLength: (max, message) => (value) => ({
    valid: value.length <= max,
    message: message || `Must be no more than ${max} characters`
  }),
  
  password: (message = 'Password must be at least 8 characters with letters and numbers') => (value) => ({
    valid: value.length >= 8 && /[a-zA-Z]/.test(value) && /[0-9]/.test(value),
    message
  })
}