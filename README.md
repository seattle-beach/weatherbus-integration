# Weatherbus Integration

Integration tests for Weatherbus

## Installation

```
git clone https://github.com/seattle-beach/weatherbus-integration.git
bundle install
rake setup
```

## Usage

### Deploying to staging

Running `rake deploy` will deploy to staging. This will deploy all the weatherbus microservices with the latest commit
that has successfully passed in Travis. The deployed commit can be overridden using environment variables such as
`DEPLOY_WEATHERBUS_BUS=abc123`.

### Running specs

1. If you're testing local instances, make sure the weatherbus app and the web server for the web front-end are running.
2. Run `rake`.
3. Can also run against the deployed services and/or web app by setting the svcenv and/or appenv environment variables,
   e.g. `svcenv=acceptance rake`. Note that if you use the local app (appenv=local), then svcenv must match the
   environment that the app was built against in step 1.
