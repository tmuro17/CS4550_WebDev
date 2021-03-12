# Events

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Attributions:
Includes code from and based on Prof Tuck's in-class PhotoBlog example.


## Design Decisions: 
- Event owners are not allowed to post comments, only invitees are allowed to do that
- The homepage shows events that you own or are invited to
    - You cannot really do anything of meaning unless you are signed in
- If you are not signed and try to access certain resources, you will be redirected
- If you try to access the comments or invite index page, you will be redirected
    - Access to comments and invites is intended to be through the linked event
- Comments cannot be edited, if you want to change the content of the comment, just delete it and create a new one
- People cannot be uninvited from an event (Social faux-pas preventer)
