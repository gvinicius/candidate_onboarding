import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.poll()
  }

  disconnect() {
    clearTimeout(this.timer)
  }

  poll() {
    this.timer = setTimeout(() => this.check(), 3000)
  }

  async check() {
    try {
      const response = await fetch(this.urlValue, {
        headers: { Accept: "application/json" }
      })
      const data = await response.json()

      if (data.status === "completed") {
        window.location.href = data.redirect_url
      } else if (data.status === "failed") {
        window.location.reload()
      } else {
        this.poll()
      }
    } catch {
      this.poll()
    }
  }
}
