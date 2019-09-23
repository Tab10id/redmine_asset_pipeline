Redmine Plugin Asset Pipeline plugin
=============================

This plugin adds asset pipeline features to Redmine and Redmine plugins.

For who ?
---------
This plugin only targets plugin developers. You shouldn't try to install this without a
deep understanding of the benefits and the way to make it work.

Why ?
-----
By default, Redmine not support asset pipeline feature (many rewrites of standard rails
functionality).

Having the asset pipeline enabled would be interesting though if you have a lot of plugins
or when you want to have possibility for normal usage different preprocessors like sass,
less, CoffeeScript.

How ?
-----
The plugin try to restore normal pipeline functionality in Redmine and add some features
for comfortable Redmine plugins development.

Features of this plugin
-----------------------
* serve main app assets with the asset pipeline
* serve plugin assets with the asset pipeline
* ability for concatenate .css and .js assets in one file (just create `_common_application.(js/css)`
  in your plugin and use sprocket directives in those files, than create aggregating css/js in one
  of your plugin and use sprocket directive require_redmine_plugins on it)
  e.g. `//= require_redmine_plugins javascripts` for js
* minify assets in the pipeline
* support digest option of asset pipeline config
* in development environment you have assets src directory than have symlinks to the plugin
  directories, so you don't need run `redmine:plugins:assets` or restart server every time
  when you edit asset in your plugin

Known problems
--------------
* Redmine themes are not processed through the pipeline
* Plugin code looks a little ugly

Installation
------------

This plugin is only compatible with Redmine 2.1.0+. It is distributed as a ruby gem.

Add this line to your redmine's Gemfile:

    gem 'redmine_plugin_asset_pipeline'

And then execute:

    $ bundle install

Configure assets in your application (core `Redmine config/application.rb`)
Unfortunately you can't configure pipeline in gem or in redmine plugin, many gems may work
wrong if pipeline functionality enabled not in application (according to order of gem loading).

You can set `config.assets.paths` to public directory of Redmine but that can provoke some
problems with preprocessors (if you precompile assets).
Also problems may occur if you leave standard Redmine assets in root of public (possible
conflicts with rails routes).

Our recommendations:

* Move redmine assets to directory `private/assets` (simple create it in root of Redmine)
* Run `rails generate redmine_pipeline:private_assets_initializer` (that create initializers
  `09-save_original_path_to_asset`, `15-restore_original_path_to_asset` and `28-patch_redmine_plugin_for_sprockets`, that patch Plugin class of Redmine for copy plugin assets to
  private directory and cancel redmine patch that broke sprockets)
* Fix standard Redmine \*.css files (some paths in css hardcoded to the public root)

Then restart your Redmine instance.

Note that general instructions for plugins [here](http://www.redmine.org/wiki/redmine/Plugins) don't apply here.

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
