## This is JumboSmash

This project was born at Tufts University during a 24 hour hackathon from the genius of [Andrew Purcell](https://github.com/andrewpurcell), [Calvin Hopkins](https://github.com/chopki01), Sam Purcell, and [Erik Formella](https://github.com/erikformella) (me). It was created to answer the ever torturous question "Does (s)he like me?" The idea is that a user enters a list of people she likes, and if one of those people creates a list with her on it as well, both parties are sent a friendly email. No one can see a user's list.

JumboSmash was built for students at Tufts, originally just seniors since they need it the most with their limited time left. By encrypted all sensitive data with users' passwords, even people with access to the database cannot creep.

### Quickstart

If you would like to run this website yourself, you can do so for free on [Heroku](https://devcenter.heroku.com/articles/rails3). Keep in mind, it is a work in progress and some features do not work correctly yet (see below).

```sh
$ git clone git://github.com/erikformella/JumboSmash.git
$ cd JumboSmash
$ bundle install
$ rake db:migrate
$ rake db:seed
$ rails s
```

Now you can visit http://localhost:3000 in your web browser and log in as anyone listed in db/people.csv using the password 'testing'.

### Work to be done

As I mentioned before, there is a lot of work to be done. Mainly:
 - *Registration* - right now, all accounts must be pre-created
 - *Email* - people are not emailed on mutual match, only given an in app indication
 - *Mobile* - the mobile app needs to be connected to the API and tested
 - On that note, everything needs tests. way more tests
 - Also, get link for Sam's github profile for the readme
