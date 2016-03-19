# Canvas LMS Class Visualizations API

Feel free to clone the repo.

### config_env.rb

To generate the `MSG_KEY`, and the <em>Public and Private Keys</em> for the config_env file, simply run `rake keys_for_config` from the terminal and copy the generated keys to config_env.rb.

### Gems & DB

To get up and running on localhost, run `rake` from the terminal.
- This will install the required gems.
- The Rakefile has additional commands to help with deployment to heroku.

### Routes

- Home route.
- `/encrypt_token`: This is an absolute requirement to use the API. We encrypt and sign your Canvas token (using public key cryptography) and return a Base64 encoded string you can use to access other routes. To pass in the Canvas token for encryption, pass the token as a bearer token in the HTTP 'AUHTORIZATION' header.
  - Sample command line usage: `curl --header "AUTHORIZATION: Bearer my_canvas_token" localhost:9292/encrypt_token`
  - You must pass the received string using the same method for all remaining API routes: `curl --header "AUTHORIZATION: Bearer enrypted_string" localhost:9292/[any_other_route]`
- `/courses` requires:
  - a Canvas url like http[s]://URI/ passed in the `url` parameter. If your Canvas class is hosted on https://canvas.instructure.com/, there is no need to include this argument; and
  - an encrypted form of your Canvas token obtained using the `/encrypt_token` route.
- `/courses/:course_id/:data` requires:
  - a Canvas url like http[s]://URI/ passed in the `url` parameter. If your Canvas class is hosted on https://canvas.instructure.com/, there is no need to include this argument;
  - a `course_id` passed in the url; and
  - a `data` field passed in the url. This field determines what information the api attempts to get from your Canvas installation. The possible options and can be found in the [data table](#data) below.
  - an encrypted form of your Canvas token obtained using the `/encrypt_token` route.

### Data

Option              | Sample request                      | What it returns
------------------- | ----------------------------------- | ---------------------------------------
`activity`          | `/courses/505942/activity`          | Course Level Participation & Views data
`users`             | `/courses/505942/users`             | User Level Participation & Views data
`assignments`       | `/courses/505942/assignments`       | Course Level Assignment data
`quizzes`           | `/courses/505942/quizzes`           | Quiz data
`discussion_topics` | `/courses/505942/discussion_topics` | List of discussions from users
`student_summaries` | `/courses/505942/student_summaries` | Summary of student page views, discussions, and assignment submission lateness.
`enrollments`       | `/courses/505942/enrollments`       | List of enrolled students
