import Trix from "trix"

let lang = Trix.config.lang;

Trix.config.textAttributes.inlineCode = {
  tagName: "code",
  inheritable: true
}

Trix.config.toolbar = {
  getDefaultHTML: function() {
    return `
    <div class="trix-button-row">
      <span class="trix-button-group trix-button-group--text-tools" data-trix-button-group="text-tools">
        <button type="button" class="trix-button trix-button--icon trix-button--icon-bold" data-trix-attribute="bold" data-trix-key="b" title="${lang.bold}" tabindex="-1">${lang.bold}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-italic" data-trix-attribute="italic" data-trix-key="i" title="${lang.italic}" tabindex="-1">${lang.italic}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-strike" data-trix-attribute="strike" title="${lang.strike}" tabindex="-1">${lang.strike}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-link" data-trix-attribute="href" data-trix-action="link" data-trix-key="k" title="${lang.link}" tabindex="-1">${lang.link}</button>
      </span>
      <span class="trix-button-group trix-button-group--block-tools" data-trix-button-group="block-tools">
        <button type="button" class="trix-button trix-button--icon trix-button--icon-heading-1" data-trix-attribute="heading1" title="${lang.heading1}" tabindex="-1">${lang.heading1}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-quote" data-trix-attribute="quote" title="${lang.quote}" tabindex="-1">${lang.quote}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-code" data-trix-attribute="code" title="${lang.code}" tabindex="-1">${lang.code}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-bullet-list" data-trix-attribute="bullet" title="${lang.bullets}" tabindex="-1">${lang.bullets}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-number-list" data-trix-attribute="number" title="${lang.numbers}" tabindex="-1">${lang.numbers}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-decrease-nesting-level" data-trix-action="decreaseNestingLevel" title="${lang.outdent}" tabindex="-1">${lang.outdent}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-increase-nesting-level" data-trix-action="increaseNestingLevel" title="${lang.indent}" tabindex="-1">${lang.indent}</button>
      </span>
      <span class="trix-button-group trix-button-group--file-tools" data-trix-button-group="file-tools">
        <button type="button" class="trix-button trix-button--icon trix-button--icon-attach" data-trix-action="attachFiles" title="${lang.attachFiles}" tabindex="-1">${lang.attachFiles}</button>
      </span>
      <span class="trix-button-group-spacer"></span>
      <span class="trix-button-group trix-button-group--history-tools" data-trix-button-group="history-tools">
        <button type="button" class="trix-button trix-button--icon trix-button--icon-undo" data-trix-action="undo" data-trix-key="z" title="${lang.undo}" tabindex="-1">${lang.undo}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-redo" data-trix-action="redo" data-trix-key="shift+z" title="${lang.redo}" tabindex="-1">${lang.redo}</button>
      </span>
    </div>
    <div class="trix-dialogs" data-trix-dialogs>
      <div class="trix-dialog trix-dialog--link" data-trix-dialog="href" data-trix-dialog-attribute="href">
        <div class="trix-dialog__link-fields">
          <input type="url" name="href" class="trix-input trix-input--dialog" placeholder="${lang.urlPlaceholder}" aria-label="${lang.url}" required data-trix-input>
          <div class="flex">
            <input type="button" class="btn btn-secondary btn-small mr-1" value="${lang.link}" data-trix-method="setAttribute">
            <input type="button" class="btn btn-tertiary outline btn-small" value="${lang.unlink}" data-trix-method="removeAttribute">
          </div>
        </div>
        <div data-behavior="embed_container">
          <div class="link_to_embed link_to_embed--new">
            Would you like to embed media from this site?
            <input class="btn btn-tertiary outline btn-small ml-3" type="button" data-behavior="embed_url" value="Yes, embed it">
          </div>
        </div>
      </div>
    </div>
  `
  }
}

class EmbedController {
  constructor(element) {
    this.patterns = undefined
    this.element = element
    this.editor = element.editor
    this.toolbar = element.toolbarElement
    this.hrefElement = this.toolbar.querySelector("[data-trix-input][name='href']")
    this.embedContainerElement = this.toolbar.querySelector("[data-behavior='embed_container']")
    this.embedElement = this.toolbar.querySelector("[data-behavior='embed_url']")

    this.reset()
    this.installEventHandlers()
  }

  installEventHandlers() {
    this.hrefElement.addEventListener("input", this.didInput.bind(this))
    this.hrefElement.addEventListener("focusin", this.didInput.bind(this))
    this.embedElement.addEventListener("click", this.embed.bind(this))
  }

  didInput(event) {
    let value = event.target.value.trim()

    // Load patterns from server so we can dynamically update them
    if (this.patterns === undefined) {
      this.loadPatterns(value)

    // When patterns are loaded, we can just fetch the embed code
    } else if (this.match(value)) {
      this.fetch(value)

    // No embed code, just reset the form
    } else {
      this.reset()
    }
  }

  loadPatterns(value) {
    Rails.ajax({
      type: "get",
      url: "/action_text/embeds/patterns.json",
      success: (response) => {
        this.patterns = response.map(pattern => new RegExp(pattern.source, pattern.options))
        if (this.match(value)) {
          this.fetch(value)
        }
      }
    })
  }

  // Checks if a url matches an embed code format
  match(value) {
    return this.patterns.some(regex => regex.test(value))
  }

  fetch(value) {
    Rails.ajax({
      url: `/action_text/embeds?id=${encodeURIComponent(value)}`,
      type: 'post',
      error: this.reset.bind(this),
      success: this.showEmbed.bind(this)
    })
  }

  embed(event) {
    if (this.currentEmbed == null) { return }

    let attachment = new Trix.Attachment(this.currentEmbed)
    this.editor.insertAttachment(attachment)
    this.element.focus()
  }

  showEmbed(embed) {
    this.currentEmbed = embed
    this.embedContainerElement.style.display = "block"
  }

  reset() {
    this.embedContainerElement.style.display = "none"
    this.currentEmbed = null
  }
}

class InlineCode {
  constructor(element) {
    this.element = element
    this.editor = element.editor
    this.toolbar = element.toolbarElement

    this.installEventHandlers()
  }

  installEventHandlers() {
    const blockCodeButton = this.toolbar.querySelector("[data-trix-attribute=code]")
    const inlineCodeButton = blockCodeButton.cloneNode(true)

    inlineCodeButton.hidden = true
    inlineCodeButton.dataset.trixAttribute = "inlineCode"
    blockCodeButton.insertAdjacentElement("afterend", inlineCodeButton)

    this.element.addEventListener("trix-selection-change", _ => {
      const type = this.getCodeFormattingType()
      blockCodeButton.hidden = type == "inline"
      inlineCodeButton.hidden = type == "block"
    })
  }

  getCodeFormattingType() {
    if (this.editor.attributeIsActive("code")) return "block"
    if (this.editor.attributeIsActive("inlineCode")) return "inline"

    const range = this.editor.getSelectedRange()
    if (range[0] == range[1]) return "block"

    const text = this.editor.getSelectedDocument().toString().trim()
    return /\n/.test(text) ? "block" : "inline"
  }
}

document.addEventListener("trix-initialize", function(event) {
  new EmbedController(event.target)
  new InlineCode(event.target)
})
