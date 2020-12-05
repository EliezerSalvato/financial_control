# Financial Control
> Simple financial control system to organize your incomes and expenses.

This project is fully responsive and you can try it on [Financial Control](https://simple-financial-control.herokuapp.com/).

![Financial Control](https://user-images.githubusercontent.com/5563768/85229764-212f5980-b3c2-11ea-9d92-e28194763984.png)

## Stack

**Ruby** (v2.7.2), **Rails** (v6.0.3), **VueJS** (v2), **PostgresSQL** (v12)

## Setup

Financial Control uses [Docker](https://docs.docker.com/get-docker/)

Create a copy of `docker-compose.sample.yml`, name it `docker-compose.yml` (change accordingly).

First, run the command below to build the project correctly:
```sh
make build
```

Second, run the command below to create the database and run the migrations:
```sh
make firstrun
```

That's it, access http://localhost:3000/ and have fun!

After this you can just start or stop your project.

To start the project run:
```sh
make start
```

To stop the project run:
```sh
make stop
```

See [Makefile](Makefile) for other existing commands.
