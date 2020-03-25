# auto-rswag
Automatically convert your Rspec test responses to Rswag format and let your docs write themselves!

# Demo
![gif](https://imgur.com/Oi92D9v.gif)

# Requirements

- [rspec](https://github.com/rspec/rspec)
- [rswag](https://github.com/rswag/rswag)

# Installation
In Gemfile:

```ruby
  gem 'auto-rswag'
```

Then:

```
bundle install
```

Add to `spec/spec_helper.rb` below `require 'rspec/rails'`:

```ruby
  require 'auto-rswag'
```

That's it!

# Usage
Anywhere you'd like to automatically document your responses, you'll need add `update_documentation` to your test. For instance, here's a sample spec file:

```ruby
# spec/integration/games_spec.rb
# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Games API', type: :request, swagger_doc: 'v1/swagger.json' do
  path '/games' do
    get 'Retrieves a record' do
      tags 'Games'
      produces 'application/json'

      response '200', 'game found' do
        schema '$ref' => '#/definitions/game_index_response'
        update_documentation # This needs to come before run_test!
        run_test!
      end
    end
  end
end
```

For now you also need to manually add a new `definition` to `spec/swagger_helper.rb` that matches your response schema:

```ruby
# From the above example, the schema is:
# schema '$ref' => '#/definitions/game_index_response'

config.swagger_docs = {
  'v1/swagger.json' => {
    openapi: '3.0.1',
    info: {
      title: 'API V1',
      version: 'v1',
      description: 'Test API Documentation'
    },
    basePath: '/',
    definitions: {
      game_index_response: {} # This should be a blank hash with title 'game_index_response'
    },
    paths: {}
  }
}
```

Then, you can just run your specs normally, and generate your docs:

```
bundle exec rspec
rake rswag
```

# TODO:

 - [ ] Working to support changes to Rswag & Swagger/OpenApi Specification 3.0
 - [ ] Needs tests!
 - [ ] Convert `DocWriter` class to abstract syntax tree instead of regex/strings
 - [ ] Handle missing definitions fragment in `swagger_helper.rb` (so we don't have to manually create one for new specs)
 - [ ] Set up CI for gem builds
