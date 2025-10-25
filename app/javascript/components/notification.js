// Notification system for flash messages and custom notifications
export default class Notification {
  constructor(options = {}) {
    this.options = {
      container: '.flash-messages',
      duration: 5000,
      showProgress: true,
      ...options
    }
    
    this.container = document.querySelector(this.options.container)
    this.notifications = []
    
    this.init()
  }
  
  init() {
    if (!this.container) {
      // Create container if it doesn't exist
      this.container = document.createElement('div')
      this.container.className = 'fixed top-20 right-4 z-50 space-y-2 max-w-sm'
      document.body.appendChild(this.container)
    }
  }
  
  show(message, type = 'info', options = {}) {
    const notification = this.createNotification(message, type, options)
    this.container.appendChild(notification)
    this.notifications.push(notification)
    
    // Animate in
    setTimeout(() => {
      notification.classList.remove('translate-x-full', 'opacity-0')
      notification.classList.add('translate-x-0', 'opacity-100')
    }, 10)
    
    // Auto remove
    const duration = options.duration || this.options.duration
    if (duration > 0) {
      setTimeout(() => this.remove(notification), duration)
    }
    
    return notification
  }
  
  success(message, options = {}) {
    return this.show(message, 'success', options)
  }
  
  error(message, options = {}) {
    return this.show(message, 'error', options)
  }
  
  warning(message, options = {}) {
    return this.show(message, 'warning', options)
  }
  
  info(message, options = {}) {
    return this.show(message, 'info', options)
  }
  
  createNotification(message, type, options) {
    const notification = document.createElement('div')
    
    const baseClasses = 'border rounded-md p-4 shadow-sm transition-all duration-300 transform'
    const typeClasses = this.getTypeClasses(type)
    
    notification.className = `${baseClasses} ${typeClasses} translate-x-full opacity-0`
    
    notification.innerHTML = `
      <div class="flex">
        <div class="flex-shrink-0">
          ${this.getTypeIcon(type)}
        </div>
        <div class="ml-3 flex-1">
          <p class="text-sm font-medium">${message}</p>
        </div>
        <div class="ml-auto pl-3">
          <div class="-mx-1.5 -my-1.5">
            <button type="button" class="inline-flex rounded-md p-1.5 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-offset-2">
              <span class="sr-only">Dismiss</span>
              ${this.closeIcon()}
            </button>
          </div>
        </div>
      </div>
      ${this.options.showProgress ? '<div class="mt-2 bg-gray-200 rounded-full h-1"><div class="bg-current h-1 rounded-full notification-progress" style="animation: progress linear"></div></div>' : ''}
    `
    
    // Add close functionality
    const closeBtn = notification.querySelector('button')
    closeBtn.addEventListener('click', () => this.remove(notification))
    
    // Add progress animation
    if (this.options.showProgress) {
      const progressBar = notification.querySelector('.notification-progress')
      const duration = options.duration || this.options.duration
      progressBar.style.animationDuration = `${duration}ms`
    }
    
    return notification
  }
  
  getTypeClasses(type) {
    const classes = {
      success: 'bg-green-50 border-green-200 text-green-800',
      error: 'bg-red-50 border-red-200 text-red-800',
      warning: 'bg-yellow-50 border-yellow-200 text-yellow-800',
      info: 'bg-blue-50 border-blue-200 text-blue-800'
    }
    
    return classes[type] || classes.info
  }
  
  getTypeIcon(type) {
    const icons = {
      success: '<svg class="h-5 w-5 text-green-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" /></svg>',
      error: '<svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" /></svg>',
      warning: '<svg class="h-5 w-5 text-yellow-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" /></svg>',
      info: '<svg class="h-5 w-5 text-blue-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" /></svg>'
    }
    
    return icons[type] || icons.info
  }
  
  closeIcon() {
    return '<svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" /></svg>'
  }
  
  remove(notification) {
    notification.classList.remove('translate-x-0', 'opacity-100')
    notification.classList.add('translate-x-full', 'opacity-0')
    
    setTimeout(() => {
      if (notification.parentNode) {
        notification.parentNode.removeChild(notification)
      }
      const index = this.notifications.indexOf(notification)
      if (index > -1) {
        this.notifications.splice(index, 1)
      }
    }, 300)
  }
  
  clear() {
    this.notifications.forEach(notification => this.remove(notification))
  }
}

// Add CSS animation for progress bar
const style = document.createElement('style')
style.textContent = `
  @keyframes progress {
    from { width: 100%; }
    to { width: 0%; }
  }
`
document.head.appendChild(style)