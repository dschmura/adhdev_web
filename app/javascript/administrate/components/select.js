import SlimSelect from 'slim-select'

function bindSelects() {
  document.querySelectorAll("select").forEach(select => {
    new SlimSelect({
      select: select
    })
  });
}

document.addEventListener("turbo:load", function () {
  bindSelects()
})
