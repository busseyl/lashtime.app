<template>
  <v-container>
    <v-form v-model="valid">
      <div class="text-xs-center pa-0 ma-0">
        <img
          src="static/img/eyes.png"
          contain
        />
        <div
          class="display-1 pt-0 mt-0"
          style="font-family: 'Dancing Script', cursive !important;"
        >
          Lash Time
        </div>
        <div class="subheading text-xs-center pt-5 pb-2">
          Please sign in
        </div>
      </div>
      <v-row>
        <v-col cols="12" md="4" offset-md="4">
          <v-text-field
            label="Email address"
            v-model="identity"
            hide-details
            @keyup="emailKeyUp"
          ></v-text-field>
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="12" md="4" offset-md="4">
          <v-text-field
            type="password"
            label="Password"
            v-model="password"
            hide-details
            @keyup="passwordKeyUp"
            ref="passwordField"
          ></v-text-field>
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="12" md="4" offset-md="4">
          <v-btn
            :class="{'primary':!showPassword}"
            block
            @click="passwordSignIn"
            :loading="loading"
          >Sign in</v-btn>
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="12" md="4" offset-md="4">
          <div v-if="response.length" class="text-xs-center">{{response}}</div>
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="12" md="4" offset-md="4" class="text-xs-right">
          <v-btn
            text
            small
            class="primary--text"
            :to="{ name: 'ForgotPassword', params: { identity } }"
          >Forgot password?</v-btn>
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="12" md="4" offset-md="4" class="text-xs-right">
          <v-btn
            text
            small
            class="primary--text"
            :to="{ name: 'Register', params: { identity }}"
          >Need to sign up?</v-btn>
        </v-col>
      </v-row>
    </v-form>
  </v-container>
</template>

<script>
export default {
  name: 'Login',
  data () {
    return {
      section: 'Login',
      loading: false,
      response: '',
      identity: '',
      password: '',
      showPassword: false
    }
  },
  computed: {
    page () {
      return {
        name: 'Login',
        value: 'login'
      }
    }
  },
  methods: {
    emailKeyUp (e) {
      if (e.key === 'Enter') this.passwordSignIn()
    },
    passwordKeyUp (e) {
      if (e.key === 'Enter') this.passwordSignIn()
    },
    passwordSignIn () {
      console.log(`Processing login: ${this.identity}`)
      this.loading = true
      this.resetResponse()
      return fetch(`${this.$api.url}/auth`, {
        method: 'POST',
        mode: 'cors',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          'identity': this.identity,
          'password': this.password
        })
      })
        .then(res => this.onFetch(res))
        .then(user => this.success(user))
        .catch(err => this.error(err))
    },
    onFetch (response) {
      console.log(`login:response`, response)
      if (response.ok) {
        switch (response.status) {
          case 200: // POST - OK
          case 201: // POST - Created
          case 204: // PUT - No Content
            return response.json()
          default:
            return Promise.reject(response.statusText)
        }
      } else {
        return Promise.reject(response.statusText)
      }
    },
    success (data) {
      console.log(`login:success`, data)

      this.toggleLoading()
      this.resetResponse()

      // Save state
      this.$store.commit('setProfile', data.profile)
      this.$store.commit('setAuthToken', data.token)
      this.$store.commit('setLoggedIn', true)

      // redirect to the dashboard
      return this.$router.replace({ name: 'Calendar' })
    },
    error (response) {
      console.error(`login:error`, response)
      this.toggleLoading()
      this.response = response
    },
    toggleLoading () {
      this.loading = !this.loading
    },
    resetResponse () {
      this.response = ''
    }
  },
  mounted () {
    console.log(`mounted:${this.page.value}`, this)
    this.$store.commit('setLoggedIn', false)
    this.$store.commit('setAuthToken', null)
  }
}
</script>

<style>
</style>
