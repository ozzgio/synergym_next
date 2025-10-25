// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Import our component system
import { Dropdown, Modal, Form, Notification } from "components"

// Make components available globally
window.Dropdown = Dropdown
window.Modal = Modal
window.Form = Form
window.Notification = Notification

// Initialize global components when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  // Initialize notification system
  window.notifications = new Notification()
  
  // Initialize dropdowns
  const userDropdown = new Dropdown('#user-menu-button', '#user-dropdown')
  const mobileMenu = new Dropdown('#mobile-menu-button', '#mobile-menu')
  
  // Initialize form validation on authentication forms only
  const signUpForm = document.querySelector('form[action*="/users"][method="post"]')
  if (signUpForm) {
    const formValidator = new Form('form[action*="/users"][method="post"]', {
      validateOnBlur: true,
      showValidationErrors: true
    })
    
    // Add validators
    formValidator.addValidator('user[email]', Form.Validators.email())
    formValidator.addValidator('user[password]', Form.Validators.password())
  }
  
  const signInForm = document.querySelector('form[action*="/users/sign_in"]')
  if (signInForm) {
    const formValidator = new Form('form[action*="/users/sign_in"]', {
      validateOnBlur: true,
      showValidationErrors: true
    })
    
    formValidator.addValidator('user[email]', Form.Validators.email())
    formValidator.addValidator('user[password]', Form.Validators.required())
  }
  
  // Add validation for password reset forms
  const passwordResetForm = document.querySelector('form[action*="/password"]')
  if (passwordResetForm) {
    const formValidator = new Form('form[action*="/password"]', {
      validateOnBlur: true,
      showValidationErrors: true
    })
    
    formValidator.addValidator('user[email]', Form.Validators.email())
  }
})
