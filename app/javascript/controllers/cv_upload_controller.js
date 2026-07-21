import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropZone", "input", "idle", "selected", "filename", "submitBtn", "apiKeyInput", "eyeOpen", "eyeClosed", "processingMsg"]

  connect() {
    document.addEventListener("dragover", (e) => e.preventDefault())
  }

  openPicker(event) {
    if (event.target !== this.inputTarget) {
      this.inputTarget.click()
    }
  }

  dragOver(event) {
    event.preventDefault()
    this.dropZoneTarget.classList.add("border-slate-400", "bg-slate-50")
  }

  dragLeave() {
    this.dropZoneTarget.classList.remove("border-slate-400", "bg-slate-50")
  }

  drop(event) {
    event.preventDefault()
    this.dragLeave()
    const file = event.dataTransfer.files[0]
    if (file) {
      const dataTransfer = new DataTransfer()
      dataTransfer.items.add(file)
      this.inputTarget.files = dataTransfer.files
      this.showSelected(file.name)
    }
  }

  fileSelected() {
    const file = this.inputTarget.files[0]
    if (file) this.showSelected(file.name)
  }

  showSelected(name) {
    this.idleTarget.classList.add("hidden")
    this.selectedTarget.classList.remove("hidden")
    this.filenameTarget.textContent = name
    this.dropZoneTarget.classList.add("border-green-300", "bg-green-50")
  }

  startProcessing() {
    this.submitBtnTarget.disabled = true
    this.submitBtnTarget.value = "Analysing…"
    this.processingMsgTarget.classList.remove("hidden")
  }

  toggleApiKey(event) {
    event.preventDefault()
    const input = this.apiKeyInputTarget
    const isPassword = input.type === "password"
    input.type = isPassword ? "text" : "password"
    this.eyeOpenTarget.classList.toggle("hidden", isPassword)
    this.eyeClosedTarget.classList.toggle("hidden", !isPassword)
  }
}
