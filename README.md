# Financial Control
> Simple financial control system to organize your incomes and expenses.

This project is fully responsive and you can try it on [Financial Control](https://simple-financial-control.herokuapp.com/).

![Financial Control](https://user-images.githubusercontent.com/5563768/85229764-212f5980-b3c2-11ea-9d92-e28194763984.png)

## Installation

I recommend that you use [asdf](https://github.com/asdf-vm/asdf) to install ruby.

```sh
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
```
```sh
asdf install ruby 2.6.3
```
```sh
asdf global ruby 2.6.3
```
```sh
gem install bundler
```
```sh
bundle install
```

You will need some version of [Postgres](https://www.postgresql.org/download/) installed.

```sh
bundle exec rails db:create
```
```sh
bundle exec rails db:migrate
```

I recommend that you use [Yarn](https://classic.yarnpkg.com/) to install node dependencies.

```sh
yarn install
```

And finally:
```sh
bundle exec rails server
```
