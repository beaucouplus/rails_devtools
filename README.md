# Rails Devtools

Rails Devtools is a set of "quality of life" tools for your rails project, distributed as a rails engine.
This is inspired by the likes of Nuxt Devtools, Laravel Telescope...

This gem is meant to be only used in development, and cannot work at all in production.

> [!IMPORTANT]
> The gem is an alpha version. Is has been tested on several Rails projects from Rails 7.1 to Rails 8.0. It should work on many projects but it could also break easily if your project has some tricky stuff I didn't think about.
> If you encounter a bug, please create an issue, I'll do my best to fix it.

<br />

## Installation

- Add the gem to your Gemfile
```ruby
  gem 'rails_devtools, group: :development'
````

- Mount the engine in your routes
```ruby
 mount RailsDevtools::Engine => "/devtools"
```

- Update the bundle
 ```sh
bundle install
```
- Go to `http://localhost:3000/devtools`

<br /><br />

 ## Screenshots
<details>
<summary> Expand to see more screnshots
 <br /><br />
<img width="1187" alt="devtools_database_tables" src="https://github.com/user-attachments/assets/a5289293-c8c1-475c-abb2-b3c3f322c281" />
</summary>
<img width="1191" alt="devtools_gems" src="https://github.com/user-attachments/assets/204293e5-3eaf-400d-99e9-74e493571997" />
<img width="1194" alt="devtools_image_assets" src="https://github.com/user-attachments/assets/f6b41437-9ea4-4d0e-b1d5-3aff9c156730" />
<img width="1188" alt="devtools_routes" src="https://github.com/user-attachments/assets/9bcd8435-cc7e-48a3-8a71-83b2ee99afd7" />
<img width="459" alt="devtools_routes_responsive" src="https://github.com/user-attachments/assets/e3e3ff2d-a54e-4e45-9618-1653d4291d0c" />
<img width="474" alt="devtools_routes_details_responsive" src="https://github.com/user-attachments/assets/a245e2d0-23d1-4a19-b871-a738a68cd83a" />
</details>
<br /><br />

## Features

Rails Devtools are fully responsive. I think of them as a companion to my editing efforts and I want to be able to put them next to my IDE.

#### Database tables
- List all your database tables along with their columns and indexes.
- Search for tables or columns

#### Routes
- List all your application routes
- Display details about it, along with helpful actions and snippets
- Warn if a route is not linked to a controller / action (details provide more information)
- Search for routes by name

#### Image assets
Since there are quite a few asset pipelines in the rails ecosystem, Rails Devtools detects which one is used and adapts its behavior to it. It supports Propshaft, Sprockets, Shakapacker, JS-Bundling-Rails and Vite-Rails.

- list image assets in your codebase
- Display information about them, along with helpful actions and snippets
- Search for images by name

#### Gems
- list gems in your bundle
- display their summary
- display links to their code source, website...
- display outdated gems along with information about the last version
- search for gems by name
<br /><br />
> [!NOTE]
> Most of those features are starting points. There are many ways to get a better grasp of a rails codebase. I have some in mind but if you happen to have ideas, feel free to share them in the discussions!

<br /><br />
## Philosophy

As developers, we spend much of our time looking at walls of text. Our codebase does not provide any information architecture, besides classes or methods. There is no high level view of the project, and most of the tooling is either a bunch of commands to run or a script found on stackoverflow.

Rails, as a framework, knows many things about our project. This might seem obvious but it knows how to match a route and a controller, what path you need to write to use an image, or what scopes are defined on a model.

When you run `rails s`, all those informations are available. But they are hidden behind the mysteries of ActiveRecord, Rails.application and so on.

This is why I believe that it makes a lot of sense to provide tools that surface these informations when needed, in a friendly way.

<br /><br />
## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
