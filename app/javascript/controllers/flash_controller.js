import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "message" ]
  static values = { 
    delay: { type: Number, default: 5000 }
  }

  connect() {
    this.messageTargets.forEach(message => {
      setTimeout(() => {
        message.style.transition = "opacity 0.5s"
        message.style.opacity = "0"
        setTimeout(() => {
          message.remove()
        }, 500)
      }, this.delayValue)
    })
  }
}