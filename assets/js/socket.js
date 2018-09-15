// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {chat_id: window.chatId}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("messenger:lobby", {})
let messagesStorage = []
let usersStorage = []

document.querySelector("#new-message").addEventListener('submit', (e) => {
  e.preventDefault()
  let messageInput = e.target.querySelector('#message-content')
  channel.push('message:add', { message: messageInput.value})
  clearForm()
});

const clearForm = function (){
  document.querySelector("#message-content").value = ''
};

const updateUsersStorage = function(){
  usersStorage = messagesStorage.map(it => {
    return it.chat_id
  });

  usersStorage = [...new Set(usersStorage)]
};

channel.on("messenger:lobby:all_messages", (data) => {
  messagesStorage = data.messages;
  updateUsersStorage();
  // reloadUsersList();
  reloadMessages();
});

channel.on("messenger:lobby:new_message", (message) => {
  let chat_id = new URLSearchParams(window.location.search).get('chat_id')
  if (message.chat_id.toString() === chat_id || message.chat_id === 1) {
    messagesStorage = [...messagesStorage, message];
    // reloadUsersList();
    reloadMessages();
  }
});

const reloadMessages = function () {
  document.querySelector("#messages").innerHTML = '';
  for (var message of messagesStorage) {
    renderMessage(message)
  }
};

const reloadUsersList = function () {
  document.querySelector("#users").innerHTML = '';
  for (var chat_id of usersStorage) {
    renderUser(chat_id)
  }
}

const renderMessage = function(message) {
  let messageTemplate = `
    <li class="list-group-item" id="message-${message.id}">
      <strong>${message.username}</strong>:
      ${message.body}
    </li>
  `
  document.querySelector("#messages").innerHTML += messageTemplate
};

const renderUser = function(id) {
  if (id !== 1) {
    let userTemplate = `
    <li id="user-chat-id-${id}">
        <a href="/?chat_id=${id}">${id}</a>
    </li>
  `
    document.querySelector("#users").innerHTML += userTemplate
  }
};

channel.join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp)
    document.querySelector("#new-message").classList.remove('hidden')
  })
  .receive("error", resp => {
    console.log("Unable to join", resp)
    document.querySelector("#new-message").classList.add('hidden')
  })

export default socket
