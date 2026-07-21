import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]

  toggle() {
    const content = this.contentTarget
    const icon    = this.iconTarget
    const isOpen  = content.style.display !== "none"

    content.style.display = isOpen ? "none" : ""
    icon.style.transform  = isOpen ? "rotate(-90deg)" : ""
  }
}
