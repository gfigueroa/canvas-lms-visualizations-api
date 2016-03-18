# Canvas LMS Class Visualizations API

Feel free to clone the repo.

### config_env.rb

To generate the `MSG_KEY` for the config_env, simply run `rake keys_for_config` from the terminal and copy the generated keys to config_env.rb.

### Gems & DB

To get up and running on localhost, run `rake` from the terminal.
- This will install the required gems.
- The Rakefile has additional commands to help with deployment to heroku.

### Routes

- Home route.
- `/courses/` requires:
  - a Canvas url like http[s]://URI/ passed in the `url` parameter. If your Canvas class is hosted on https://canvas.instructure.com/, there is no need to include this argument; and
  - a Canvas token passed in the `token` paramater.
- `/courses/:course_id/:data/?` requires:
  - a Canvas url like http[s]://URI/ passed in the `url` parameter. If your Canvas class is hosted on https://canvas.instructure.com/, there is no need to include this argument;
  - a `course_id` passed in the url; and
  - a `data` field passed in the url. This field determines what information the api attempts to get from your Canvas installation. The possible options and can be found in the [data table](#data) below.
  - a Canvas token passed in the `token` paramater;

### Data

Option              | Sample request                       | What it returns
------------------- | ------------------------------------ | ---------------------------------------
`activity`          | `/courses/505942/activity/`          | Course Level Participation & Views data
`users`             | `/courses/505942/users/`             | User Level Participation & Views data
`assignments`       | `/courses/505942/assignments/`       | Course Level Assignment data
`quizzes`           | `/courses/505942/quizzes/`           | Quiz data
`discussion_topics` | `/courses/505942/discussion_topics/` | List of discussions from users
`student_summaries` | `/courses/505942/student_summaries/` | Summary of student page views, discussions, and assignment submission lateness.
`enrollments`       | `/courses/505942/enrollments/`       | List of enrolled students
