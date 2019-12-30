import tippy from "tippy.js"
import ClipboardJS from "clipboard"

function clipboardTooltip(element, message) {
  tippy(element, {
    content: message,
    showOnCreate: true,
    onHidden: (instance) => {
      instance.destroy()
    }
  });
}

document.addEventListener("turbolinks:load", () => {
  tippy(document.querySelectorAll("[data-tippy-content]"))

  // Clipboard buttons should show tooltip showing result
  let clipboard = new ClipboardJS("[data-clipboard-text]")
  clipboard.on("success", (e) => { clipboardTooltip(e.trigger, "Copied!") })
  clipboard.on("error", (e) => { clipboardTooltip(e.trigger, "Failed!") })
})
