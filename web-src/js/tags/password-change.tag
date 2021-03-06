<password-change>
  <div class="settings-container "if={ loggedIn }>
    <div class="subheading">
      <span class="clickable" onclick={ toggle }><span class="glyphicon glyphicon-edit clickable-icon"></span>  Change admin password</span>
    </div>
    <form class="pure-form" if={ showForm } onsubmit={ save }>
      <div class="input-section">
        <label for="old_password">old password:</label>
        <span class="inputs-container"><input type="password" id="old_password" name="old_password"></span>
      </div>
      <div class="input-section">
        <label for="new_password">new password:</label>
        <span class="inputs-container"><input type="password" id="new_password" name="new_password"></span>
      </div>
      <div class="input-section">
        <label for="new_password2">new password (again):</label>
        <span class="inputs-container">
          <input type="password" id="new_password2" name="new_password2">
          <button class="pure-button" onclick={ parent.save }>save</button>
        </span>
      </div>
      <div if={ showErrorMsg } class="error-msg">{ errorMessage }</div>
    </form>
  </div>

  <script type="es6">
    let RiotControl = require('riotcontrol');
    let self = this;

    this.genericErrorMsg = 'An error occured on the server. Please try again.';
    
    RiotControl.on('login_changed', function(user) {
      if (user) {
        self.username = user;
        self.loggedIn = true;
      } else {
        self.loggedIn = false;
      }
      self.update();
    })

    RiotControl.on('password_error', function(error) {
      let message = '';
      if (typeof error === 'string') {
        message = error;
      } else {
        message = self.genericErrorMsg;
      }
      self.error(message);
    })

    RiotControl.on('password_success', function() {
      self.clearAll();
    })

    this.clearAll = () => {
      self.showForm = false;
      self.showErrorMsg = false;
      self.old_password.value = '';
      self.new_password.value = '';
      self.new_password2.value = '';
      self.update();
    }

    this.toggle = (e) => {
      self.showForm = !self.showForm;
    }

    this.error = (msg) => {
      if (typeof msg === 'boolean' &&
          msg === false) {

        self.showErrorMsg = false;
      } else {
        self.showErrorMsg = true;
        self.errorMessage = msg;
      }
      self.update();
    }

    this.save = (e) => {
      if (self.old_password && 
          self.new_password &&
          self.new_password2) {

        if (self.new_password.value !== self.new_password2.value) {
          self.error('Passwords don\'t match');
          return false;
        }
        self.error(false);
        RiotControl.trigger('password_change', {
          old_password: self.old_password.value,
          new_password: self.new_password.value
        });
      }
    }
  </script>
</password-change>
