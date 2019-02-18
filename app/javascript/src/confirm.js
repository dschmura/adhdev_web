// Custom TailwindCSS modals for confirm dialogs

const old_confirm = Rails.confirm;
const createConfirmModal = (element) => {
  var id = 'confirm-modal-' + String(Math.random()).slice(2, -1);
  var title = "Are you sure?"
  var confirm = "Are you sure?"

  var content = `
    <div id="${id}" class="animated fadeIn fixed z-50 pin-t pin-l w-full h-full table" style="background-color: rgba(0, 0, 0, 0.8);">
      <div class="table-cell align-middle">

        <div class="bg-white mx-auto rounded shadow p-8 max-w-sm">
          <h4>${confirm}</h4>

          <div class="flex justify-end items-center flex-wrap mt-6">
            <button data-behavior="cancel" class="btn btn-white primary mr-2">Cancel</button>
            <button data-behavior="commit" class="btn btn-danger">Confirm</button>
          </div>
        </div>
      </div>
    </div>
  `

  element.insertAdjacentHTML('afterend', content)

  var modal = element.nextElementSibling
  console.log(modal)
  element.dataset.confirmModal = `#${id}`

  modal.querySelector("[data-behavior='cancel']").addEventListener("click", (event) => {
    event.preventDefault()
    element.removeAttribute("data-confirm-modal")
    modal.remove()
  })
  modal.querySelector("[data-behavior='commit']").addEventListener("click", (event) => {
    event.preventDefault()

    // Allow the confirm to go through
    Rails.confirm = () => { return true }

    // Click the link again
    element.click()

    // Remove the confirm attribute and modal
    element.removeAttribute("data-confirm-modal")
    Rails.confirm = old_confirm

    modal.remove()
  })

  return modal
}

// Checks if confirm modal is open
const confirmModalOpen = (element) => {
  console.log(element.dataset.confirmModal)
  return !!element.dataset.confirmModal;
}

const handleConfirm = (event) => {
  // If there is a modal open, let the second confirm click through
  if (confirmModalOpen(event.target)) {
    return true

  // First click, we need to spawn the modal
  } else {
    createConfirmModal(event.target)
    return false
  }
}

const elements = ['a[data-confirm]', 'button[data-confirm]', 'input[type=submit][data-confirm]']
Rails.delegate(document, elements.join(', '), 'confirm', handleConfirm)
