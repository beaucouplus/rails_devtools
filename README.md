Devtools is a set of "quality of life" tools for your rails project, distributed as a rails engine. 
This is inspired by the likes of Nuxt Devtools, Laravel Telescope...

This gem is meant to be only used in development, and cannot work at all in production. 

> [!IMPORTANT] 
> The gem is an alpha version. It should work on many projects but it could also break easily if your project has some tricky stuff I didn't think about.
> If you encounter a bug, please create an issue, I'll do my best to fix it.

 
## Installation

- Add the gem to your Gemfile
```ruby
  gem 'rails-devtools, group: :development'
````

- Mount the engine in your routes
```ruby
 mount Devtools::Engine => "/devtools"
```

- Run `bundle install`
- Go to `http://localhost:3000/devtools` 


## Screenshots


## Features

#### Database tables
- List all your database tables along with their columns and indexes.
- Search for tables or columns

#### Routes
- List all your application routes
- Display details about it, along with helpful actions
- Warn if a route is not linked to a controller / action (details provide more information)
- Search for routes by name

#### Image assets
- list image assets in your codebase
- Display information about them, along with helpful actions
- Search for images by name

#### Gems
- list gems in your bundle
- display their summary
- display links to their code source, website...
- display outdated gems along with information about the last version
- search for gems by name

> [!NOTE]
> Most of those features are starting points. There are many ways to get a better grasp of a rails codebase. I have some in mind but If you happen to have ideas, feel free to share them in the discussions!  


## Philosophy

As developers, we spend much of our time looking at walls of text. Our codebase does not provide any information architecture, besides classes or methods. There is no high level view of the project, and most of the tooling is either a bunch of commands to run or a script found on stackoverflow.

Rails, as a framework, knows many things about our project. This might seem obvious but it knows how to match a route and a controller, what path you need to write to use an image, or what scopes are defined on a model.

When you run `rails s`, all those informations are available. But they are hidden behind the mysteries of ActiveRecord, Rails.application and so on.

This is why I believe that it makes a lot of sense to provide tools that surface these informations when needed, in a friendly way.


## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


