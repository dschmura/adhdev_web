document.addEventListener("turbo:load", ()=> {

  const Forms = {
    init() {
      this.fileInputToggle();
    },

    fileInputToggle() {
      const inputs = document.querySelectorAll('.form-file');

      inputs.forEach(function(input) {
        const label  = input.nextElementSibling,
        labelVal = label.innerHTML;

        input.addEventListener('change', function(e) {
          var fileName = '';

          if (this.files && this.files.length > 1) {
            fileName = ( this.getAttribute( 'data-multiple-caption' ) || '' ).replace( '{count}', this.files.length );
          } else {
            fileName = e.target.value.split( '\\' ).pop();
          }

          if (fileName) {
            label.querySelector( 'span' ).innerHTML = fileName;
          } else {
            label.innerHTML = labelVal;
          }
        });
      });
    }
  };

  Forms.init();

});
