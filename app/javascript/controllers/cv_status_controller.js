import { Controller } from "@hotwired/stimulus"

const MAX_POLLS = 60  // 60 × 3s = 3 minutes

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.attempts = 0
    this.poll()
  }

  disconnect() {
    clearTimeout(this.timer)
  }

  poll() {
    this.timer = setTimeout(() => this.check(), 3000)
  }

  async check() {
    this.attempts++

    if (this.attempts > MAX_POLLS) {
      window.location.reload()
      return
    }

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
